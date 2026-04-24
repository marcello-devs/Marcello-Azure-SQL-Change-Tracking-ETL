UPDATE dbo.Products
SET IsActive = 0,
    LastUpdated = GETDATE()
WHERE ProductID = 102;
GO

SELECT *
FROM dbo.Products
ORDER BY ProductID;
GO