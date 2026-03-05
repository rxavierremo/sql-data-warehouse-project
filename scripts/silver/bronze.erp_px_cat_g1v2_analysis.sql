/*
============================================================
-- Analyze and transform the bronze.erp_px_cat_g1v2 table.
============================================================
*/

-------------------------------------------------------------------
-- Entire table for reference
-------------------------------------------------------------------
SELECT 
  id,
  cat,
  subcat,
  maintenance
FROM bronze.erp_px_cat_g1v2
-------------------------------------------------------------------
-- Since data from this table does not need any transformation,
-- we will proceed directly with loading it into the silver
-- table.
-------------------------------------------------------------------
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

