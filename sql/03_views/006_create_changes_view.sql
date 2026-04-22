CREATE OR ALTER VIEW dbo.vw_Customers_Changes
AS
SELECT
    ct.SYS_CHANGE_VERSION,
    ct.SYS_CHANGE_OPERATION,
    c.CustomerID,
    c.FullName,
    c.City,
    c.LastUpdated
FROM CHANGETABLE(CHANGES dbo.Customers, 0) AS ct
LEFT JOIN dbo.Customers AS c
    ON c.CustomerID = ct.CustomerID;
GO

SELECT * 
FROM dbo.vw_Customers_Changes
ORDER BY SYS_CHANGE_VERSION;
GO

