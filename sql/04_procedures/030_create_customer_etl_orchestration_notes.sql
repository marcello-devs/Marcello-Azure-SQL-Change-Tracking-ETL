/*
Customer ETL orchestration order

1. EXEC dbo.usp_Log_ETL_Run_Start
       @PipelineName = 'PL_Load_Customer_Changes',
       @TableName = 'Customers'

2. EXEC dbo.usp_Clear_Customers_Changes_Stage

3. Copy source changes into dbo.Customers_Changes_Stage
   using dbo.usp_Get_Customer_Changes

4. EXEC dbo.usp_Merge_Customers_Changes

5. EXEC dbo.usp_Update_ETL_Watermark

6. EXEC dbo.usp_Log_ETL_Run_Success
       @PipelineName = 'PL_Load_Customer_Changes',
       @TableName = 'Customers',
       @RowsCopied = <ADF output later>,
       @RowsMerged = NULL

Failure path:
EXEC dbo.usp_Log_ETL_Run_Failure
    @PipelineName = 'PL_Load_Customer_Changes',
    @TableName = 'Customers',
    @ErrorMessage = <ADF dynamic error text later>
*/