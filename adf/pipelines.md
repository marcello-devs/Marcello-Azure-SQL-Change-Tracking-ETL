# Pipelines

## PL_Copy_Customers
Initial full load pipeline from dbo.Customers to dbo.Customers_ETL.

## PL_Load_Customer_Changes
Incremental pipeline flow:
1. Copy changed rows into dbo.Customers_Changes_Stage
2. Execute dbo.usp_Merge_Customers_Changes
3. Execute dbo.usp_Update_ETL_Watermark