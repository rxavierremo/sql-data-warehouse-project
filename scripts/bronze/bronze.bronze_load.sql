/*
============================================================
Script Name  : bronze.bronze_load.sql

Description  : Creates a stored procedure named 
               bronze.load_bronze and then
               inserts the data from the CSV file to the 
			   tables.
			   
			   Execution: EXEC bronze.load_bronze
============================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

	SET @batch_start_time = GETDATE();
	PRINT '=================================================';
	PRINT 'Loading Bronze Layer...';
	PRINT '=================================================';

	PRINT '=================================================';
	PRINT 'Loading CRM Tables...';
	PRINT '=================================================';

	-------------------------------------------------------------------------------------------------------------
	--Since I am using a local machine, I will be using Bulk Insert using the path where my datasets reside.

	-- Expected file format:
	-- File type     : CSV
	-- Delimiter     : Comma (,)
	-- Header row    : Yes (skipped via FIRSTROW = 2)
	-------------------------------------------------------------------------------------------------------------
	
	--Truncate tables before using bulk insert. This will avoid duplicating the data.

	SET @start_time = GETDATE(); --Setting start_time variable as GETDATE() in order to get the current date BEFORE inserting the data.
	TRUNCATE TABLE bronze.crm_cust_info
	PRINT '>> Table bronze.crm_cust_info has been truncated successfully.';

	BEGIN TRY
		PRINT '>> Inserting data to bronze.crm_cust_info...';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIELDTERMINATOR = ',',
			FIRSTROW = 2,
			TABLOCK
		);
	END TRY
	BEGIN CATCH
		PRINT '>> Error loading data into bronze.crm_cust_info';
		PRINT ERROR_MESSAGE();
	END CATCH
	SET @end_time = GETDATE() --Setting end_time variable as GETDATE() to get the current date AFTER inserting the data.
	PRINT '>> bronze.crm_cust_info load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

	PRINT '=================================================';
	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.crm_prd_info
	PRINT '>> Table bronze.crm_prd_info has been truncated successfully.'

	BEGIN TRY
		PRINT '>> Inserting data to bronze.crm_prd_info...';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIELDTERMINATOR = ',',
			FIRSTROW = 2,
			TABLOCK
		);
	END TRY
	BEGIN CATCH
		PRINT '>> Error loading data into bronze.crm_prd_info';
		PRINT ERROR_MESSAGE();
	END CATCH
	SET @end_time = GETDATE();
	PRINT '>> bronze.crm_prd_info load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

	PRINT '=================================================';
	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.crm_sales_details
	PRINT '>> Table bronze.crm_sales_details has been truncated successfully.'

	BEGIN TRY
		PRINT '>> Inserting data to bronze.crm_sales_details...';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIELDTERMINATOR = ',',
			FIRSTROW = 2,
			TABLOCK
		);
	END TRY
	BEGIN CATCH
		PRINT '>> Error loading data into bronze.crm_sales_details';
		PRINT ERROR_MESSAGE();
	END CATCH
	SET @end_time = GETDATE();
	PRINT '>> bronze.crm_sales_details load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

	
	--LOAD ERP TABLES

	PRINT '=================================================';
	PRINT 'Loading ERP Tables...';
	PRINT '=================================================';

	PRINT '=================================================';
	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.erp_cust_az12
	PRINT '>> Table bronze.erp_cust_az12 has been truncated successfully.'

	BEGIN TRY
		PRINT '>> Inserting data to bronze.erp_cust_az12...';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIELDTERMINATOR = ',',
			FIRSTROW = 2,
			ROWTERMINATOR = '\n',
			TABLOCK
		);
	END TRY
	BEGIN CATCH
		PRINT '>> Error loading data into bronze.erp_cust_az12';
		PRINT ERROR_MESSAGE();
	END CATCH
	SET @end_time = GETDATE();
	PRINT '>> bronze.erp_cust_az12 load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

	PRINT '=================================================';
	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.erp_loc_a101
	PRINT '>> Table bronze.erp_loca101 has been truncated successfully.'

	BEGIN TRY
		PRINT '>> Inserting data to bronze.erp_loc_a101...';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIELDTERMINATOR = ',',
			FIRSTROW = 2,
			ROWTERMINATOR = '\n',
			TABLOCK
		);
	END TRY
	BEGIN CATCH
		PRINT '>> Error loading data into bronze.erp_loc_a101';
		PRINT ERROR_MESSAGE();
	END CATCH
	SET @end_time = GETDATE();
	PRINT '>> bronze.erp_loc_a101 load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

	PRINT '=================================================';
	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.erp_px_cat_g1v2
	PRINT '>> Table bronze.erp_px_cat_g1v2 has been truncated successfully.'

	BEGIN TRY
		PRINT '>> Inserting data to bronze.erp_px_cat_g1v2...';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIELDTERMINATOR = ',',
			FIRSTROW = 2,
			ROWTERMINATOR = '\r',
			TABLOCK
		);
	END TRY
	BEGIN CATCH
		PRINT '>> Error loading data into bronze.erp_px_cat_g1v2';
		PRINT ERROR_MESSAGE();
	END CATCH
	SET @end_time = GETDATE();
	PRINT '>> bronze.erp_px_cat_g1v2 load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';


	PRINT '=================================================';
	PRINT 'Successfully Loaded Bronze Layer...';
	PRINT '=================================================';
	SET @batch_end_time = GETDATE();
	PRINT '>> Bronze Layer load duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
END
