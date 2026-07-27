--**************************************************** 3.DATE TIME EXPLORATION ************************************************************


select min(order_date) as first_order_date, max(order_date) as last_order_date,
Datediff(year,min(order_date),max(order_date)) as order_date_range from Gold.fact_sales

select min(ship_date) as first_ship_date, max(ship_date) as last_ship_date,
Datediff(year,min(ship_date),max(ship_date)) as ship_date_range from Gold.fact_sales

select min(due_date) as first_due_date, max(due_date) as last_due_date,
Datediff(year,min(due_date),max(due_date)) as due_date_range from Gold.fact_sales

select min(birthdate) as oldest_customer_bday, Datediff(year,min(birthdate),GETDATE()) AS oldest_customer_age,
max(birthdate) as youngest_customer_bday, Datediff(year,max(birthdate),GETDATE()) AS youngest_customer_age 
from Gold.dim_customers
