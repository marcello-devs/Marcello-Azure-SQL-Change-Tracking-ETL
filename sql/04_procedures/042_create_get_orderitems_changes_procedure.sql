CREATE OR ALTER PROCEDURE dbo.usp_Get_OrderItems_Changes
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LastProcessedVersion BIGINT;

    SELECT @LastProcessedVersion = LastProcessedVersion
    FROM dbo.ETL_Watermark
    WHERE TableName = 'OrderItems';

    SELECT
        ct.SYS_CHANGE_VERSION,
        ct.SYS_CHANGE_OPERATION,
        ct.OrderItemID,
        oi.OrderID,
        oi.ProductID,
        oi.Quantity,
        oi.UnitPrice,
        oi.LineAmount,
        oi.LastUpdated
    FROM CHANGETABLE(CHANGES dbo.OrderItems, @LastProcessedVersion) AS ct
    LEFT JOIN dbo.OrderItems AS oi
        ON oi.OrderItemID = ct.OrderItemID
    ORDER BY ct.SYS_CHANGE_VERSION, ct.OrderItemID;
END;
GO