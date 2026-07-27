--**************************************************** 6. RANKING ANALYSIS  ************************************************************

-- WHICH TOP 5 PRODUCTS GENEREATE HIGHEST REVENUE:
select TOP 5 da.product_name, sum(dd.sales_amount) as total_revenue
from Gold.fact_sales dd
LEFT JOIN Gold.dim_products da
ON dd.product_key = da.product_key
GROUP BY da.product_name
ORDER BY total_revenue DESC


-- Worst 5 performing products in terms of sales:
select TOP 5 ea.product_name, sum(ee.sales_amount) as total_revenue
from Gold.fact_sales ee
LEFT JOIN Gold.dim_products ea
ON ee.product_key = ea.product_key
GROUP BY ea.product_name
ORDER BY total_revenue ASC
-- OR


select * from
(
select ROW_NUMBER() OVER(ORDER BY sum(ff.sales_amount)DESC) as rankings,
fa.product_name, sum(ff.sales_amount) as total_revenue
from
Gold.fact_sales ff
LEFT JOIN Gold.dim_products fa
ON fa.product_key = ff.product_key
GROUP BY fa.product_name
)t
WHERE rankings<=5


-- WHICH TOP 5 SUBCATEGORY GENEREATE HIGHEST REVENUE:
select TOP 5 ga.subcategory, sum(gg.sales_amount) as total_revenue
from Gold.fact_sales gg
LEFT JOIN Gold.dim_products ga
ON ga.product_key = gg.product_key
GROUP BY ga.subcategory
ORDER BY total_revenue DESC


-- find 10 customers with the highest revenue:
select * from
(
select 
ROW_NUMBER() OVER(ORDER BY sum(mc.sales_amount) DESC) as rankings,
ha.first_name+ ' ' + ha.last_name as names, sum(hh.sales_amount) as total_revenue
from Gold.fact_sales hh
LEFT JOIN Gold.dim_customers ha
ON hh.customer_key = ha.customer_key
GROUP BY ha.first_name,ha.last_name
)t WHERE t.rankings<=10


-- top 3 customers with fewest orders placed:
select * from
(
select ROW_NUMBER() OVER(ORDER BY count(ii.order_number)) as rankingss,
ia.first_name+' '+ia.last_name as customer_names,
count(ii.order_number) as no_of_orders
from Gold.fact_sales ii 
LEFT JOIN Gold.dim_customers ia
ON ii.customer_key=ia.customer_key
GROUP BY ia.customer_key,ia.first_name,ia.last_name
)t WHERE rankingss<=3

