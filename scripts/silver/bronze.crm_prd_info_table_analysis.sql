--------------------------------------------------------------------------------------------------------------------------
-- Check for NULLS or Duplicates in the Primary Key
-- Expectation: No result
--------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT
  prd_id,
  COUNT(*)
FROM bronze.crm_prd_info
HAVING COUNT(*) > 1 OR prd_id IS NULL

SELECT
  prd_id,
  prd_key,
  prd_nm,
  prd_cost,
  prd_line,
  prd_start_dt,
  prd_end_dt
FROM bronze.crm_prd_info




