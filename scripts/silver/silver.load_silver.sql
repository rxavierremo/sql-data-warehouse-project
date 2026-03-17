/*
============================================================
Script Name  : silver.load_silver.sql

Description  : Creates a stored procedure named 
               silver.load_silver and then
               inserts the transformed data to the silver
               table.
			   
			   Execution: EXEC silver.load_silver
============================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

	SET @batch_start_time = GETDATE();
	PRINT '=================================================';
	PRINT 'Loading Silver Layer...';
	PRINT '=================================================';

	PRINT '=================================================';
	PRINT 'Loading CRM Tables...';
	PRINT '=================================================';
	
	--Truncate tables before using insert. This will avoid duplicating the data.

	SET @start_time = GETDATE(); --Setting start_time variable as GETDATE() in order to get the current date BEFORE inserting the data.
	TRUNCATE TABLE silver.crm_cust_info
	PRINT '>> Table silver.crm_cust_info has been truncated successfully.';

	BEGIN TRY
		PRINT '>> Inserting data to silver.crm_cust_info...';
		INSERT INTO silver.crm_cust_info (
          cst_id,
          cst_key,
          cst_firstname,
          cst_lastname,
          cst_marital_status,
          cst_gndr,
          cst_create_date
        )
        SELECT
          cst_id,
          cst_key,
          TRIM(cst_firstname) AS cst_firstname,
          TRIM(cst_lastname) AS cst_lastname,
          CASE
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
            ELSE 'n/a'
          END AS cst_marital_status,
          CASE 
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            ELSE 'N/A'
          END AS cst_gndr,
          cst_create_date
        FROM (
        SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS is_latest
        FROM bronze.crm_cust_info
        WHERE cst_id IS NOT NULL
        )t WHERE is_latest = 1    
	END TRY
	BEGIN CATCH
		PRINT '>> Error loading data into silver.crm_cust_info';
		PRINT ERROR_MESSAGE();
	END CATCH
	SET @end_time = GETDATE() --Setting end_time variable as GETDATE() to get the current date AFTER inserting the data.
	PRINT '>> silver.crm_cust_info load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

	PRINT '=================================================';
	SET @start_time = GETDATE();
	TRUNCATE TABLE silver.crm_prd_info
	PRINT '>> Table silver.crm_prd_info has been truncated successfully.'

	BEGIN TRY
		PRINT '>> Inserting data to silver.crm_prd_info...';
		INSERT INTO silver.crm_prd_info (
          prd_id,
          cat_id,
          prd_key,
          prd_nm,
          prd_cost,
          prd_line,
          prd_start_dt,
          prd_end_dt
        )
        SELECT
          prd_id,
          REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') AS cat_id,
          SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
          prd_nm,
          ISNULL(prd_cost, 0) AS prd_cost,
          CASE 
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Others'
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            ELSE 'n/a'
          END AS prd_line,
          CAST(prd_start_dt AS DATE) AS prd_start_dt,
          CAST(DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt))AS DATE) AS prd_end_dt
        FROM bronze.crm_prd_info
	END TRY
	BEGIN CATCH
		PRINT '>> Error loading data into silver.crm_prd_info';
		PRINT ERROR_MESSAGE();
	END CATCH
	SET @end_time = GETDATE();
	PRINT '>> silver.crm_prd_info load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

	PRINT '=================================================';
	SET @start_time = GETDATE();
	TRUNCATE TABLE silver.crm_sales_details
	PRINT '>> Table silver.crm_sales_details has been truncated successfully.'

	BEGIN TRY
		PRINT '>> Inserting data to silver.crm_sales_details...';
		INSERT INTO silver.crm_sales_details (
          sls_ord_num,
          sls_prd_key,
          sls_cust_id,
          sls_order_dt,
          sls_ship_dt,
          sls_due_dt,
          sls_sales,
          sls_quantity,
          sls_price
        )
        SELECT
          sls_ord_num,
          sls_prd_key,
          sls_cust_id,
          CASE
            WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
            ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) -- In SQL Server, Integers cannot be directly casted as a DATE so we have to cast it into a VARCHAR first then convert to DATE.
          END AS sls_order_dt,
          CASE
            WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
            ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) 
          END AS sls_ship_dt,
          CASE
            WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
            ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) 
          END AS sls_due_dt,
          CASE
            WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price) --Absolute value 
            ELSE sls_sales
          END AS sls_sales,
          sls_quantity,
          CASE
            WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0) 
          END AS sls_price
        FROM bronze.crm_sales_details
	END TRY
	BEGIN CATCH
		PRINT '>> Error loading data into silver.crm_sales_details';
		PRINT ERROR_MESSAGE();
	END CATCH
	SET @end_time = GETDATE();
	PRINT '>> silver.crm_sales_details load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

	
	--LOAD ERP TABLES

	PRINT '=================================================';
	PRINT 'Loading ERP Tables...';
	PRINT '=================================================';

	PRINT '=================================================';
	SET @start_time = GETDATE();
	TRUNCATE TABLE silver.erp_cust_az12
	PRINT '>> Table silver.erp_cust_az12 has been truncated successfully.'

	BEGIN TRY
		PRINT '>> Inserting data to silver.erp_cust_az12...';
		INSERT INTO silver.erp_cust_az12 (
          cid,
          bdate,
          gen
        )
        SELECT
          CASE
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) -- As cid can be joined with crm_cust_info table, we will be getting the substring where it matches the other table.
            ELSE cid
          END AS cid,
          CASE
            WHEN bdate > GETDATE() THEN NULL -- If bdate is greater than current date, return NULL.
            ELSE bdate
          END AS bdate,
          CASE
            WHEN UPPER(TRIM(gen)) = 'M' THEN 'Male'
            WHEN UPPER(TRIM(gen)) = 'F' THEN 'Female'
            ELSE 'n/a'
          END AS gen
        FROM bronze.erp_cust_az12
	END TRY
	BEGIN CATCH
		PRINT '>> Error loading data into silver.erp_cust_az12';
		PRINT ERROR_MESSAGE();
	END CATCH
	SET @end_time = GETDATE();
	PRINT '>> silver.erp_cust_az12 load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

	PRINT '=================================================';
	SET @start_time = GETDATE();
	TRUNCATE TABLE silver.erp_loc_a101
	PRINT '>> Table silver.erp_loca101 has been truncated successfully.'

	BEGIN TRY
		PRINT '>> Inserting data to silver.erp_loc_a101...';
		INSERT INTO silver.erp_loc_a101 (
          cid,
          cntry
        )
        SELECT
          REPLACE(cid, '-', '') AS cid,
          CASE
            WHEN cntry IS NULL THEN 'n/a'
            WHEN cntry = '' THEN 'n/a'
            WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) = 'US' OR cntry = 'USA' THEN 'United States'
            ELSE cntry
          END AS cntry
        FROM bronze.erp_loc_a101
	    END TRY
	    BEGIN CATCH
		    PRINT '>> Error loading data into silver.erp_loc_a101';
		    PRINT ERROR_MESSAGE();
	END CATCH
	SET @end_time = GETDATE();
	PRINT '>> silver.erp_loc_a101 load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

	PRINT '=================================================';
	SET @start_time = GETDATE();
	TRUNCATE TABLE silver.erp_px_cat_g1v2
	PRINT '>> Table silver.erp_px_cat_g1v2 has been truncated successfully.'

	BEGIN TRY
		PRINT '>> Inserting data to silver.erp_px_cat_g1v2...';
		INSERT INTO silver.erp_px_cat_g1v2 (
          id,
          cat,
          subcat,
          maintenance
        )
        SELECT 
          id,
          cat,
          subcat,
          maintenance
        FROM bronze.erp_px_cat_g1v2
	END TRY
	BEGIN CATCH
		PRINT '>> Error loading data into silver.erp_px_cat_g1v2';
		PRINT ERROR_MESSAGE();
	END CATCH
	SET @end_time = GETDATE();
	PRINT '>> silver.erp_px_cat_g1v2 load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

	PRINT '=================================================';
	PRINT 'Successfully Loaded Silver Layer...';
	PRINT '=================================================';
	SET @batch_end_time = GETDATE();
	PRINT '>> Silver Layer load duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
END
