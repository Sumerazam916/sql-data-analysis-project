-- ******************** PERFORMANCE ANALYSIS ( current[measure] - target[measure] ): ************************************************

-- analyze the yearly performance of products by comparing their sales to the average sales performance and also the previous year sales
--   for the same product:

WITH current_sales_yearly as
(
select YEAR(f.order_date) as order_date_yearly,
p.product_name,
SUM(sales_amount) as current_sales 
from gold.fact_sales f
LEFT JOIN Gold.dim_products p
ON f.product_key = p.product_key
WHERE order_date is not NULL
GROUP BY product_name, YEAR(order_date)
)
select order_date_yearly,
product_name,
current_sales,
LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_date_yearly) as py_sales,
AVG(current_sales) OVER(PARTITION BY product_name) as avg_sales,
current_sales - AVG(current_sales) OVER(PARTITION BY product_name) as diff_avg,
current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_date_yearly) as diff_py,

CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Average'
	 WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Lower than Average'
	 ELSE 'Average'
END AS performance_average
,
CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_date_yearly) >0 THEN 'INCREASE' 
	 WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_date_yearly) <0 THEN 'DECREASE'
	 ELSE 'SAME AS LAST YEAR'
END AS performance_py
from current_sales_yearly
ORDER BY product_name, order_date_yearly
