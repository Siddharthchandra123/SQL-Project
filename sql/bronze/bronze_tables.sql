CREATE SCHEMA IF NOT EXISTS bronze;

CREATE TABLE bronze.customer_info (
    id INT,
    key VARCHAR(50),
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    marital_status VARCHAR(10),
    gndr VARCHAR(10),
    create_date DATE
);

CREATE TABLE bronze.product_info (
    id INT,
    key VARCHAR(50),
    name VARCHAR(100),
    cost INT,
    line VARCHAR(10),
    start_date DATE,
    end_date DATE
);

CREATE TABLE bronze.sales_info (
    order_num VARCHAR(50),
    key VARCHAR(50),
    cust_id VARCHAR(50),
    order_date INT,
    ship_date INT,
    due_date INT,
    sales INT,
    quantity INT,
    price INT
);

CREATE TABLE bronze.customer_info_src (
    id VARCHAR(50),
    b_date DATE,
    gender VARCHAR(10)
);

CREATE TABLE bronze.loc (
    id VARCHAR(50),
    country VARCHAR(100)
);

CREATE TABLE bronze.category (
    id VARCHAR(50),
    category VARCHAR(100),
    sub_category VARCHAR(100),
    maintenance VARCHAR(10)
);

COPY bronze.customer_info
FROM './sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
DELIMITER ','
CSV HEADER;

COPY bronze.product_info
FROM './sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
DELIMITER ','
CSV HEADER;

COPY bronze.sales_info
FROM './sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
DELIMITER ','
CSV HEADER;

COPY bronze.customer_info_src
FROM './sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
DELIMITER ','
CSV HEADER;

COPY bronze.loc
FROM './sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
DELIMITER ','
CSV HEADER;

COPY bronze.category
FROM './sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
DELIMITER ','
CSV HEADER;


