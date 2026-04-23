CREATE OR ALTER PROCEDURE dbo.usp_Log_ETL_Run_Start
    @PipelineName NVARCHAR(200),
    @TableName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WatermarkBefore BIGINT;

    SELECT @WatermarkBefore = LastProcessedVersion
    FROM dbo.ETL_Watermark
    WHERE TableName = @TableName;

    INSERT INTO dbo.ETL_Run_Log (
        PipelineName,
        TableName,
        RunStatus,
        StartTime,
        WatermarkBefore
    )
    VALUES (
        @PipelineName,
        @TableName,
        'Started',
        GETDATE(),
        @WatermarkBefore
    );
END;
GO