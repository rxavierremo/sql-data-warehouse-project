/*
============================================================
Script Name  : silver.silver_load.sql

Description  : Create tables for silver layer after checking
               if it does not exist. 
============================================================
*/

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'silver.crm_cust_info' AND schema_id = SCHEMA_ID('silver'))
BEGIN
	CREATE TABLE silver.crm_cust_info (
		cst_id INT,
		cst_key NVARCHAR(50),
		cst_firstname NVARCHAR(50),
		cst_lastname NVARCHAR(50),
		cst_marital_status NVARCHAR(20),
		cst_gndr NVARCHAR(10),
		cst_create_date DATE,
		dwh_create_date DATETIME2 DEFAULT GETDATE() -- Metadata column that records the current date when this script is executed
	);
	PRINT 'Table silver.crm_cust_info has been created successfully';
END
ELSE
BEGIN
	PRINT 'Table silver.crm_cust_info already exists';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'silver.crm_prd_info' AND schema_id = SCHEMA_ID('silver'))
BEGIN
	CREATE TABLE silver.crm_prd_info (
		prd_id INT,
		prd_key NVARCHAR(50),
		prd_nm NVARCHAR(50),
		prd_cost INT,
		prd_line NVARCHAR(50),
		prd_start_dt DATE,
		prd_end_dt DATE,
		dwh_create_date DATETIME2 DEFAULT GETDATE()
	);
	PRINT 'Table silver.crm_prd_info has been created successfully';
END
ELSE
BEGIN
	PRINT 'Table silver.crm_prd_info already exists';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'silver.crm_sales_details' AND schema_id = SCHEMA_ID('silver'))
BEGIN
	CREATE TABLE silver.crm_sales_details (
		sls_ord_num NVARCHAR(50),
		sls_prd_key NVARCHAR(50),
		sls_cust_id INT,
		sls_order_dt INT,
		sls_ship_dt INT,
		sls_due_dt INT,
		sls_sales INT,
		sls_quantity INT,
		sls_price INT,
		dwh_create_date DATETIME2 DEFAULT GETDATE()
	);
	PRINT 'Table silver.crm_sales_details has been created successfully';
END
ELSE
BEGIN
	PRINT 'Table silver.crm_sales_details already exists';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'silver.erp_cust_az12' AND schema_id = SCHEMA_ID('silver'))
BEGIN
	CREATE TABLE silver.erp_cust_az12 (
		cid NVARCHAR,
		bdate DATE,
		gen NVARCHAR(15),
		dwh_create_date DATETIME2 DEFAULT GETDATE()
	);
	PRINT 'Table silver.erp_cust_az12 has been created successfully';
END
ELSE
BEGIN
	PRINT 'Table silver.erp_cust_az12 already exists';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'silver.erp_loc_a101' AND schema_id = SCHEMA_ID('silver'))
BEGIN
	CREATE TABLE silver.erp_loc_a101 (
		cid NVARCHAR(50),
		cntry NVARCHAR(50),
		dwh_create_date DATETIME2 DEFAULT GETDATE()
	);
	PRINT 'Table silver.erp_loc_a101 has been created successfully';
END
ELSE
BEGIN
	PRINT 'Table silver.erp_loc_a101 already exists';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'silver.erp_px_cat_g1v2' AND schema_id = SCHEMA_ID('silver'))
BEGIN
	CREATE TABLE silver.erp_px_cat_g1v2 (
		id NVARCHAR(20),
		cat NVARCHAR(50),
		subcat NVARCHAR(50),
		maintenance NVARCHAR(10),
		dwh_create_date DATETIME2 DEFAULT GETDATE()
	);
	PRINT 'Table silver.erp_px_cat_g1v2 has been created successfully';
END
ELSE
BEGIN
	PRINT 'Table silver.erp_px_cat_g1v2 already exists';
END
GO
