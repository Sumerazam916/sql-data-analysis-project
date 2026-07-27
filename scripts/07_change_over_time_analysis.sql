-- *********************** CHANGE OVER TIME TREND ANALYSIS (Summation of [measure] by [time]) **********************************

-- YEAR BASED TREND:
select YEAR(order_date) as order_year , sum(sales_amount) as total_sales,
sum(quantity) as total_quantity, count(distinct(customer_key)) as count_of_customers
from Gold.fact_sales
where YEAR(order_date) is not null
group by YEAR(order_date) order by YEAR(order_date)

-- MONTH BASED TREND:
select DATENAME(MONTH,order_date) as order_month,
MONTH(order_date) as order_month_num , sum(sales_amount) as total_sales,
sum(quantity) as total_quantity, count(distinct(customer_key)) as count_of_customers
from Gold.fact_sales
where MONTH(order_date) is not null
group by MONTH(order_date), DATENAME(MONTH,order_date)
order by order_month_num

-- YEAR AND MONTH BASED TREND:
select DATENAME(YEAR,order_date) as order_year,
DATENAME(MONTH,order_date) as order_month,
MONTH(order_date) as order_month_num , sum(sales_amount) as total_sales,
sum(quantity) as total_quantity, count(distinct(customer_key)) as count_of_customers
from Gold.fact_sales
where MONTH(order_date) is not null
group by MONTH(order_date), DATENAME(MONTH,order_date), DATENAME(YEAR,order_date)
order by order_year,order_month_num

-- OR

select DATETRUNC(MONTH,order_date) as order_date,-- (datetrunc takes month as the last unit of info then makes the days as default 1)
count(*) as count_no,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity,
count(distinct(customer_key)) as count_of_customers
from Gold.fact_sales
where MONTH(order_date) is not null
group by DATETRUNC(MONTH,order_date)
order by DATETRUNC(MONTH,order_date)
