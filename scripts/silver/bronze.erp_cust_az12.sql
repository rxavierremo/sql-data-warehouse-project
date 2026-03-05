/*
============================================================
-- Analyze and transform the bronze.erp_cust_az12 table.
============================================================
*/
--------------------------------------------------------------------------------
-- Entire table for reference
--------------------------------------------------------------------------------
SELECT 
  cid,
  bdate,
  gen
FROM bronze.erp_cust_az12
--------------------------------------------------------------------------------
-- Transformation query
--------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------
-- Insert into silver.erp_cust_az12
--------------------------------------------------------------------------------
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
