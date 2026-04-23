CREATE OR ALTER PROCEDURE dbo.usp_Get_Products_Changes
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LastProcessedVersion BIGINT;

    SELECT @LastProcessedVersion = LastProcessedVersion
    FROM dbo.ETL_Watermark
    WHERE TableName = 'Products';

    SELECT
        ct.SYS_CHANGE_VERSION,
        ct.SYS_CHANGE_OPERATION,
        ct.ProductID,
        p.ProductName,
        p.Category,
        p.UnitPrice,
        p.IsActive,
        p.LastUpdated
    FROM CHANGETABLE(CHANGES dbo.Products, @LastProcessedVersion) AS ct
    LEFT JOIN dbo.Products AS p
        ON p.ProductID = ct.ProductID
    ORDER BY ct.SYS_CHANGE_VERSION, ct.ProductID;
END;
GO