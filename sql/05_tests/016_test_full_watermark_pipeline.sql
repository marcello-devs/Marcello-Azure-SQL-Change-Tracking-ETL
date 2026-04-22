SELECT *
FROM dbo.Customers_Changes_Stage
ORDER BY SYS_CHANGE_VERSION, CustomerID;
GO

SELECT *
FROM dbo.Customers_ETL
ORDER BY CustomerID;
GO

SELECT *
FROM dbo.ETL_Watermark;
GO