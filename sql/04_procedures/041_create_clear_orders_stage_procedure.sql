CREATE OR ALTER PROCEDURE dbo.usp_Clear_Orders_Changes_Stage
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.Orders_Changes_Stage;
END;
GO