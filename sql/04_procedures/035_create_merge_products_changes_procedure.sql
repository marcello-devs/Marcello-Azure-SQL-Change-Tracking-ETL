CREATE OR ALTER PROCEDURE dbo.usp_Merge_Products_Changes
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RowsMerged INT = 0;

    BEGIN TRY
        BEGIN TRANSACTION;

        ;WITH DedupedSource AS (
            SELECT
                SYS_CHANGE_VERSION,
                SYS_CHANGE_OPERATION,
                ProductID,
                ProductName,
                Category,
                UnitPrice,
                IsActive,
                LastUpdated,
                ROW_NUMBER() OVER (
                    PARTITION BY ProductID
                    ORDER BY SYS_CHANGE_VERSION DESC
                ) AS rn
            FROM dbo.Products_Changes_Stage
            WHERE ProductID IS NOT NULL
        )
        MERGE dbo.Products_ETL AS target
        USING (
            SELECT
                SYS_CHANGE_VERSION,
                SYS_CHANGE_OPERATION,
                ProductID,
                ProductName,
                Category,
                UnitPrice,
                IsActive,
                LastUpdated
            FROM DedupedSource
            WHERE rn = 1
        ) AS source
        ON target.ProductID = source.ProductID

        WHEN MATCHED AND source.SYS_CHANGE_OPERATION = 'D' THEN
            DELETE

        WHEN MATCHED AND source.SYS_CHANGE_OPERATION IN ('I', 'U') THEN
            UPDATE SET
                target.ProductName = source.ProductName,
                target.Category = source.Category,
                target.UnitPrice = source.UnitPrice,
                target.IsActive = source.IsActive,
                target.LastUpdated = source.LastUpdated,
                target.LoadDate = GETDATE()

        WHEN NOT MATCHED BY TARGET AND source.SYS_CHANGE_OPERATION IN ('I', 'U') THEN
            INSERT (ProductID, ProductName, Category, UnitPrice, IsActive, LastUpdated, LoadDate)
            VALUES (source.ProductID, source.ProductName, source.Category, source.UnitPrice, source.IsActive, source.LastUpdated, GETDATE());

        SET @RowsMerged = @@ROWCOUNT;

        ;WITH LatestStarted AS (
            SELECT TOP (1) ETLRunID
            FROM dbo.ETL_Run_Log
            WHERE PipelineName = 'PL_Load_Product_Changes'
              AND TableName = 'Products'
              AND RunStatus = 'Started'
            ORDER BY ETLRunID DESC
        )
        UPDATE l
        SET RowsMerged = @RowsMerged
        FROM dbo.ETL_Run_Log l
        INNER JOIN LatestStarted s
            ON l.ETLRunID = s.ETLRunID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO