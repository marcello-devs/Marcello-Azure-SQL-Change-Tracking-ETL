INSERT INTO dbo.Products (ProductID, ProductName, Category, UnitPrice, IsActive)
VALUES
(101, 'Wireless Mouse', 'Accessories', 19.99, 1),
(102, 'Mechanical Keyboard', 'Accessories', 79.99, 1),
(103, '27 Inch Monitor', 'Monitors', 189.99, 1);
GO

INSERT INTO dbo.Orders (OrderID, CustomerID, OrderDate, OrderStatus, TotalAmount)
VALUES
(1001, 2, GETDATE(), 'Completed', 99.98),
(1002, 4, GETDATE(), 'Pending', 189.99);
GO

INSERT INTO dbo.OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice, LineAmount)
VALUES
(1, 1001, 101, 1, 19.99, 19.99),
(2, 1001, 102, 1, 79.99, 79.99),
(3, 1002, 103, 1, 189.99, 189.99);
GO

SELECT * FROM dbo.Products ORDER BY ProductID;
SELECT * FROM dbo.Orders ORDER BY OrderID;
SELECT * FROM dbo.OrderItems ORDER BY OrderItemID;
GO