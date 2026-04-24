CREATE OR ALTER PROCEDURE dbo.usp_Merge_Orders_Changes
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
                OrderID,
                CustomerID,
                OrderDate,
                OrderStatus,
                TotalAmount,
                LastUpdated,
                ROW_NUMBER() OVER (
                    PARTITION BY OrderID
                    ORDER BY SYS_CHANGE_VERSION DESC
                ) AS rn
            FROM dbo.Orders_Changes_Stage
            WHERE OrderID IS NOT NULL
        )
        MERGE dbo.Orders_ETL AS target
        USING (
            SELECT *
            FROM DedupedSource
            WHERE rn = 1
        ) AS source
        ON target.OrderID = source.OrderID

        WHEN MATCHED AND source.SYS_CHANGE_OPERATION = 'D' THEN
            DELETE

        WHEN MATCHED AND source.SYS_CHANGE_OPERATION IN ('I', 'U') THEN
            UPDATE SET
                target.CustomerID = source.CustomerID,
                target.OrderDate = source.OrderDate,
                target.OrderStatus = source.OrderStatus,
                target.TotalAmount = source.TotalAmount,
                target.LastUpdated = source.LastUpdated,
                target.LoadDate = GETDATE()

        WHEN NOT MATCHED BY TARGET AND source.SYS_CHANGE_OPERATION IN ('I', 'U') THEN
            INSERT (OrderID, CustomerID, OrderDate, OrderStatus, TotalAmount, LastUpdated, LoadDate)
            VALUES (source.OrderID, source.CustomerID, source.OrderDate, source.OrderStatus, source.TotalAmount, source.LastUpdated, GETDATE());

        SET @RowsMerged = @@ROWCOUNT;

        ;WITH LatestStarted AS (
            SELECT TOP (1) ETLRunID
            FROM dbo.ETL_Run_Log
            WHERE PipelineName = 'PL_Load_Order_Changes'
              AND TableName = 'Orders'
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