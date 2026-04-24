CREATE OR ALTER PROCEDURE dbo.usp_Clear_OrderItems_Changes_Stage
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.OrderItems_Changes_Stage;
END;
GO