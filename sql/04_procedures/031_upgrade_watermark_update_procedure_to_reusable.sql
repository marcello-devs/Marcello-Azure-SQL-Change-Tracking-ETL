CREATE OR ALTER PROCEDURE dbo.usp_Update_ETL_Watermark
    @TableName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.ETL_Watermark
    SET LastProcessedVersion = CHANGE_TRACKING_CURRENT_VERSION()
    WHERE TableName = @TableName;
END;
GO