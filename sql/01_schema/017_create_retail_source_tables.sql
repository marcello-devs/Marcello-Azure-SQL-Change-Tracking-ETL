CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    LastUpdated DATETIME2 NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME2 NOT NULL,
    OrderStatus NVARCHAR(30) NOT NULL,
    TotalAmount DECIMAL(12,2) NOT NULL,
    LastUpdated DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID)
);
GO

CREATE TABLE dbo.OrderItems (
    OrderItemID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    LineAmount DECIMAL(12,2) NOT NULL,
    LastUpdated DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID),
    CONSTRAINT FK_OrderItems_Products
        FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID)
);
GO