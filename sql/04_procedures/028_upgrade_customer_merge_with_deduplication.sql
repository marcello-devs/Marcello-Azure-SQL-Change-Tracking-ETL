CREATE OR ALTER PROCEDURE dbo.usp_Merge_Customers_Changes
AS
BEGIN
    SET NOCOUNT ON;

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

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO