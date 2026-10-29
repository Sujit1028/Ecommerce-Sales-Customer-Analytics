# DATA LOADING

/*
CREATE DATABASE ecommerce_analytics;
USE ecommerce_analytics;
CREATE TABLE online_retail_raw (
    invoice_no   VARCHAR(20),
    stock_code   VARCHAR(20),
    description  TEXT,
    quantity     VARCHAR(20),
    invoice_date VARCHAR(30),
    unit_price   VARCHAR(30),
    customer_id  VARCHAR(20),
    country      VARCHAR(100)
);
LOAD DATA LOCAL INFILE
'C:/Users/sujit/OneDrive/Creative Cloud Files/Desktop/Project 2 - ecommerce-sales-customer-analytics/data/Processed/Online_Retail.csv'
INTO TABLE online_retail_raw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country
);

SELECT *
FROM online_retail_raw
LIMIT 10;
*/



# DATA QUALITY CHECKS

# total number of rows
SELECT 
	COUNT(*) As Total_Rows
FROM online_retail_raw;

# checking missing values
SELECT
    SUM(invoice_no IS NULL OR TRIM(invoice_no) = '') AS missing_invoices,
    SUM(stock_code IS NULL OR TRIM(stock_code) = '') AS missing_stock_codes,
    SUM(quantity IS NULL OR TRIM(quantity) = '') AS missing_quantities,
    SUM(invoice_date IS NULL OR TRIM(invoice_date) = '') AS missing_dates,
    SUM(unit_price IS NULL OR TRIM(unit_price) = '') AS missing_prices,
    SUM(customer_id IS NULL OR TRIM(customer_id) = '') AS missing_customers
FROM online_retail_raw;

# identifying cancelled orders
SELECT
    COUNT(*) AS cancelled_rows
FROM online_retail_raw
WHERE invoice_no LIKE 'C%';

# checking negative and zero quantity
SELECT
    SUM(quantity < 0) AS negative_quantity_rows,
    SUM(quantity = 0) AS zero_quantity_rows
FROM online_retail_raw;

# checking negative and zero prices
SELECT
    SUM(unit_price < 0) AS negative_price_rows,
    SUM(unit_price = 0) AS zero_price_rows
FROM online_retail_raw;

# checking duplicate records
SELECT
	invoice_no, stock_code,
    COUNT(*) AS number_of_rows
FROM online_retail_raw
GROUP BY invoice_no, stock_code
HAVING COUNT(*) > 1 
LIMIT 20;

# inspecting exact duplicates across data
SELECT COUNT(*) AS exact_duplicate_groups
FROM (
    SELECT
        invoice_no, stock_code, description,
        quantity, invoice_date, unit_price,
        customer_id, country
    FROM online_retail_raw
    GROUP BY
        invoice_no, stock_code, description,
        quantity, invoice_date, unit_price,
        customer_id, country
    HAVING COUNT(*) > 1
) AS duplicates;

# checking extra rows are involved
SELECT
    SUM(number_of_rows) AS rows_in_duplicate_groups,
    SUM(number_of_rows - 1) AS extra_duplicate_rows
FROM (
    SELECT COUNT(*) AS number_of_rows
    FROM online_retail_raw
    GROUP BY
        invoice_no, stock_code, description, quantity,
        invoice_date, unit_price, customer_id, country
    HAVING COUNT(*) > 1
) AS duplicates;

# checking date format
SELECT
    invoice_date
FROM online_retail_raw
LIMIT 10;

# checking missing dates
SELECT COUNT(*) AS blank_dates
FROM online_retail_raw
WHERE invoice_date IS NULL
   OR TRIM(invoice_date) = '';
   
SELECT invoice_date
FROM online_retail_raw
WHERE invoice_date NOT LIKE '__-__-____ __:__'
LIMIT 20;

# converting date format
SELECT
    invoice_date,
    STR_TO_DATE(invoice_date, '%d-%m-%Y %H:%i') AS converted_date
FROM online_retail_raw
LIMIT 10;

# Check for invalid dates
SELECT COUNT(*) AS invalid_dates
FROM online_retail_raw
WHERE STR_TO_DATE(invoice_date, '%d-%m-%Y %H:%i') IS NULL;

# checking missing customer IDs
SELECT COUNT(*) AS missing_customer_id
FROM online_retail_raw
WHERE customer_id = '' ;

# checking missing product descriptions
SELECT COUNT(*) AS missing_descriptions
FROM online_retail_raw
WHERE description = '';

# checking missing countries
SELECT COUNT(*) AS missing_countries
FROM online_retail_raw
WHERE country = '';

# checking missing stock codes
SELECT COUNT(*) AS missing_stock_cd
FROM online_retail_raw
WHERE stock_code = '';

# checking missing invoice numbers
SELECT COUNT(*) AS missing_invoice_no
FROM online_retail_raw
WHERE invoice_no = '';

# checking missing quantities
SELECT COUNT(*) AS missing_quantities
FROM online_retail_raw
WHERE quantity = '';

# checking missing invoice dates
SELECT COUNT(*) AS missing_invoice_dt
FROM online_retail_raw
WHERE invoice_date = '';

# checking missing unit prices
SELECT COUNT(*) AS missing_unit_prices
FROM online_retail_raw
WHERE unit_price = '';

# CREATING A WORKING TABLE 
CREATE TABLE online_retail_clean AS
SELECT *
FROM online_retail_raw;

SELECT COUNT(*) AS total_rows
FROM online_retail_clean;


# BUSINESS ANALYSIS

# Calculate total sales value
SELECT 
	SUM(quantity * unit_price) AS total_sales
FROM online_retail_clean;

# countries generate the most sales
SELECT country,
	SUM(quantity * unit_price) AS total_sales
FROM online_retail_clean
GROUP BY country
ORDER BY total_sales DESC
LIMIT 10;

# product generates most sales
SELECT
    stock_code,
    description,
    SUM(quantity * unit_price) AS total_sales
FROM online_retail_clean
GROUP BY stock_code, description
ORDER BY total_sales DESC
LIMIT 10;

# month generates the most sales
SELECT
    MONTH(STR_TO_DATE(invoice_date, '%d-%m-%Y %H:%i')) AS sales_month,
    SUM(quantity * unit_price) AS total_sales
FROM online_retail_clean
GROUP BY sales_month
ORDER BY total_sales DESC;

# unique customers list
SELECT
    COUNT(DISTINCT customer_id) AS unique_customers
FROM online_retail_clean
WHERE customer_id <> '';

# top 10 customers by spending
SELECT
    customer_id,
    SUM(quantity * unit_price) AS total_spent
FROM online_retail_clean
WHERE customer_id <> ''
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

# customers returning to purchase again
SELECT
    customer_id,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM online_retail_clean
WHERE customer_id <> ''
  AND invoice_no NOT LIKE 'C%'
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 10;

# average order value by country
SELECT
    country,
    SUM(quantity * unit_price) / COUNT(DISTINCT invoice_no) AS average_order_value
FROM online_retail_clean
WHERE invoice_no NOT LIKE 'C%'
GROUP BY country
HAVING COUNT(DISTINCT invoice_no) >= 100
ORDER BY average_order_value DESC
LIMIT 10;
