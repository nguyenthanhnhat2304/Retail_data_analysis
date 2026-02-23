--Question 1. How has total revenue changed over time?
SELECT 
    DATE(sales_date) AS sales_day,
    SUM(total_amount) AS daily_revenue
FROM fact_sales
GROUP BY DATE(sales_date)
ORDER BY sales_day;

--Question 2. What are the top 10 products by total revenue?
SELECT 
    p.product_name,
    SUM(fs.total_amount) AS product_revenue 
FROM fact_sales fs
JOIN dim_products p ON fs.product_sk = p.product_sk         
GROUP BY p.product_name
ORDER BY product_revenue DESC
LIMIT 10;

--Question 3. Which product categories generate the highest revenue?
SELECT 
    p.category,
    SUM(fs.total_amount) AS category_revenue    
FROM fact_sales fs
JOIN dim_products p ON fs.product_sk = p.product_sk
GROUP BY p.category
ORDER BY category_revenue DESC;

--Question 4. What are the top 10 stores by total revenue?
SELECT 
    s.store_name,
    SUM(fs.total_amount) AS store_revenue
FROM fact_sales fs
JOIN dim_stores s ON fs.store_sk = s.store_sk
GROUP BY s.store_name
ORDER BY store_revenue DESC
LIMIT 10;

--Question 5. Who are the top 10 salespersons based on total sales revenue?
SELECT 
    sp.salesperson_name,
    SUM(fs.total_amount) AS salesperson_revenue
FROM fact_sales fs
JOIN dim_salespersons sp ON fs.salesperson_sk = sp.salesperson_sk
GROUP BY sp.salesperson_name
ORDER BY salesperson_revenue DESC
LIMIT 10;

--Question 6. Top 10 marketing campaigns generate the highest revenue?
SELECT 
    c.campaign_name,
    SUM(fs.total_amount) AS campaign_revenue
FROM fact_sales fs
JOIN dim_campaigns c ON fs.campaign_sk = c.campaign_sk
GROUP BY c.campaign_name
ORDER BY campaign_revenue DESC
LIMIT 10;

--Question 7. Which marketing campaigns deliver the highest return on investment (ROI)?
SELECT 
    c.campaign_name,
    c.campaign_budget,
    SUM(fs.total_amount) AS revenue,
    ROUND(SUM(fs.total_amount) / c.campaign_budget, 2) AS roi
FROM fact_sales fs
JOIN dim_campaigns c 
    ON fs.campaign_sk = c.campaign_sk
GROUP BY c.campaign_name, c.campaign_budget
ORDER BY roi DESC;

--Question 8. Which customer segments contribute the most to total revenue?
SELECT 
    c.customer_segment,
    SUM(fs.total_amount) AS segment_revenue 
FROM fact_sales fs
JOIN dim_customers c ON fs.customer_sk = c.customer_sk
GROUP BY c.customer_segment
ORDER BY segment_revenue DESC;

--Question 9. At what time of day do customers generate the highest sales revenue?
SELECT 
    HOUR(sales_date) AS sales_hour,
    SUM(total_amount) AS hourly_revenue
FROM fact_sales
GROUP BY HOUR(sales_date)
ORDER BY hourly_revenue DESC;

--Question 10. Top 3 product categories perform best in each store?
WITH category_revenue AS (
    SELECT  
        s.store_name,
        p.category,
        SUM(fs.total_amount) AS category_revenue,
        ROW_NUMBER() OVER (PARTITION BY s.store_name ORDER BY SUM(fs.total_amount) DESC) AS rn
    FROM fact_sales fs
    JOIN dim_stores s ON fs.store_sk = s.store_sk
    JOIN dim_products p ON fs.product_sk = p.product_sk
    GROUP BY s.store_name, p.category)
SELECT 
    store_name,
    category,
    category_revenue
FROM category_revenue
WHERE rn <= 3
ORDER BY store_name, category_revenue DESC;

