CREATE TABLE dbo.ETL_Run_Log (
    ETLRunID INT IDENTITY(1,1) PRIMARY KEY,
    PipelineName NVARCHAR(200) NOT NULL,
    TableName NVARCHAR(100) NOT NULL,
    RunStatus NVARCHAR(30) NOT NULL,
    StartTime DATETIME2 NOT NULL DEFAULT GETDATE(),
    EndTime DATETIME2 NULL,
    RowsCopied INT NULL,
    RowsMerged INT NULL,
    ErrorMessage NVARCHAR(MAX) NULL,
    WatermarkBefore BIGINT NULL,
    WatermarkAfter BIGINT NULL
);
GO

SELECT *
FROM dbo.ETL_Run_Log;
GO