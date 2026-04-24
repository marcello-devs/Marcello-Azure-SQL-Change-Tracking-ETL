CREATE OR ALTER PROCEDURE dbo.usp_Merge_OrderItems_Changes
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
                OrderItemID,
                OrderID,
                ProductID,
                Quantity,
                UnitPrice,
                LineAmount,
                LastUpdated,
                ROW_NUMBER() OVER (
                    PARTITION BY OrderItemID
                    ORDER BY SYS_CHANGE_VERSION DESC
                ) AS rn
            FROM dbo.OrderItems_Changes_Stage
            WHERE OrderItemID IS NOT NULL
        )
        MERGE dbo.OrderItems_ETL AS target
        USING (
            SELECT *
            FROM DedupedSource
            WHERE rn = 1
        ) AS source
        ON target.OrderItemID = source.OrderItemID

        WHEN MATCHED AND source.SYS_CHANGE_OPERATION = 'D' THEN
            DELETE

        WHEN MATCHED AND source.SYS_CHANGE_OPERATION IN ('I', 'U') THEN
            UPDATE SET
                target.OrderID = source.OrderID,
                target.ProductID = source.ProductID,
                target.Quantity = source.Quantity,
                target.UnitPrice = source.UnitPrice,
                target.LineAmount = source.LineAmount,
                target.LastUpdated = source.LastUpdated,
                target.LoadDate = GETDATE()

        WHEN NOT MATCHED BY TARGET AND source.SYS_CHANGE_OPERATION IN ('I', 'U') THEN
            INSERT (OrderItemID, OrderID, ProductID, Quantity, UnitPrice, LineAmount, LastUpdated, LoadDate)
            VALUES (source.OrderItemID, source.OrderID, source.ProductID, source.Quantity, source.UnitPrice, source.LineAmount, source.LastUpdated, GETDATE());

        SET @RowsMerged = @@ROWCOUNT;

        ;WITH LatestStarted AS (
            SELECT TOP (1) ETLRunID
            FROM dbo.ETL_Run_Log
            WHERE PipelineName = 'PL_Load_OrderItem_Changes'
              AND TableName = 'OrderItems'
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