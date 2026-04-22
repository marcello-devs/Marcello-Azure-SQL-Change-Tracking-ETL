CREATE OR ALTER PROCEDURE dbo.usp_Get_Customer_Changes
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LastProcessedVersion BIGINT;

    SELECT @LastProcessedVersion = LastProcessedVersion
    FROM dbo.ETL_Watermark
    WHERE TableName = 'Customers';

    SELECT
        ct.SYS_CHANGE_VERSION,
        ct.SYS_CHANGE_OPERATION,
        ct.CustomerID,
        c.FullName,
        c.City,
        c.LastUpdated
    FROM CHANGETABLE(CHANGES dbo.Customers, @LastProcessedVersion) AS ct
    LEFT JOIN dbo.Customers AS c
        ON c.CustomerID = ct.CustomerID
    ORDER BY ct.SYS_CHANGE_VERSION, ct.CustomerID;
END;
GO

EXEC dbo.usp_Get_Customer_Changes;
GO