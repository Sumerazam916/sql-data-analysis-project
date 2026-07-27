/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/
Select 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
From INFORMATION_SCHEMA.TABLES;

-- Retrieve all columns for a specific table (dim_customers)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
Where TABLE_NAME = 'dim_customers';

-- Retrieve all columns for a specific table (dim_products)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products';


select * from INFORMATION_SCHEMA.TABLES

select * from INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'fact_sales'
select * from INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'dim_customers'
select * from INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'dim_products'

select count(*) from Gold.fact_sales

select count(*) from Gold.dim_customers

select count(*) from Gold.dim_products

-- verifying the customer and the sales table referencing integration:
select 
COUNT(*) AS rows_not_connected
FROM Gold.fact_sales f
LEFT JOIN Gold.dim_customers c 
    ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;

-- verifying the customer and the sales table referencing integration:
select COUNT(*) AS rows_not_connected
FROM Gold.fact_sales g
LEFT JOIN Gold.dim_products h 
    ON g.product_key = h.product_key
WHERE h.product_key IS NULL;
