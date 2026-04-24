CREATE OR ALTER PROCEDURE dbo.usp_Get_Orders_Changes
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LastProcessedVersion BIGINT;

    SELECT @LastProcessedVersion = LastProcessedVersion
    FROM dbo.ETL_Watermark
    WHERE TableName = 'Orders';

    SELECT
        ct.SYS_CHANGE_VERSION,
        ct.SYS_CHANGE_OPERATION,
        ct.OrderID,
        o.CustomerID,
        o.OrderDate,
        o.OrderStatus,
        o.TotalAmount,
        o.LastUpdated
    FROM CHANGETABLE(CHANGES dbo.Orders, @LastProcessedVersion) AS ct
    LEFT JOIN dbo.Orders AS o
        ON o.OrderID = ct.OrderID
    ORDER BY ct.SYS_CHANGE_VERSION, ct.OrderID;
END;
GO