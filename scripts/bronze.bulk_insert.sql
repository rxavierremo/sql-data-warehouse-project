


--Truncate tables before using bulk insert. This will avoid duplicating the data.
TRUNCATE TABLE bronze.crm_cust_info
PRINT 'Table bronze.crm_cust_info has been truncated successfully.'

-------------------------------------------------------------------------------------------------------------
--Since I am using a local machine, I will be using Bulk Insert using the path where my datasets reside.

-- Expected file format:
-- File type     : CSV
-- Delimiter     : Comma (,)
-- Header row    : Yes (skipped via FIRSTROW = 2)
-------------------------------------------------------------------------------------------------------------

BEGIN TRY
	BULK INSERT bronze.crm_cust_info
	--FROM 'C:\data_warehouse\datasets\test.csv'
	FROM 'C:\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
		FIELDTERMINATOR = ',',
		FIRSTROW = 2,
		TABLOCK
	);
END TRY
BEGIN CATCH
	PRINT 'Error loading data into bronze.crm_cust_info';
	PRINT ERROR_MESSAGE();
END CATCH
GO

TRUNCATE TABLE bronze.crm_prd_info
PRINT 'Table bronze.crm_prd_info has been truncated successfully.'

BEGIN TRY
	BULK INSERT bronze.crm_prd_info
	FROM 'C:\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
		FIELDTERMINATOR = ',',
		FIRSTROW = 2,
		TABLOCK
	);
END TRY
BEGIN CATCH
	PRINT 'Error loading data into bronze.crm_prd_info';
	PRINT ERROR_MESSAGE();
END CATCH
GO

TRUNCATE TABLE bronze.crm_sales_details
PRINT 'Table bronze.crm_sales_details has been truncated successfully.'

BEGIN TRY
	BULK INSERT bronze.crm_sales_details
	FROM 'C:\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH (
		FIELDTERMINATOR = ',',
		FIRSTROW = 2,
		TABLOCK
	);
END TRY
BEGIN CATCH
	PRINT 'Error loading data into bronze.crm_sales_details';
	PRINT ERROR_MESSAGE();
END CATCH
GO

TRUNCATE TABLE bronze.erp_cust_az12
PRINT 'Table bronze.erp_cust_az12 has been truncated successfully.'

BEGIN TRY
	BULK INSERT bronze.erp_cust_az12
	FROM 'C:\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	WITH (
		FIELDTERMINATOR = ',',
		FIRSTROW = 2,
		ROWTERMINATOR = '\r\n',
		TABLOCK
	);
END TRY
BEGIN CATCH
	PRINT 'Error loading data into bronze.erp_cust_az12';
	PRINT ERROR_MESSAGE();
END CATCH
GO

TRUNCATE TABLE bronze.erp_loc_a101
PRINT 'Table bronze.erp_loca101 has been truncated successfully.'

BEGIN TRY
	BULK INSERT bronze.erp_loc_a101
	FROM 'C:\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	WITH (
		FIELDTERMINATOR = ',',
		FIRSTROW = 2,
		ROWTERMINATOR = '\r\n',
		TABLOCK
	);
END TRY
BEGIN CATCH
	PRINT 'Error loading data into bronze.erp_loc_a101';
	PRINT ERROR_MESSAGE();
END CATCH
GO

TRUNCATE TABLE bronze.erp_px_cat_g1v2
PRINT 'Table bronze.erp_px_cat_g1v2 has been truncated successfully.'

BEGIN TRY
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
	PRINT 'Error loading data into bronze.erp_px_cat_g1v2';
	PRINT ERROR_MESSAGE();
END CATCH
GO

