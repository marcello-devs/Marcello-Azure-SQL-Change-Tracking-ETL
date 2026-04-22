CREATE OR ALTER PROCEDURE dbo.usp_Clear_Customers_Changes_Stage
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.Customers_Changes_Stage;
END;
GO