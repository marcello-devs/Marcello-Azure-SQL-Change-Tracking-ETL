UPDATE dbo.Products
SET UnitPrice = 24.99,
    LastUpdated = GETDATE()
WHERE ProductID = 101;
GO

UPDATE dbo.Products
SET IsActive = 0,
    LastUpdated = GETDATE()
WHERE ProductID = 103;
GO

INSERT INTO dbo.Products (ProductID, ProductName, Category, UnitPrice, IsActive)
VALUES (104, 'USB-C Dock', 'Accessories', 59.99, 1);
GO

SELECT * 
FROM dbo.Products
ORDER BY ProductID;
GO