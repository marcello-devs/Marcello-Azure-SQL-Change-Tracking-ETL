CREATE TABLE dbo.Customers_Changes_Stage (
    SYS_CHANGE_VERSION BIGINT,
    SYS_CHANGE_OPERATION NCHAR(1),
    CustomerID INT,
    FullName NVARCHAR(100),
    City NVARCHAR(100),
    LastUpdated DATETIME2
);
GO

SELECT * FROM dbo.Customers_Changes_Stage;
GO