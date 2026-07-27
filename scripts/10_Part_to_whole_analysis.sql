-- ******************** PART-TO-WHOLE ANALYSIS ( [Measure]/[total measure]*100 by [Dimension]): ************************************************

-- which categories contribute the most to overall sales?

WITH sales_category AS 
(
select category,
SUM(sales_amount) as category_sales
from Gold.fact_sales ff
LEFT JOIN Gold.dim_products pp
ON ff.product_key = pp.product_key
GROUP BY category
)

select category,
category_sales,
SUM(category_sales) OVER() as total_sales,
CONCAT(ROUND(((CAST(category_sales AS float) / SUM(category_sales) OVER() ) * 100),2),'%') as sales_contribution
FROM
sales_category ORDER BY sales_contribution DESC
