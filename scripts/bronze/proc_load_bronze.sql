/*
=============================================================================
Stored Procedure: load bronze layer (Source -> Bronze)
=============================================================================

This project was developed and executed in a local SQL Server environment. The 
BULK INSERT statements in scripts/bronze/proc_load_bronze.sql use absolute file 
paths that point to the local datasets directory.

Before running the Bronze loading procedure, update each file path so that it 
matches the location of the project on your computer. The SQL Server service 
account must also have permission to read the selected directory.

Script Prupose:
  This stored procedure loads data into the 'bronze' schema external CSV files
  It performs the following actions:
  - It performs the following action.
  - Uses the 'BULK INSERT' command to load data from csv Files to bronze tables.

Parameters:
  None.
This stored procedure does not accept any parameters or return any values.

Usage Example;
  EXEC bronze.load_bronze
*/


CREATE OR ALTER PROCEDURE bronze. load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_time_start DATETIME, @batch_time_end DATETIME;  /* Those variables are to calculate the time that every table needs to be inserted */
	BEGIN TRY
		SET @batch_time_start = GETDATE();
		PRINT '===============================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '===============================================================';

		PRINT 'Loading CRM Tables...';

		SET @start_time = GETDATE();
		PRINT '>> Truncating table: crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info

		PRINT '>> Inserting data into: crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Berna\Documents\SQL DataWarehouse\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',  
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading time: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------------------------------------------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating table: crm_sls_info';
		TRUNCATE TABLE bronze.crm_sls_info
		PRINT '>> Inserting data into: crm_sls_info';
		BULK INSERT bronze.crm_sls_info
		FROM 'C:\Users\Berna\Documents\SQL DataWarehouse\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',  
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading time: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating table: crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info
		PRINT '>> Inserting data into: crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Berna\Documents\SQL DataWarehouse\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',  
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading time: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------------------------------------------';


		PRINT 'Loading ERP Tables...';


		SET @start_time = GETDATE();
		PRINT '>> Truncating table: erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12
		PRINT '>> Inserting data into: erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Berna\Documents\SQL DataWarehouse\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',  
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading time: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating table: erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101
		PRINT '>> Inserting data into: erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Berna\Documents\SQL DataWarehouse\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',  
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading time: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating table: erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2
		PRINT '>> Inserting data into: erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Berna\Documents\SQL DataWarehouse\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',  
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading time: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------------------------------------------';

		SET @batch_time_end = GETDATE();
		PRINT '----------------------------------------------------------------';
		PRINT 'Loading Bronze Layer is Completed'
		PRINT '		-	Total Load Duration: ' + CAST(DATEDIFF (second, @batch_time_start, @batch_time_end) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------------------------------------------';
		
		
	END TRY
	BEGIN CATCH /* If TRY block, and it fails, it runs the CATCH block to handle the error */
		PRINT '================================================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '================================================================================';

	END CATCH
END
