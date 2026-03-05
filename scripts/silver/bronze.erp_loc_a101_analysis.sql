/*
============================================================
-- Analyze and transform the bronze.erp_loc_a101 table.
============================================================
*/

-------------------------------------------------------------------
-- Entire table for reference
-------------------------------------------------------------------
SELECT
  cid,
  cntry
FROM bronze.erp_loc_a101

-------------------------------------------------------------------
-- Transformation query
-------------------------------------------------------------------
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

-------------------------------------------------------------------
-- Insert into silver table
-------------------------------------------------------------------
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
    


