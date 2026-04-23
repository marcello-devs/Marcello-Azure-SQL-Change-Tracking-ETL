CREATE OR ALTER PROCEDURE dbo.usp_Clear_Products_Changes_Stage
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.Products_Changes_Stage;
END;
GO