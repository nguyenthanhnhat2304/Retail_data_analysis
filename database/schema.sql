CREATE DATABASE IF NOT EXISTS retail_db;
USE retail_db;

CREATE TABLE dim_campaigns(
    campaign_sk INT PRIMARY KEY,
    campaign_id VARCHAR(30),
    campaign_name VARCHAR(100),
    start_date_sk INT,
    end_date_sk INT,
    campaign_budget DECIMAL(12,2),

    INDEX idx_campaign_name(campaign_name),
    INDEX idx_campaign_period(start_date_sk, end_date_sk));

CREATE TABLE dim_customers(
    customer_sk INT PRIMARY KEY,
    customer_id VARCHAR(30),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    residential_location VARCHAR(100),
    customer_segment VARCHAR(50),

    INDEX idx_customer_segment(customer_segment),
    INDEX idx_customer_email(email));

CREATE TABLE dim_products(
    product_sk INT PRIMARY KEY,
    product_id VARCHAR(30),
    product_name VARCHAR(150),
    category VARCHAR(50),
    brand VARCHAR(50),
    origin_location VARCHAR(100),

    INDEX idx_category(category),
    INDEX idx_brand(brand));  

CREATE TABLE dim_salespersons (
    salesperson_sk INT PRIMARY KEY,
    salesperson_id VARCHAR(30),
    salesperson_name VARCHAR(100),
    salesperson_role VARCHAR(50),

    INDEX idx_salesperson_role(salesperson_role));

CREATE TABLE dim_stores(
    store_sk INT PRIMARY KEY,
    store_id VARCHAR(30),
    store_name VARCHAR(100),
    store_type VARCHAR(50),
    store_location VARCHAR(100),
    store_manager_sk INT,

    INDEX idx_store_type (store_type),
    INDEX idx_store_location (store_location));

CREATE TABLE fact_sales(
    sales_sk INT PRIMARY KEY,
    sales_id VARCHAR(30),
    customer_sk INT NOT NULL,
    product_sk INT NOT NULL,
    store_sk INT NOT NULL,
    salesperson_sk INT NOT NULL,
    campaign_sk INT,
    sales_date DATETIME NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    
    INDEX idx_customer(customer_sk),
    INDEX idx_product(product_sk),
    INDEX idx_store(store_sk),
    INDEX idx_salesperson(salesperson_sk),
    INDEX idx_campaign(campaign_sk),
    INDEX idx_sales_date(sales_date));    



