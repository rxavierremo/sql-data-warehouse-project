/*
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the silver layer.
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage:
    - Run these checks after data loading Silver Layer.
===============================================================================
*/

-------------------------------------------------------------------------------
-- Quality checks are divided into each table in the silver layer
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Quality check for: silver.crm_cust_info
-------------------------------------------------------------------------------

-- To check for Nulls or Duplicates in the Primary Key
-- Expected Result: No results

SELECT
  cst_id,
  COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- To check for unwanted spaces
-- Expected Result: No results

SELECT
  cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key); -- Checks whether the trimmed column is equal to the current column data.

-- To check for Data Standardization and Consistency
SELECT DISTINCT
  cst_marital_status
FROM silver.crm_cust_info;

-------------------------------------------------------------------------------
-- Quality check for: silver.crm_prd_info
-------------------------------------------------------------------------------

-- To check for Nulls or Duplicates in the Primary Key
-- Expected Result: No results

SELECT 
  prd_id,
  COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- To chek for unwanted spaces
-- Expected Result: No results

SELECT
  prd_name
FROM silver.crm_prd_info
WHERE prd_nm =! TRIM(prd_nm);

-- To check for nulls or negative values of prd_cost
-- Expected Result: No results

SELECT
  prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- To check for Data Standardization and Consistency

SELECT DISTINCT
  prd_line
FROM silver.crm_prd_info

-- To check for invalid date orders where start date > end date
-- Expected Result: No results

SELECT
  *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-------------------------------------------------------------------------------
-- Quality check for: silver.crm_sales_details
-------------------------------------------------------------------------------

-- To check for invalid dates
-- Expected Results: No invalid dates

SELECT
  NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM silver.crm_sales_details
WHERE sls_due_dt <= 0
  OR LEN(sls_due_dt) != 8
  OR sls_due_dt > 20500101
  OR sls_due_dt < 19000101;

-- To check for invalid order dates where order date > shipping/due date
-- Expected Result: No result

SELECT
  *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
  OR sls_order_dt > sls_due_dt;

-- To check for data consistency where sales = quantity * price
-- Expected Result: No result

SELECT DISTINCT
  sls_sales,
  sls_quantity,
  sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
  OR sls_sales IS NULL
  OR sls_quantity IS NULL
  OR sls_price IS NULL
  OR sls_sales <= 0
  OR sls_quantity <= 0
  OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price DESC;

-------------------------------------------------------------------------------
-- Quality check for: silver.erp_cust_az12
-------------------------------------------------------------------------------

-- To check for out of range dates
-- Expected Result: birthdates between 1924-01-01 and current date

SELECT DISTINCT
  bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
  OR bdate > GETDATE();

-- To check for data standardization and consistency
SELECT DISTINCT
  gen
FROM silver.erp_cust_az12;

-------------------------------------------------------------------------------
-- Quality check for: silver.erp_loc_a101
-------------------------------------------------------------------------------

-- To check for data standardization and consistency

SELECT DISTINCT
  cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

-------------------------------------------------------------------------------
-- Quality check for: silver.erp_px_cat_g1v2
-------------------------------------------------------------------------------

-- To check for unwanted spaces
-- Expected Result: No result

SELECT
  *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
  OR subcat != TRIM(subcat)
  OR maintenance != TRIM(maintenance);

-- To check for data standardization and consistency
SELECT DISTINCT
  maintenance
FROM silver.erp_px_cat_g1v2;









