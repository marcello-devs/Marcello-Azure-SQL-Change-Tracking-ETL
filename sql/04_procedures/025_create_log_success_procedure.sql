CREATE OR ALTER PROCEDURE dbo.usp_Log_ETL_Run_Success
    @PipelineName NVARCHAR(200),
    @TableName NVARCHAR(100),
    @RowsCopied INT = NULL,
    @RowsMerged INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WatermarkAfter BIGINT;

    SELECT @WatermarkAfter = LastProcessedVersion
    FROM dbo.ETL_Watermark
    WHERE TableName = @TableName;

    ;WITH LatestStarted AS (
        SELECT TOP (1) ETLRunID
        FROM dbo.ETL_Run_Log
        WHERE PipelineName = @PipelineName
          AND TableName = @TableName
          AND RunStatus = 'Started'
        ORDER BY ETLRunID DESC
    )
    UPDATE l
    SET
        RunStatus = 'Succeeded',
        EndTime = GETDATE(),
        RowsCopied = @RowsCopied,
        RowsMerged = @RowsMerged,
        WatermarkAfter = @WatermarkAfter
    FROM dbo.ETL_Run_Log l
    INNER JOIN LatestStarted s
        ON l.ETLRunID = s.ETLRunID;
END;
GO