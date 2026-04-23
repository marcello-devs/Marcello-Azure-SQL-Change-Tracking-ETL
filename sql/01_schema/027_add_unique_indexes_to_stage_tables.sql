CREATE UNIQUE INDEX UX_Customers_Changes_Stage
ON dbo.Customers_Changes_Stage (SYS_CHANGE_VERSION, CustomerID);
GO

CREATE UNIQUE INDEX UX_Products_Changes_Stage
ON dbo.Products_Changes_Stage (SYS_CHANGE_VERSION, ProductID);
GO

CREATE UNIQUE INDEX UX_Orders_Changes_Stage
ON dbo.Orders_Changes_Stage (SYS_CHANGE_VERSION, OrderID);
GO

CREATE UNIQUE INDEX UX_OrderItems_Changes_Stage
ON dbo.OrderItems_Changes_Stage (SYS_CHANGE_VERSION, OrderItemID);
GO