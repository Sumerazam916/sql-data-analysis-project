/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

IF OBJECT_ID('Gold.report_customer','V') is not NULL
	 DROP VIEW Gold.report_customer;

GO

CREATE VIEW Gold.report_customer AS

WITH base_query AS (			/* 1. (Gathering essential fields)   */
select 
f.order_number,
f.customer_key,
f.product_key,
c.customer_id,
c.customer_number,
c.first_name,
c.last_name,
CONCAT(c.first_name,' ',c.last_name) as customer_names,
f.quantity,
f.price,
f.sales_amount,
c.gender,
c.marital_status,
c.country,
DATEDIFF(YEAR,c.birthdate,GETDATE()) AS Age,
f.order_date
from gold.fact_sales f
LEFT JOIN Gold.dim_customers c
ON f.customer_key = c.customer_key where order_date is not NULL
)
, aggregate_query AS (				/* 3. (Aggregation) */
select 
customer_key,
customer_id,
customer_names,
age,
gender,
marital_status,
country,
max(order_date) as last_order_date,
count(distinct order_number) as total_orders,
SUM(sales_amount) as total_sales,
SUM(quantity) as total_quantity,
COUNT(distinct product_key) as total_products,
DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) as lifespan_months
from base_query
GROUP BY customer_key, customer_id, customer_names,age,gender,marital_status,country
)
select                           /* 2. (Segments customers into categories (VIP, Regular, New) and age groups) */
customer_key,
customer_id,
customer_names,
age,
gender,
marital_status,
country,
total_orders,
total_sales,
total_quantity,
total_products,
lifespan_months,
CASE 
	 WHEN age < 20 THEN 'Under 20'
	 WHEN age between 20 and 29 THEN '20-29'
	 WHEN age between 30 and 39 THEN '30-39'
	 WHEN age between 40 and 49 THEN '40-49'
	 ELSE '50 and above'
END AS age_group,
CASE WHEN lifespan_months >=12 and total_sales > 5000 THEN 'VIP'
	 WHEN lifespan_months >=12 and total_sales <= 5000 THEN 'REGULAR'
	 ELSE 'NEW'
END AS customer_segments,
														
DATEDIFF(MONTH,last_order_date,GETDATE()) AS recency,		 /* 4. (Calculates valuable KPIs)  */
CASE WHEN total_orders = 0 THEN total_sales
	 ELSE total_sales/total_orders
END AS avg_order_value,

CASE WHEN lifespan_months = 0 THEN total_sales
	 ELSE total_sales/lifespan_months
END AS avg_monthly_spend

from aggregate_query

