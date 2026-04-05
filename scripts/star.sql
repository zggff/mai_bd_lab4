-- DROP TABLE IF EXISTS clickhouse.default.dim_customers;
-- DROP TABLE IF EXISTS clickhouse.default.dim_sellers;
-- DROP TABLE IF EXISTS clickhouse.default.dim_stores;
-- DROP TABLE IF EXISTS clickhouse.default.dim_suppliers;
-- DROP TABLE IF EXISTS clickhouse.default.dim_products;
-- DROP TABLE IF EXISTS clickhouse.default.fact_sales;

CREATE TABLE IF NOT EXISTS clickhouse.default.dim_customers AS
SELECT DISTINCT 
    sale_customer_id AS id, 
    customer_first_name as first_name,
    customer_last_name as last_name,
    customer_age as age,
    customer_email as email,
    customer_country as country,
    customer_postal_code as postal_code,
    customer_pet_type as pet_type,
    customer_pet_name as pet_name,
    customer_pet_breed as pet_breed
FROM (
    SELECT * FROM postgresql.public.raw_data
    UNION ALL
    SELECT * FROM clickhouse.default.raw_data);

CREATE TABLE IF NOT EXISTS clickhouse.default.dim_sellers AS
SELECT DISTINCT 
    sale_seller_id AS id, 
    seller_first_name as first_name,
    seller_last_name as last_name,
    seller_email as email,
    seller_country as country,
    seller_postal_code as postal_code
FROM (
    SELECT * FROM postgresql.public.raw_data
    UNION ALL
    SELECT * FROM clickhouse.default.raw_data);

CREATE TABLE IF NOT EXISTS clickhouse.default.dim_stores AS
SELECT DISTINCT 
    row_number() OVER () AS id,
    store_name as name,
    store_location as location,
    store_city as city,
    store_state as state,
    store_country as country,
    store_phone as phone,
    store_email as email
FROM (
    SELECT * FROM postgresql.public.raw_data
    UNION ALL
    SELECT * FROM clickhouse.default.raw_data);

CREATE TABLE IF NOT EXISTS clickhouse.default.dim_suppliers AS
SELECT DISTINCT 
    row_number() OVER () AS id,
    supplier_name as name,
    supplier_contact as contact,
    supplier_email as email,
    supplier_phone as phone,
    supplier_address as address,
    supplier_city as city,
    supplier_country as country
FROM (
    SELECT * FROM postgresql.public.raw_data
    UNION ALL
    SELECT * FROM clickhouse.default.raw_data);

CREATE TABLE IF NOT EXISTS clickhouse.default.dim_products AS
SELECT DISTINCT 
    sale_product_id AS id, 
    product_name as name,
    product_category as category,
    product_price as price,
    product_quantity as quantity,
    product_weight as weight,
    product_color as color,
    product_size as size,
    product_brand as brand,
    product_material as material,
    product_description as description,
    product_rating as rating,
    product_reviews as reviews,
    product_release_date as release_date,
    product_expiry_date as expiry_date
FROM (
    SELECT * FROM postgresql.public.raw_data
    UNION ALL
    SELECT * FROM clickhouse.default.raw_data);

CREATE TABLE IF NOT EXISTS clickhouse.default.fact_sales AS
SELECT DISTINCT 
    rd.id as id,
    sale_date as date,
    sale_customer_id as customer_id,
    sale_seller_id as seller_id,
    sale_product_id as product_id,
    st.id as store_id,
    sp.id as supplier_id,
    sale_quantity,
    sale_total_price,
    pet_category
FROM (
    SELECT * FROM postgresql.public.raw_data
    UNION ALL
    SELECT * FROM clickhouse.default.raw_data) rd
LEFT JOIN clickhouse.default.dim_stores st
    ON store_email = st.email
LEFT JOIN clickhouse.default.dim_suppliers sp 
    ON supplier_email = sp.email;
