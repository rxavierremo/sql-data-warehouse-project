/*
============================================================
Script Name  : bronze.create_tables.sql

Description  : Create tables named <sourcesystem_name> for 
			         bronze layer after checking if it does not 
			         exist. 
============================================================
*/

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'bronze.crm_cust_info' AND schema_id = SCHEMA_ID('bronze'))
BEGIN
	CREATE TABLE bronze.crm_cust_info (
		cst_id INT,
		cst_key NVARCHAR(50),
		cst_firstname NVARCHAR(50),
		cst_lastname NVARCHAR(50),
		cst_marital_status NVARCHAR(20),
		cst_gndr NVARCHAR(10),
		cst_create_date DATE
	);
	PRINT 'Table bronze.crm_cust_info has been created successfully';
END
ELSE
BEGIN
	PRINT 'Table bronze.crm_cust_info already exists';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'bronze.crm_prd_info' AND schema_id = SCHEMA_ID('bronze'))
BEGIN
	CREATE TABLE bronze.crm_prd_info (
		prd_id INT,
		prd_key NVARCHAR(50),
		prd_nm NVARCHAR(50),
		prd_cost INT,
		prd_line NVARCHAR(50),
		prd_start_dt DATE,
		prd_end_dt DATE
	);
	PRINT 'Table bronze.crm_prd_info has been created successfully';
END
ELSE
BEGIN
	PRINT 'Table bronze.crm_prd_info already exists';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'bronze.crm_sales_details' AND schema_id = SCHEMA_ID('bronze'))
BEGIN
	CREATE TABLE bronze.crm_sales_details (
		sls_ord_num NVARCHAR(50),
		sls_prd_key NVARCHAR(50),
		sls_cust_id INT,
		sls_order_dt INT,
		sls_ship_dt INT,
		sls_due_dt INT,
		sls_sales INT,
		sls_quantity INT,
		sls_price INT
	);
	PRINT 'Table bronze.crm_sales_details has been created successfully';
END
ELSE
BEGIN
	PRINT 'Table bronze.crm_sales_details already exists';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'bronze.erp_cust_az12' AND schema_id = SCHEMA_ID('bronze'))
BEGIN
	CREATE TABLE bronze.erp_cust_az12 (
		cid INT,
		bdate DATE,
		gen NVARCHAR(15),
	);
	PRINT 'Table bronze.erp_cust_az12 has been created successfully';
END
ELSE
BEGIN
	PRINT 'Table bronze.erp_cust_az12 already exists';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'bronze.erp_loca101' AND schema_id = SCHEMA_ID('bronze'))
BEGIN
	CREATE TABLE bronze.erp_loca101 (
		cid INT,
		cntry NVARCHAR(50),
	);
	PRINT 'Table bronze.erp_loca101 has been created successfully';
END
ELSE
BEGIN
	PRINT 'Table bronze.erp_loca101 already exists';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'bronze.erp_px_cat_g1v2' AND schema_id = SCHEMA_ID('bronze'))
BEGIN
	CREATE TABLE bronze.erp_px_cat_g1v2 (
		id NVARCHAR(20),
		cat NVARCHAR(50),
		subcat NVARCHAR(50),
		maintenance NVARCHAR(10),
	);
	PRINT 'Table bronze.erp_px_cat_g1v2 has been created successfully';
END
ELSE
BEGIN
	PRINT 'Table bronze.erp_px_cat_g1v2 already exists';
END
GO

