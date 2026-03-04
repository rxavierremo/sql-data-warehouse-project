--------------------------------------------------------------------------------------------------------------------------
-- Check for NULLS or Duplicates in the Primary Key
-- Expectation: No result
--------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT
  prd_id,
  COUNT(*)
FROM bronze.crm_prd_info
HAVING COUNT(*) > 1 OR prd_id IS NULL


--------------------------------------------------------------------------------------------------------------------------
-- Whole table of bronze.crm_prd_info for reference only
--------------------------------------------------------------------------------------------------------------------------
SELECT
  prd_id,
  prd_key,
  prd_nm,
  prd_cost,
  prd_line,
  prd_start_dt,
  prd_end_dt
FROM bronze.crm_prd_info

--------------------------------------------------------------------------------------------------------------------------
-- Transformation query
--------------------------------------------------------------------------------------------------------------------------
SELECT
  prd_id,
  prd_key, -- Based on the data exploration, the first five characters in the prd_key column is the cat_id of bronze.erp_px_cat_g1v2 and the 7th until the last characters is the prd_key in the bronze.crm_sales_details table.
  REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') AS cat_id -- Since bronze.erp_px_cat_g1v2 contains cat_id that matches in the table bronze.crm_prd_info, I will extract the 
  -- First to Fifth string in prd_key in order to join the tables in the gold layer.
  SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key
  prd_nm,
  ISNULL(prd_cost, 0), AS prd_cost -- Replaces the value of prd_cost if the value is NULL.
  CASE 
    WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain' -- Since these values are cryptic, it is always better to ask the source that generated the data what these particular column abbreviations mean.
    WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Others'
    WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
    WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
    ELSE 'n/a'
  END AS prd_line,
  CAST (prd_start_dt AS DATE) AS prd_start_dt,
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  -- Since the initial data where prd_end_dt is less than prd_start_dt, does not make sense, we can take a sample row using query below.
  -- SELECT *
  -- FROM bronze.crm_prd_info
  -- WHERE prd_end_dt < prd_start_dt
  -- We can take some of the rows by using the results from above query, and think of a solution on how to resolve the date issue.
  -------------------
  -- Solution 1: We can switch the end date and the start date. But the problem with this approach is that the dates will overlap and will still not 
  -- make any sense. 
  -------------------
  -- Solution 2: 
  -- We will be getting the end date from the start date of the next record and we will be subtracting it by 1 so it does not overlap.
  -- End date can be null since it indicates that it the latest prd_cost of the table.
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt DESC)-1 AS DATE) AS prd_end_dt
  -- Since the column contains time in seconds and we do not need it, we have casted the prd_start_dt and prd_end_dt as DATE instead of DATETIME datatype.
FROM bronze.crm_prd_info

--------------------------------------------------------------------------------------------------------------------------
-- Insert the transformed query into the silver.crm_prd_info table
-- Before running this query, ensure that the DDL script for the table is fixed as we have added new columns and changed the data type of some columns.
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO silver.crm_prd_info(
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
  CAST (prd_start_dt AS DATE) AS prd_start_dt,
  CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt DESC)-1 AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info

