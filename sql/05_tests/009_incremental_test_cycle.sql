MERGE dbo.Customers_ETL AS target
USING (
    SELECT
        SYS_CHANGE_VERSION,
        SYS_CHANGE_OPERATION,
        CustomerID,
        FullName,
        City,
        LastUpdated
    FROM dbo.Customers_Changes_Stage
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
GO

SELECT * 
FROM dbo.Customers_ETL
ORDER BY CustomerID;
GO