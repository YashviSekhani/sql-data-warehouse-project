/*
=====================================================================
Quality Checks
=====================================================================
Script Purpose:
  This script performs various quality checks for data consistency, accuracy,
  and standardization across the 'silver' schema. It includes checks for:
  - Null or duplicate primary keys.
  - Unwanted spaces in string fields.
  - Data standardization and consistency.
  - Invalid data ranges and orders.
  - Data consistency between related fields.

Usage Notes:
  - Run these checks after data loading Silver layer.
  - Investigate and resolve any discrepancies found during the checks.
======================================================================
*/

SELECT
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info


SELECT 
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 or prd_id IS NULL

SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

SELECT DISTINCT prd_line
FROM silver.crm_prd_info

SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt


SELECT 
NULLIF(sls_order_dt , 0) sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt <= 0
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101

SELECT 
*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

SELECT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price


SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

SELECT DISTINCT gen 
FROM silver.erp_cust_az12


SELECT DISTINCT cntry 
FROM silver.erp_loc_a101
ORDER BY cntry


SELECT * 
FROM silver.erp_px_cat_g1v2
WHERE maintenance != TRIM(maintenance)
OR cat != TRIM(cat)
OR subcat != TRIM(subcat)

SELECT DISTINCT 
maintenance
FROM silver.erp_px_cat_g1v2









