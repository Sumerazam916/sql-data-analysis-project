/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================

IF OBJECT_ID('Gold.report_products','V') IS NOT NULL
    DROP VIEW Gold.report_products

GO

CREATE VIEW Gold.report_products AS

WITH base_query AS (       -- 1. BASE QUERY
select 
f.order_number,
f.product_key,
f.customer_key,
p.product_id,
p.product_number,
p.product_name,
p.product_line,
p.category,
p.category_id,
p.subcategory,
p.maintenance_required,
f.price,
f.quantity,
f.sales_amount,
f.order_date

from Gold.fact_sales f
LEFT JOIN Gold.dim_products p
ON f.product_key = p.product_key
)
, aggregation_query AS (
SELECT                      -- 3. AGGREGATION QUERY
product_key,
product_name,
product_line,
category_id,
category,
subcategory,
price,
maintenance_required,
MAX(order_date) as last_order_date,
count(DISTINCT order_number) as total_orders,
SUM(sales_amount) as total_sales,
SUM(quantity) as total_quantity,
COUNT(distinct customer_key) as total_customers,
DATEDIFF(MONTH,MIN(order_date),GETDATE()) +1 AS lifespan_months
from base_query
GROUP BY product_key,product_name,product_line,category_id,category,subcategory,price,maintenance_required
)
select          -- 2. SEGMENTATION and 4. Calculating valuable KPIs
product_key,     
product_name,
product_line,
category_id,
category,
subcategory,
price,
maintenance_required as maintenance_req,
total_orders,
total_sales,
total_quantity as total_qty,
total_customers,
lifespan_months,
CASE
     WHEN total_sales >= 500000 THEN 'High-range'
     WHEN total_sales BETWEEN 100000 AND 500000 THEN 'Mid-range'
     ELSE 'Low-range'
END AS segment_class,
DATEDIFF(MONTH,last_order_date,GETDATE()) AS recency_months,
(total_sales/total_orders) AS avg_order_value,
(total_sales/lifespan_months)AS avg_monthly_revenue
from aggregation_query
