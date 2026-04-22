CREATE TABLE dbo.ETL_Watermark (
    TableName NVARCHAR(100) PRIMARY KEY,
    LastProcessedVersion BIGINT
);
GO

INSERT INTO dbo.ETL_Watermark (TableName, LastProcessedVersion)
VALUES ('Customers', 0);
GO

SELECT * FROM dbo.ETL_Watermark;
GO