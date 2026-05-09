CREATE SCHEMA IF NOT EXISTS silver;

CREATE TABLE silver.customer_info (
    id INT,
    key VARCHAR(50),
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    marital_status VARCHAR(20),
    gndr VARCHAR(20),
    create_date DATE
);

CREATE TABLE silver.product_info (
    id INT,
    key VARCHAR(50),
    name VARCHAR(100),
    cost INT,
    line VARCHAR(50),
    start_date DATE
);

CREATE TABLE silver.sales_info (
    order_num VARCHAR(50),
    product_key VARCHAR(50),
    customer_id INT,
    order_date DATE,
    ship_date DATE,
    due_date DATE,
    sales INT,
    quantity INT,
    price INT
);

CREATE TABLE silver.customer_info_src (
    customer_key VARCHAR(50),
    birth_date DATE,
    gender VARCHAR(20)
);

CREATE TABLE silver.loc (
    customer_key VARCHAR(50),
    country VARCHAR(100)
);

CREATE TABLE silver.category (
    category_id VARCHAR(50),
    category VARCHAR(100),
    sub_category VARCHAR(100),
    maintenance_required VARCHAR(20)
);

INSERT INTO silver.customer_info

SELECT DISTINCT

    id,

    TRIM(key),

    INITCAP(TRIM(firstname)),

    INITCAP(TRIM(lastname)),

    CASE
        WHEN UPPER(marital_status) = 'S' THEN 'Single'
        WHEN UPPER(marital_status) = 'M' THEN 'Married'
        ELSE 'Unknown'
    END,

    CASE
        WHEN UPPER(gndr) = 'M' THEN 'Male'
        WHEN UPPER(gndr) = 'F' THEN 'Female'
        ELSE 'Unknown'
    END,

    create_date

FROM bronze.customer_info

WHERE id IS NOT NULL;


INSERT INTO silver.product_info

SELECT DISTINCT

    id,

    TRIM(key),

    INITCAP(TRIM(name)),

    cost,

    CASE
        WHEN UPPER(line)='S' THEN 'Service'
        WHEN UPPER(line)='M' THEN 'Manufacture'
        WHEN UPPER(line)='T' THEN 'Technology'
        WHEN UPPER(line)='R' THEN 'Retail'
    END,

    start_date

FROM bronze.product_info

WHERE id IS NOT NULL;


INSERT INTO silver.sales_info

SELECT DISTINCT

    order_num,

    TRIM(key),

    cust_id::INT,

    CASE
        WHEN LENGTH(order_date::TEXT) = 8
        THEN TO_DATE(order_date::TEXT, 'YYYYMMDD')
    END,

    CASE
        WHEN LENGTH(ship_date::TEXT) = 8
        THEN TO_DATE(ship_date::TEXT, 'YYYYMMDD')
    END,

    CASE
        WHEN LENGTH(due_date::TEXT) = 8
        THEN TO_DATE(due_date::TEXT, 'YYYYMMDD')
    END,

    sales,

    quantity,

    price

FROM bronze.sales_info

WHERE cust_id IS NOT NULL;


INSERT INTO silver.customer_info_src

SELECT DISTINCT

    TRIM(id),

    b_date,

    CASE
        WHEN UPPER(gender) = 'M' THEN 'Male'
        WHEN UPPER(gender) = 'F' THEN 'Female'
        ELSE 'Unknown'
    END

FROM bronze.customer_info_src

WHERE id IS NOT NULL;


INSERT INTO silver.loc

SELECT DISTINCT

    TRIM(id),

    INITCAP(TRIM(country))

FROM bronze.loc

WHERE id IS NOT NULL;


INSERT INTO silver.category

SELECT DISTINCT

    TRIM(id),

    INITCAP(TRIM(category)),

    INITCAP(TRIM(sub_category)),

    CASE
        WHEN UPPER(maintenance) = 'YES' THEN 'Yes'
        WHEN UPPER(maintenance) = 'NO' THEN 'No'
        ELSE 'Unknown'
    END

FROM bronze.category

WHERE id IS NOT NULL;
