-- What are the overall business KPIs? --
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_unique_id) AS total_customers,
    COUNT(DISTINCT product_id) AS total_products,
    COUNT(DISTINCT seller_id) AS total_sellers,
    ROUND(SUM(price)::numeric, 2) AS total_sales,
    ROUND(AVG(price)::numeric, 2) AS avg_order_item_value
FROM ecommerce_sales
WHERE price IS NOT NULL;

--How are sales trending month by month? --
SELECT
    purchase_year,
    purchase_month,
    ROUND(SUM(price)::numeric, 2) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders
FROM ecommerce_sales
WHERE price IS NOT NULL
GROUP BY purchase_year, purchase_month
ORDER BY purchase_year, MIN(order_purchase_timestamp);

--Which year generated the highest sales?--
SELECT
    purchase_year,
    ROUND(SUM(price)::numeric, 2) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders
FROM ecommerce_sales
WHERE price IS NOT NULL
GROUP BY purchase_year
ORDER BY total_sales DESC;

--Which product categories generate the most revenue? --
SELECT
    product_category_name_english_x AS category,
    COUNT(*) AS items_sold,
    ROUND(SUM(price)::numeric, 2) AS total_sales
FROM ecommerce_sales
WHERE product_id IS NOT NULL
  AND price IS NOT NULL
GROUP BY product_category_name_english_x
ORDER BY total_sales DESC
LIMIT 10;

-- Which states generate the most sales?--
SELECT
    customer_state,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(price)::numeric, 2) AS total_sales
FROM ecommerce_sales
WHERE price IS NOT NULL
GROUP BY customer_state
ORDER BY total_sales DESC;

--Which products generate the highest revenue?--
SELECT
    product_id,
    COUNT(*) AS items_sold,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(price)::numeric, 2) AS total_sales
FROM ecommerce_sales
WHERE product_id IS NOT NULL
  AND price IS NOT NULL
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 10;

--Which sellers generate the highest revenue?--
SELECT
    seller_id,
    COUNT(*) AS items_sold,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(price)::numeric, 2) AS total_sales
FROM ecommerce_sales
WHERE seller_id IS NOT NULL
  AND price IS NOT NULL
GROUP BY seller_id
ORDER BY total_sales DESC
LIMIT 10;

--Who are the highest-value customers?--
SELECT
    customer_unique_id,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(price)::numeric, 2) AS total_spent
FROM ecommerce_sales
WHERE customer_unique_id IS NOT NULL
  AND product_id IS NOT NULL
  AND price IS NOT NULL
GROUP BY customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;

--Which payment methods are most popular?--
SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value)::numeric, 2) AS total_payment_value
FROM ecommerce_sales
WHERE payment_type IS NOT NULL
GROUP BY payment_type
ORDER BY total_orders DESC;


--How long does it take to deliver orders?--
SELECT
    ROUND(AVG(delivery_days)::numeric, 2) AS avg_delivery_days,
    MIN(delivery_days) AS fastest_delivery_days,
    MAX(delivery_days) AS slowest_delivery_days
FROM ecommerce_sales
WHERE delivery_days IS NOT NULL;

--What is the distribution of order statuses?--
SELECT
    order_status,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT order_id) * 100.0 /
        SUM(COUNT(DISTINCT order_id)) OVER (),
        2
    ) AS order_percentage
FROM ecommerce_sales
GROUP BY order_status
ORDER BY total_orders DESC;

--Which categories have the best customer ratings?--
SELECT
    product_category_name_english_x AS category,
    COUNT(review_score) AS total_reviews,
    ROUND(AVG(review_score)::numeric, 2) AS avg_rating
FROM ecommerce_sales
WHERE product_category_name_english_x IS NOT NULL
  AND review_score IS NOT NULL
GROUP BY product_category_name_english_x
HAVING COUNT(review_score) >= 50
ORDER BY avg_rating DESC
LIMIT 10;