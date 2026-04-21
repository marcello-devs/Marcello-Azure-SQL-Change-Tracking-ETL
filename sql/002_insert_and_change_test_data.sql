INSERT INTO dbo.Customers (CustomerID, FullName, City)
VALUES
(1, 'Marcello DaSilva', 'London'),
(2, 'Anna Costa', 'Manchester'),
(3, 'David Brown', 'Leeds');
GO

UPDATE dbo.Customers
SET City = 'Birmingham',
    LastUpdated = GETDATE()
WHERE CustomerID = 2;
GO

DELETE FROM dbo.Customers
WHERE CustomerID = 3;
GO

SELECT * FROM dbo.Customers;
GO