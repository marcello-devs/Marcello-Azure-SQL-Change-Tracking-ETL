SELECT 
    'Products' AS TableName,
    ct.SYS_CHANGE_VERSION,
    ct.SYS_CHANGE_OPERATION,
    ct.ProductID AS BusinessKey
FROM CHANGETABLE(CHANGES dbo.Products, 0) AS ct

UNION ALL

SELECT 
    'Orders' AS TableName,
    ct.SYS_CHANGE_VERSION,
    ct.SYS_CHANGE_OPERATION,
    ct.OrderID AS BusinessKey
FROM CHANGETABLE(CHANGES dbo.Orders, 0) AS ct

UNION ALL

SELECT 
    'OrderItems' AS TableName,
    ct.SYS_CHANGE_VERSION,
    ct.SYS_CHANGE_OPERATION,
    ct.OrderItemID AS BusinessKey
FROM CHANGETABLE(CHANGES dbo.OrderItems, 0) AS ct

ORDER BY TableName, SYS_CHANGE_VERSION, BusinessKey;
GO