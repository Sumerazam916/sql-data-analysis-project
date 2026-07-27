--**************************************************** 4.MEASURE ANALYSIS ************************************************************

-- FIND TOTAL SALES

select sum(sales_amount) as total_sales from Gold.fact_sales

-- FIND HOW MANY ITEMS WERE SOLD

select sum(quantity) as total_items_sold from Gold.fact_sales

-- FIND THE AVERAGE SELLING PRICE

select AVG(price) as average_price from Gold.fact_sales

-- FIND TOTAL NUMBER OF ORDERS

select count(distinct order_number) as total_orders from Gold.fact_sales

-- FIND TOTAL NUMBER OF PRODUCTS

select count(distinct product_name) as total_products from Gold.dim_products

-- FIND TOTAL NUMBER OF CUSTOMERS

select count(customer_key) as total_customers from Gold.dim_customers
-- OR
select count(customer_id) as total_customers from Gold.dim_customers


-- FIND TOTAL NUMBER OF CUSTOMERS THAT HAVE PLACED AN ORDER

select count(distinct customer_key) as total_customer from Gold.fact_sales
-- 0R
select count(distinct order_number) as total_customer2 from Gold.fact_sales

-- CREATING A REPORT FOR THE FOLLOWING AGGREGATED DATA OF MEASURES:

select 'Total_Sales' as measures, sum(sales_amount) as amount from Gold.fact_sales
UNION ALL
select 'Total_Quantity' as measures, sum(quantity) as total_items_sold from Gold.fact_sales
UNION ALL
select 'Average_Selling_Price', AVG(price) from Gold.fact_sales
UNION ALL
select 'Total_Orders', count(distinct order_number) from Gold.fact_sales
UNION ALL
select 'Total_Products',count(distinct product_name) from Gold.dim_products
UNION ALL
select 'Total_Customers',count(customer_key) from Gold.dim_customers
UNION ALL
select 'Total_Customers_PlacedOrder' , count(distinct customer_key) as total_customer from Gold.fact_sales
