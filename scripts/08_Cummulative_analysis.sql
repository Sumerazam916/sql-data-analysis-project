-- **************** CUMMULATIVE ANALYSIS (sum of [Cummulative_measure] by [Date_dimension]): ***************************************

-- total running sales and moving average price (monthly):
select order_date_months,
total_sales as total_sales_yearly,
sum(total_sales) OVER(partition by YEAR(order_date_months) order by order_date_months) as running_total_sales,
average_price as average_price_monthly,
avg(average_price) OVER(partition by YEAR(order_date_months) order by order_date_months) as moving_average_sales
from
(
select DATETRUNC(MONTH,order_date) as order_date_months,
sum(sales_amount) as total_sales,
avg(price) as average_price
from Gold.fact_sales WHERE order_date is not NULL
GROUP BY DATETRUNC(MONTH,order_date)
)t

-- total running sales and moving average(yearly):
select order_date_year,
total_sales_yearly,
sum(total_sales_yearly) OVER(order by order_date_year) as running_total_sales,
average_price as average_price_yearly,
avg(average_price) OVER(order by order_date_year) as moving_average_sales
from
(
select DATETRUNC(YEAR,order_date) as order_date_year,
sum(sales_amount) as total_sales_yearly,
avg(price) as average_price
from Gold.fact_sales WHERE order_date is not NULL
GROUP BY DATETRUNC(YEAR,order_date)
)t
