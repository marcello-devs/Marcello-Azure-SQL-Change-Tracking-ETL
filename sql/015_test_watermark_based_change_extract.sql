UPDATE dbo.Customers
SET City = 'Cambridge',
    LastUpdated = GETDATE()
WHERE CustomerID = 2;
GO

EXEC dbo.usp_Get_Customer_Changes;
GO