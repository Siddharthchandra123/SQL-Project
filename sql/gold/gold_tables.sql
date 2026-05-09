CREATE SCHEMA IF NOT EXISTS gold;


CREATE TABLE gold.dim_customers AS

SELECT DISTINCT

    c.id AS customer_id,

    c.key AS customer_key,

    CONCAT(c.firstname, ' ', c.lastname) AS full_name,

    c.marital_status,

    c.gndr AS gender,

    d.birth_date,

    l.country,

    c.create_date

FROM silver.customer_info c

LEFT JOIN silver.customer_info_src d
ON c.key = d.customer_key

LEFT JOIN silver.loc l
ON c.key = l.customer_key;



CREATE TABLE gold.dim_products AS

SELECT DISTINCT

    p.id AS product_id,

    p.key AS product_key,

    p.name AS product_name,

    p.cost,

    p.line AS product_line,

    c.category,

    c.sub_category,

    c.maintenance_required,

    p.start_date

FROM silver.product_info p

LEFT JOIN silver.category c
ON SPLIT_PART(p.key, '-', 1) || '_' ||
   SPLIT_PART(p.key, '-', 2) = c.category_id;



CREATE TABLE gold.dim_dates AS

SELECT DISTINCT

    order_date AS date_value,

    EXTRACT(YEAR FROM order_date) AS year,

    EXTRACT(MONTH FROM order_date) AS month,

    EXTRACT(DAY FROM order_date) AS day,

    TO_CHAR(order_date, 'Month') AS month_name,

    EXTRACT(QUARTER FROM order_date) AS quarter

FROM silver.sales_info;



CREATE TABLE gold.fact_sales AS

SELECT

    s.order_num,

    s.product_key,

    s.customer_id,

    s.order_date,

    s.ship_date,

    s.due_date,

    s.sales,

    s.quantity,

    s.price

FROM silver.sales_info s;

SELECT SUM(sales) AS total_revenue
FROM gold.fact_sales;


SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(sales) AS revenue
FROM gold.fact_sales
GROUP BY month
ORDER BY month;


SELECT
    p.product_name,
    SUM(f.sales) AS revenue
FROM gold.fact_sales f
JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;


SELECT
    c.full_name,
    SUM(f.sales) AS total_spending
FROM gold.fact_sales f
JOIN gold.dim_customers c
ON f.customer_id = c.customer_id
GROUP BY c.full_name
ORDER BY total_spending DESC
LIMIT 10;


SELECT
    c.country,
    SUM(f.sales) AS revenue
FROM gold.fact_sales f
JOIN gold.dim_customers c
ON f.customer_id = c.customer_id
GROUP BY c.country
ORDER BY revenue DESC;
