CREATE OR ALTER PROCEDURE dbo.usp_Log_ETL_Run_Failure
    @PipelineName NVARCHAR(200),
    @TableName NVARCHAR(100),
    @ErrorMessage NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

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
        RunStatus = 'Failed',
        EndTime = GETDATE(),
        ErrorMessage = @ErrorMessage
    FROM dbo.ETL_Run_Log l
    INNER JOIN LatestStarted s
        ON l.ETLRunID = s.ETLRunID;
END;
GO