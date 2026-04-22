IF NOT EXISTS (SELECT 1 FROM dbo.ETL_Watermark WHERE TableName = 'Products')
BEGIN
    INSERT INTO dbo.ETL_Watermark (TableName, LastProcessedVersion)
    VALUES ('Products', 0);
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.ETL_Watermark WHERE TableName = 'Orders')
BEGIN
    INSERT INTO dbo.ETL_Watermark (TableName, LastProcessedVersion)
    VALUES ('Orders', 0);
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.ETL_Watermark WHERE TableName = 'OrderItems')
BEGIN
    INSERT INTO dbo.ETL_Watermark (TableName, LastProcessedVersion)
    VALUES ('OrderItems', 0);
END;
GO

SELECT *
FROM dbo.ETL_Watermark
WHERE TableName IN ('Customers', 'Products', 'Orders', 'OrderItems')
ORDER BY TableName;
GO