DROP TABLE IF EXISTS clickhouse.default.report_products;
CREATE TABLE clickhouse.default.report_products AS
SELECT 
    p.brand || ': ' || p.name AS product_name,
    p.category,
    sum(f.sale_quantity) AS total_quantity_sold,
    sum(f.sale_total_price) AS total_revenue,
    avg(p.rating) AS average_rating,
    sum(p.reviews) AS total_reviews
FROM clickhouse.default.fact_sales f
JOIN clickhouse.default.dim_products p ON f.product_id = p.id
GROUP BY p.name, p.brand, p.category;



DROP TABLE IF EXISTS clickhouse.default.report_customers;
CREATE TABLE clickhouse.default.report_customers AS
SELECT 
    c.id AS customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.country,
    sum(f.sale_total_price) AS total_spent,
    sum(f.sale_total_price) / count(f.id) AS average_order_value
FROM clickhouse.default.fact_sales f
JOIN clickhouse.default.dim_customers c ON f.customer_id = c.id
GROUP BY c.id, c.first_name, c.last_name, c.country;



DROP TABLE IF EXISTS clickhouse.default.report_time;
CREATE TABLE clickhouse.default.report_time AS
SELECT 
    date_trunc('month', f.date) AS sales_month,
    extract(year from f.date) AS sales_year,
    count(f.id) AS order_count,
    sum(f.sale_total_price) AS monthly_revenue,
    avg(f.sale_total_price) AS avg_order_size
FROM clickhouse.default.fact_sales f
GROUP BY 1, 2;



DROP TABLE IF EXISTS clickhouse.default.report_stores;
CREATE TABLE clickhouse.default.report_stores AS
SELECT 
    s.name AS store_name,
    s.city,
    s.country,
    sum(f.sale_total_price) AS total_revenue,
    sum(f.sale_total_price) / count(f.id) AS store_average_check
FROM clickhouse.default.fact_sales f
JOIN clickhouse.default.dim_stores s ON f.store_id = s.id
GROUP BY s.name, s.city, s.country;



DROP TABLE IF EXISTS clickhouse.default.report_suppliers;
CREATE TABLE clickhouse.default.report_suppliers AS
SELECT 
    s.name AS supplier_name,
    s.country AS supplier_country,
    sum(f.sale_total_price) AS total_revenue_generated,
    avg(p.price) AS avg_product_price
FROM clickhouse.default.fact_sales f
JOIN clickhouse.default.dim_suppliers s ON f.supplier_id = s.id
JOIN clickhouse.default.dim_products p ON f.product_id = p.id
GROUP BY s.name, s.country;



DROP TABLE IF EXISTS clickhouse.default.report_quality;
CREATE TABLE clickhouse.default.report_quality AS
WITH product_metrics AS (
    SELECT 
        p.brand || ': ' || p.name AS product_name,
        rating,
        reviews,
        sum(f.sale_quantity) AS sales_volume
    FROM clickhouse.default.fact_sales f
    JOIN clickhouse.default.dim_products p ON f.product_id = p.id
    GROUP BY p.name, p.brand, p.rating, p.reviews
) SELECT 
    product_name,
    rating,
    reviews,
    sales_volume,
    corr(rating, cast(sales_volume as double)) OVER() as correlation_rating_sales
FROM product_metrics;
