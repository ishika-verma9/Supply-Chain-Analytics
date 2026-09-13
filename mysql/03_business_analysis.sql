
-- 03_business_analysis.sql
-- Dataset: synthetic FMCG beverage distribution data 
-- Q1. What are the top 5 SKUs by total demand?
SELECT
    sku_name,
    SUM(demand_units) AS total_demand
FROM beverage_distribution_data
GROUP BY sku_name
ORDER BY total_demand DESC
LIMIT 5;

-- Q2. Which warehouses have the highest demand?

SELECT
    warehouse_name,
    SUM(demand_units) AS total_demand
FROM beverage_distribution_data
GROUP BY warehouse_name
ORDER BY total_demand DESC;


-- Q3. Which warehouses have the highest stockout rate?

SELECT
    warehouse_name,
    ROUND(100.0 * SUM(stockout_flag) / COUNT(*), 2) AS stockout_rate_pct
FROM beverage_distribution_data
GROUP BY warehouse_name
ORDER BY stockout_rate_pct DESC;


-- Q4. What is the monthly demand trend?
SELECT
    DATE_FORMAT(date, '%Y-%m') AS demand_month,
    SUM(demand_units) AS total_demand
FROM beverage_distribution_data
GROUP BY demand_month
ORDER BY demand_month;

-- Q5. Which SKU-warehouse combinations have the highest demand?
SELECT
    sku_name,
    warehouse_name,
    SUM(demand_units) AS total_demand
FROM beverage_distribution_data
GROUP BY sku_name, warehouse_name
ORDER BY total_demand DESC
LIMIT 5;
-- Q6. Which SKUs have the highest average available inventory?

SELECT
    sku_name,
    ROUND(AVG(available_stock_units), 0) AS avg_available_stock
FROM beverage_distribution_data
GROUP BY sku_name
ORDER BY avg_available_stock DESC
LIMIT 5;
-- Q7. Rank SKUs within each warehouse by total demand (window function)

WITH sku_warehouse_demand AS (
    SELECT
        warehouse_name,
        sku_name,
        SUM(demand_units) AS total_demand
    FROM beverage_distribution_data
    GROUP BY warehouse_name, sku_name
)
SELECT
    warehouse_name,
    sku_name,
    total_demand,
    RANK() OVER (PARTITION BY warehouse_name ORDER BY total_demand DESC) AS demand_rank
FROM sku_warehouse_demand
ORDER BY warehouse_name, demand_rank;

-- Q8. Cumulative demand over time (window function, running total)

SELECT
    date,
    sku_name,
    demand_units,
    SUM(demand_units) OVER (
        PARTITION BY sku_name
        ORDER BY date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_demand
FROM beverage_distribution_data
WHERE sku_name = 'Lager 650ml'
ORDER BY date;
-- Q9. Identify high-risk SKU-warehouse combinations (CASE WHEN)

WITH combo_metrics AS (
    SELECT
        sku_name,
        warehouse_name,
        ROUND(100.0 * SUM(stockout_flag) / COUNT(*), 2) AS stockout_rate_pct,
        ROUND(AVG(available_stock_units), 0) AS avg_stock
    FROM beverage_distribution_data
    GROUP BY sku_name, warehouse_name
)
SELECT
    sku_name,
    warehouse_name,
    stockout_rate_pct,
    avg_stock,
    CASE
        WHEN stockout_rate_pct > 20 THEN 'High Risk'
        WHEN stockout_rate_pct > 10 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category
FROM combo_metrics
ORDER BY stockout_rate_pct DESC
LIMIT 10;

-- Q10. SKU-level demand summary joined with warehouse-level stockout

WITH sku_summary AS (
    SELECT
        sku_id,
        sku_name,
        SUM(demand_units) AS total_demand
    FROM beverage_distribution_data
    GROUP BY sku_id, sku_name
),
warehouse_summary AS (
    SELECT
        warehouse_id,
        warehouse_name,
        ROUND(100.0 * SUM(stockout_flag) / COUNT(*), 2) AS warehouse_stockout_rate_pct
    FROM beverage_distribution_data
    GROUP BY warehouse_id, warehouse_name
),
sku_warehouse_detail AS (
    SELECT sku_id, warehouse_id, SUM(demand_units) AS combo_demand
    FROM beverage_distribution_data
    GROUP BY sku_id, warehouse_id
)
SELECT
    s.sku_name,
    s.total_demand,
    w.warehouse_name,
    w.warehouse_stockout_rate_pct,
    d.combo_demand
FROM sku_warehouse_detail d
JOIN sku_summary s ON s.sku_id = d.sku_id
JOIN warehouse_summary w ON w.warehouse_id = d.warehouse_id
ORDER BY s.total_demand DESC, d.combo_demand DESC
LIMIT 10;

