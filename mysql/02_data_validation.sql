-- 02_data_validation.sql



SELECT COUNT(*) AS total_rows
FROM beverage_distribution_data;


SELECT COUNT(DISTINCT sku_id) AS unique_skus
FROM beverage_distribution_data;


SELECT COUNT(DISTINCT warehouse_id) AS unique_warehouses
FROM beverage_distribution_data;

SELECT MIN(date) AS earliest_date, MAX(date) AS latest_date
FROM beverage_distribution_data;


SELECT
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END)               AS null_date,
    SUM(CASE WHEN sku_id IS NULL THEN 1 ELSE 0 END)                 AS null_sku_id,
    SUM(CASE WHEN warehouse_id IS NULL THEN 1 ELSE 0 END)           AS null_warehouse_id,
    SUM(CASE WHEN demand_units IS NULL THEN 1 ELSE 0 END)           AS null_demand,
    SUM(CASE WHEN available_stock_units IS NULL THEN 1 ELSE 0 END)  AS null_available_stock,
    SUM(CASE WHEN fulfilled_units IS NULL THEN 1 ELSE 0 END)        AS null_fulfilled,
    SUM(CASE WHEN stockout_flag IS NULL THEN 1 ELSE 0 END)          AS null_stockout_flag
FROM beverage_distribution_data;
