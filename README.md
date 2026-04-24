# Marcello Azure SQL Change Tracking ETL

![Azure](https://img.shields.io/badge/Azure-Cloud-blue)
![SQL](https://img.shields.io/badge/SQL-ChangeTracking-red)
![ADF](https://img.shields.io/badge/Azure-DataFactory-purple)
![ETL](https://img.shields.io/badge/ETL-Incremental-success)
![GitHub](https://img.shields.io/badge/GitHub-Portfolio-black)

---

## Overview

Designed and built a production-style cloud ETL solution in Microsoft Azure using Azure SQL Database, SQL Change Tracking, and Azure Data Factory.

The solution processes incremental changes across multiple business entities (Customers, Products, Orders, OrderItems) using watermark-driven pipelines, staging tables, stored procedures, orchestration pipelines, audit logging, failure handling, and transaction-safe MERGE logic.

This project demonstrates a cloud-based incremental ETL solution using Azure SQL Database, SQL Change Tracking, and Azure Data Factory.

## Architecture

Source Tables -> Change Tracking -> Stored Procedures -> Stage Tables -> MERGE -> Target Tables -> Watermarks -> Audit Logs -> Master Pipeline

![Architecture](images/architecture-diagram.png)

## Business Entities

- Customers
- Products
- Orders
- OrderItems

## Technologies Used

- Azure SQL Database
- Azure Data Factory
- T-SQL
- SQL Change Tracking
- Git / GitHub

## Database Objects

### Source Tables
- dbo.Customers
- dbo.Products
- dbo.Orders
- dbo.OrderItems

### Target Tables
- dbo.Customers_ETL
- dbo.Products_ETL
- dbo.Orders_ETL
- dbo.OrderItems_ETL

### Control Tables
- dbo.ETL_Watermark
- dbo.ETL_Run_Log

## Pipelines

- PL_Load_Customer_Changes
- PL_Load_Product_Changes
- PL_Load_Order_Changes
- PL_Load_OrderItem_Changes
- PL_Master_Retail_ETL

## Production-Style Enhancements

- Incremental watermark loads
- Logging and audit tables
- Failure handling
- Transaction-safe MERGE
- Multi-table orchestration
- Duplicate protection

## Example Incremental Scenarios

- New customer added
- Product price updated
- Order status changed
- New order item inserted

## Repository Structure

/adf
/docs
/images
/sql
README.md

## How to Run

1. Deploy Azure SQL Database and Azure Data Factory
2. Execute SQL scripts in folder order
3. Configure ADF linked services, datasets, and pipelines
4. Run PL_Master_Retail_ETL
5. Validate ETL tables, watermarks, and logs

## Future Improvements

- CI/CD
- Scheduling
- Alerts
- Security
- Data quality checks

## Author

Marcello Da Silva Lopes
