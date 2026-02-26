SELECT TOP 1000 *
FROM bronze.<table_name> -- Replace table_name with other tables to check overall data quality

--------------------------------------------------------------------------------------------------------------------------
-- Check for NULLS or Duplicates in Primary Key
-- Expected Result: None
--------------------------------------------------------------------------------------------------------------------------
  
-- This query will check whether the primary key (cst_id) has any duplicates. If it does, it will return the result.
SELECT
  cst_id,
  COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

--------------------------------------------------------------------------------------------------------------------------
-- This query is the transformed query of bronze.crm_cust_info where we use a Window Function ROW_NUMBER() that 
-- assigns a row number for each record of the table. PARTITION BY <column_name> divides the data based on the column name
-- and restarts into a count of 1 for every unique record. It is then ordered by cst_create_date that is descending,
-- this will pull data as the most recent create date per customer record.
--------------------------------------------------------------------------------------------------------------------------
SELECT 
  *
FROM (
SELECT
  *,
  ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS is_latest
FROM bronze.crm_cust_info
WHERE cst_id IS NOT NULL
)t WHERE is_latest = 1

--------------------------------------------------------------------------------------------------------------------------
-- This query will check if there are any unwanted spaces for NVARCHAR columns.
-- Expected Result: None
--------------------------------------------------------------------------------------------------------------------------
SELECT
  cst_firstname,
  cst_lastname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname) AND cst_lastname != TRIM(cst_lastname)

--------------------------------------------------------------------------------------------------------------------------
-- This query transforms cst_firstname and cst_lastname to remove any leading and trailing spaces in the string.
--------------------------------------------------------------------------------------------------------------------------
SELECT
  TRIM(cst_firstname) AS cst_firstname,
  TRIM(cst_lastname) AS cst_lastname
FROM bronze.crm_cust_info

--------------------------------------------------------------------------------------------------------------------------
-- Data standardization and consistency
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
-- To check whether column has other distinct values than S and M (Single and Married)
--------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT
  cst_marital_status
FROM bronze.crm_cust_info
--------------------------------------------------------------------------------------------------------------------------
-- This query transforms cst_marital_status to a standard and consistent record containing meaningful information.
--------------------------------------------------------------------------------------------------------------------------
SELECT 
  CASE
  WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
  WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
  ELSE 'n/a'
  END AS cst_marital_status
FROM bronze.crm_cust_info

--------------------------------------------------------------------------------------------------------------------------
-- To check whether cst_gndr has other values than M and F
--------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT
  cst_gndr
FROM bronze.crm_cust_info

--------------------------------------------------------------------------------------------------------------------------
-- This query transforms cst_gndr to a standard and consistent record containing meaningful information.
--------------------------------------------------------------------------------------------------------------------------
SELECT 
  CASE 
  WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female' -- UPPER is used in case there are cases when the column contains lowercase records
  WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
  ELSE 'N/A'
  END AS cst_gndr
FROM bronze.crm_cust_info

--------------------------------------------------------------------------------------------------------------------------
-- Insert table into silver.crm_cust_info
-- This query will run all necessary transformation and insert the data into the new table silver.crm_cust_info
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO silver.crm_cust_info (
  cst_id,
  cst_key,
  cst_firstname,
  cst_lastname,
  cst_marital_status,
  cst_gndr,
  cst_create_date)
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

--------------------------------------------------------------------------------------------------------------------------
-- To check data quality, rerun above quality check codes and replace 'bronze' schema with 'silver'
--------------------------------------------------------------------------------------------------------------------------
  

  
