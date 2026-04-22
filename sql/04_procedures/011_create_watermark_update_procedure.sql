CREATE OR ALTER PROCEDURE dbo.usp_Update_ETL_Watermark
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.ETL_Watermark
    SET LastProcessedVersion = CHANGE_TRACKING_CURRENT_VERSION()
    WHERE TableName = 'Customers';
END;
GO

SELECT * FROM dbo.ETL_Watermark;
GO