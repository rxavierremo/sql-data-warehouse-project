SELECT TOP 1000 *
FROM bronze.<table_name> -- Replace table_name with other tables to check overall data quality

-- Check for NULLS or Duplicates in Primary Key
-- Expected Result: None

SELECT DISTINCT *
FROM bronze.crm_cust_info

