CREATE OR ALTER PROCEDURE dbo.usp_Merge_Customers_Changes
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
                CustomerID,
                FullName,
                City,
                LastUpdated,
                ROW_NUMBER() OVER (
                    PARTITION BY CustomerID
                    ORDER BY SYS_CHANGE_VERSION DESC
                ) AS rn
            FROM dbo.Customers_Changes_Stage
            WHERE CustomerID IS NOT NULL
        )
        MERGE dbo.Customers_ETL AS target
        USING (
            SELECT
                SYS_CHANGE_VERSION,
                SYS_CHANGE_OPERATION,
                CustomerID,
                FullName,
                City,
                LastUpdated
            FROM DedupedSource
            WHERE rn = 1
        ) AS source
        ON target.CustomerID = source.CustomerID

        WHEN MATCHED AND source.SYS_CHANGE_OPERATION = 'D' THEN
            DELETE

        WHEN MATCHED AND source.SYS_CHANGE_OPERATION IN ('I', 'U') THEN
            UPDATE SET
                target.FullName = source.FullName,
                target.City = source.City,
                target.LastUpdated = source.LastUpdated,
                target.LoadDate = GETDATE()

        WHEN NOT MATCHED BY TARGET AND source.SYS_CHANGE_OPERATION IN ('I', 'U') THEN
            INSERT (CustomerID, FullName, City, LastUpdated, LoadDate)
            VALUES (source.CustomerID, source.FullName, source.City, source.LastUpdated, GETDATE());

        SET @RowsMerged = @@ROWCOUNT;

        ;WITH LatestStarted AS (
            SELECT TOP (1) ETLRunID
            FROM dbo.ETL_Run_Log
            WHERE PipelineName = 'PL_Load_Customer_Changes'
              AND TableName = 'Customers'
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