-- ============================================
-- Superstore Sales Analysis: Basic SQL Queries
-- Database: SQLite (data/superstore.db)
-- Tables: sales, customers
-- ============================================

-- Query 1: Overall KPIs
SELECT
    ROUND(SUM(sales), 2)                     AS total_sales,
    ROUND(SUM(profit), 2)                    AS total_profit,
    COUNT(DISTINCT order_id)                 AS total_orders,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM sales;

-- Query 2: Ten biggest losses among rows with discount of 50% or more
SELECT order_id, order_date, product_name, sales, discount, profit
FROM sales
WHERE profit < 0 AND discount >= 0.5
ORDER BY profit
LIMIT 10;

-- Query 3: Sales, profit, and margin by category
SELECT
    category,
    COUNT(*)                                 AS rows_count,
    ROUND(SUM(sales), 2)                     AS total_sales,
    ROUND(SUM(profit), 2)                    AS total_profit,
    ROUND(AVG(discount), 3)                  AS avg_discount,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margin_pct
FROM sales
GROUP BY category
ORDER BY total_sales DESC;

-- Query 4: Regional profitability
SELECT
    region,
    ROUND(SUM(sales), 2)                     AS total_sales,
    ROUND(SUM(profit), 2)                    AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margin_pct,
    COUNT(DISTINCT order_id)                 AS orders
FROM sales
GROUP BY region
ORDER BY total_profit DESC;

-- Query 5: Sub-categories that lose money
SELECT
    sub_category,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit;

-- Query 6: Yearly sales and profit
SELECT
    strftime('%Y', order_date)               AS year,
    ROUND(SUM(sales), 2)                     AS total_sales,
    ROUND(SUM(profit), 2)                    AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margin_pct
FROM sales
GROUP BY year
ORDER BY year;

-- Query 7: Monthly sales
SELECT
    strftime('%Y-%m', order_date) AS year_month,
    ROUND(SUM(sales), 2)          AS total_sales
FROM sales
GROUP BY year_month
ORDER BY year_month;

-- Query 8: Top 10 products by sales
SELECT
    product_name,
    ROUND(SUM(sales), 2)  AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    SUM(quantity)         AS units_sold
FROM sales
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- Query 9: Top 10 customers by profit (JOIN sales with customers)
SELECT
    c.customer_name,
    c.segment,
    COUNT(DISTINCT s.order_id) AS orders,
    ROUND(SUM(s.sales), 2)     AS total_sales,
    ROUND(SUM(s.profit), 2)    AS total_profit
FROM sales AS s
INNER JOIN customers AS c
    ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.segment
ORDER BY total_profit DESC
LIMIT 10;

-- Query 10: Profit by customer segment (JOIN)
SELECT
    c.segment,
    ROUND(SUM(s.sales), 2)                     AS total_sales,
    ROUND(SUM(s.profit), 2)                    AS total_profit,
    ROUND(SUM(s.profit) / SUM(s.sales) * 100, 2) AS margin_pct
FROM sales AS s
INNER JOIN customers AS c ON s.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY total_profit DESC;