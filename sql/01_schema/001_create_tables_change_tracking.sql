-- Enable Change Tracking on database
ALTER DATABASE CURRENT
SET CHANGE_TRACKING = ON
(CHANGE_RETENTION = 7 DAYS, AUTO_CLEANUP = ON);
GO

-- Create source table
CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    City NVARCHAR(100),
    LastUpdated DATETIME2 DEFAULT GETDATE()
);
GO

-- Enable Change Tracking on source table
ALTER TABLE dbo.Customers
ENABLE CHANGE_TRACKING
WITH (TRACK_COLUMNS_UPDATED = ON);
GO

-- Create target table
CREATE TABLE dbo.Customers_ETL (
    CustomerID INT,
    FullName NVARCHAR(100),
    City NVARCHAR(100),
    LastUpdated DATETIME2,
    LoadDate DATETIME2 DEFAULT GETDATE()
);
GO