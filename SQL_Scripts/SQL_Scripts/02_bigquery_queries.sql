-- ============================================
-- BIGQUERY SQL SCRIPTS
-- Author: edeki101
-- Database: Google BigQuery
-- Project: ee-meedekez6
-- ============================================

-- 1. Monthly Revenue Analysis
WITH monthly_revenue AS (
    SELECT 
        EXTRACT(MONTH FROM sale_date) as month,
        category,
        COUNT(*) as total_orders,
        SUM(amount) as total_revenue,
        AVG(amount) as avg_order_value
    FROM `ee-meedekez6.my_analytics.monthly_sales`
    GROUP BY month, category
),
ranked AS (
    SELECT *,
        RANK() OVER (
            PARTITION BY month 
            ORDER BY total_revenue DESC
        ) as category_rank
    FROM monthly_revenue
)
SELECT 
    month,
    category,
    total_orders,
    total_revenue,
    avg_order_value,
    category_rank,
    CASE
        WHEN total_revenue >= 1000 THEN 'Strong Month'
        WHEN total_revenue >= 500  THEN 'Average Month'
        ELSE 'Weak Month'
    END as performance
FROM ranked
ORDER BY month, category_rank;

-- 2. Customer Analysis
SELECT 
    customer_name,
    city,
    COUNT(*) as total_orders,
    SUM(amount) as total_revenue,
    RANK() OVER (ORDER BY SUM(amount) DESC) as rank
FROM `ee-meedekez6.my_analytics.monthly_sales`
GROUP BY customer_name, city
ORDER BY total_revenue DESC;

-- 3. Date Analysis - Last 30 days
SELECT 
    customer_name,
    product,
    amount,
    sale_date,
    DATE_DIFF(CURRENT_DATE(), sale_date, DAY) as days_ago
FROM `ee-meedekez6.my_analytics.monthly_sales`
WHERE sale_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
ORDER BY sale_date DESC;
