-- ******************** Data Segmenatation analysis ([Measure] by [Measure]) : ************************************************

-- Segment the products into cost range then calculate how many products fall in which range?

WITH range_table as (
select product_key,
product_name,
product_cost,
CASE WHEN product_cost < 100 THEN 'Below 100'
	 WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
	 WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
	 ELSE 'Above 1000'
END AS cost_ranges
from Gold.dim_products )

select 
cost_ranges,
count(product_key) as total_products
from range_table
GROUP BY cost_ranges
ORDER BY cost_ranges


/* Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH segment_details AS (
select customer_key,
SUM(sales_amount) AS total_spendings,
MIN(order_date) as first_order,
MAX(order_date) as latest_order,
DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) as interval_months
from gold.fact_sales
GROUP BY customer_key
)
select 
customer_segments,
COUNT(*) as no_of_customers
from 
(
select 
customer_key,
total_spendings,
interval_months,
CASE WHEN interval_months >=12 and total_spendings > 5000 THEN 'VIP'
	 WHEN interval_months >=12 and total_spendings <= 5000 THEN 'REGULAR'
	 ELSE 'NEW'
	 END AS customer_segments
from segment_details
) t 
GROUP BY customer_segments
ORDER BY no_of_customers DESC
