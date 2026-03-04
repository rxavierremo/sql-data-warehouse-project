/*
*/
---------------------------------------------------------------------------------------------------------------------------
-- Entire table for reference
---------------------------------------------------------------------------------------------------------------------------
SELECT
  sls_ord_num,
  sls_prd_key,
  sls_cust_id,
  sls_order_dt,
  sls_ship_dt,
  sls_due_dt,
  sls_sales,
  sls_quantity,
  sls_price
FROM bronze.crm_sales_details

---------------------------------------------------------------------------------------------------------------------------
-- Testing query to check for invalid dates
---------------------------------------------------------------------------------------------------------------------------
SELECT
  NULLIF(sls_order_dt, 0) AS sls_order_dt -- Returns NULL if the given parameters are equal. Else, returns the first parameter.
FROM bronze.crm_sales_details
WHERE sls_order_dt <=0 OR LEN(sls_order_dt) != 8 -- 8 since the INT value of the dates is 8 digits 20200101 YYYYMMDD

SELECT
  NULLIF(sls_ship_dt, 0) AS sls_ship_dt -- Returns NULL if the given parameters are equal. Else, returns the first parameter.
FROM bronze.crm_sales_details
WHERE sls_ship_dt <=0 OR LEN(sls_ship_dt) != 8

SELECT
  NULLIF(sls_due_dt, 0) AS sls_due_dt -- Returns NULL if the given parameters are equal. Else, returns the first parameter.
FROM bronze.crm_sales_details
WHERE sls_due_dt <=0 OR LEN(sls_due_dt) != 8 

-- To check whether order date is greater than ship date and due date
SELECT
  *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

---------------------------------------------------------------------------------------------------------------------------
-- To check the data consistency between Sales, Quantity, and Price
-- Business Rule: Sales = Quantity * Price
-- Negatives, zeroes, and nulls are not allowed
---------------------------------------------------------------------------------------------------------------------------
SELECT
  sls_sales,
  sls_quantity,
  sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
---------------------------------------------------------------------------------------------------------------------------
-- Transformation query
-- Business Rules:
  -- If Sales is negative, zero, or null, use Quantity * Price
  -- If Price is zero or null, use Sales/Quantity
  -- If Price is negative, convert it to a positive value
---------------------------------------------------------------------------------------------------------------------------

SELECT
  sls_ord_num,
  sls_prd_key,
  sls_cust_id,
  CASE
    WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
    ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) -- In SQL Server, Integers cannot be directly casted as a DATE so we have to cast it into a VARCHAR first then convert to DATE.
  END AS sls_order_dt,
  CASE
    WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
    ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) 
  END AS sls_ship_dt,
  CASE
    WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
    ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) 
  END AS sls_due_dt,
  CASE
    WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price) --Absolute value 
    ELSE sls_sales
  END AS sls_sales,
  sls_quantity,
  CASE
    WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0) 
  END AS sls_price
FROM bronze.crm_sales_details


---------------------------------------------------------------------------------------------------------------------------
-- Load transformation to silver.crm_sales_details
---------------------------------------------------------------------------------------------------------------------------
INSERT INTO silver.crm_sales_details (
  sls_ord_num,
  sls_prd_key,
  sls_cust_id,
  sls_order_dt,
  sls_ship_dt,
  sls_due_dt,
  sls_sales,
  sls_quantity,
  sls_price
)
SELECT
  sls_ord_num,
  sls_prd_key,
  sls_cust_id,
  CASE
    WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
    ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) -- In SQL Server, Integers cannot be directly casted as a DATE so we have to cast it into a VARCHAR first then convert to DATE.
  END AS sls_order_dt,
  CASE
    WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
    ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) 
  END AS sls_ship_dt,
  CASE
    WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
    ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) 
  END AS sls_due_dt,
  CASE
    WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price) --Absolute value 
    ELSE sls_sales
  END AS sls_sales,
  sls_quantity,
  CASE
    WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0) 
  END AS sls_price
FROM bronze.crm_sales_details



























