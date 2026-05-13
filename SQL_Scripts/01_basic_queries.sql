-- ============================================
-- DATA ANALYTICS SQL SCRIPTS
-- Author: edeki101
-- Database: PostgreSQL & BigQuery
-- ============================================

-- 1. Basic SELECT with filtering
SELECT 
    customer_name,
    city,
    country
FROM customers
WHERE country = 'Nigeria'
ORDER BY customer_name;

-- 2. Aggregation - Total sales per customer
SELECT 
    c.customer_name,
    COUNT(o.order_id) as total_orders,
    SUM(o.amount) as total_spent,
    AVG(o.amount) as avg_order_value
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- 3. Window Function - Rank customers
SELECT 
    c.customer_name,
    SUM(o.amount) as total_spent,
    RANK() OVER (ORDER BY SUM(o.amount) DESC) as rank
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

-- 4. CTE - Customer spending tiers
WITH customer_spending AS (
    SELECT 
        c.customer_name,
        c.city,
        SUM(o.amount) as total_spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_name, c.city
)
SELECT *,
    CASE
        WHEN total_spent >= 1000 THEN 'High Value'
        WHEN total_spent >= 500  THEN 'Medium Value'
        ELSE 'Low Value'
    END as customer_tier
FROM customer_spending
ORDER BY total_spent DESC;
