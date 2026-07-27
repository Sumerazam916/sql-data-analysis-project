--**************************************************** 2. DIMENSION EXPLORATION ************************************************************


select distinct country from Gold.dim_customers
select distinct category, subcategory , product_name from Gold.dim_products order by 1,2,3

select product_key from Gold.dim_products where product_key is null
select customer_key from Gold.dim_customers where customer_key is null
select order_number from Gold.fact_sales where order_number is null

-- checking for any product with corrupted date history:
select * from Gold.dim_products where start_date > end_date order by start_date


-- Testing for whitespaces and null:
SELECT
    SUM(CASE WHEN product_name = '' THEN 1 ELSE 0 END) AS empty_string_names,
    SUM(CASE WHEN LEN(product_name) != LEN(TRIM(product_name)) THEN 1 ELSE 0 END) AS untrimmed_names
FROM Gold.dim_products;

-- checking the distinct categories and their occurences of gender dimension:
select gender, 
COUNT(*) AS total_occurrences
FROM Gold.dim_customers
GROUP BY gender;
