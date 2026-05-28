USE [Pizza Project];
GO

-- Revenue Summary
SELECT SUM(total_price) AS 'Total revenue', CAST(AVG(total_price) AS decimal(10,2)) AS 'Average revenue', 
MAX(total_price) AS 'Max revenue', MIN(total_price) AS 'Min revenue'
FROM order_details;

-- Every pizza total revenue
SELECT pt.pizza_name AS 'Pizza name', SUM(od.total_price) AS 'Total revenue'
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON pt.pizza_name_id = p.pizza_name_id
GROUP BY pt.pizza_name
ORDER BY SUM(od.total_price) DESC;

-- Sales level for every pizza
SELECT pt.pizza_name AS 'Pizza name',	
CASE WHEN SUM(od.total_price)  < 15000 THEN 'Low sales level'
WHEN SUM(od.total_price)  < 25000 THEN 'Average sales level'
WHEN SUM(od.total_price)  < 35000 THEN 'Good sales level'
ELSE 'Excelent sales level'
END AS 'Sales level'
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON pt.pizza_name_id = p.pizza_name_id
GROUP BY pt.pizza_name;

-- Revenue based on pizza category summary
SELECT pt.pizza_category AS 'Pizza category', SUM(od.total_price) AS 'Total revenue',
CAST(AVG(total_price) AS decimal(10,2)) AS 'Average revenue', 
MAX(total_price) AS 'Max revenue', MIN(total_price) AS 'Min revenue'
FROM order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_name_id = p.pizza_name_id
GROUP BY pt.pizza_category
ORDER BY SUM(od.total_price) DESC;

-- Numbers of orders
SELECT COUNT(DISTINCT order_id) AS 'Total number of orders'
FROM orders;

-- Most popular pizzas to least
SELECT pt.pizza_name AS 'Pizza name',SUM(od.quantity) AS 'Total quantity'
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_name_id = pt.pizza_name_id
GROUP BY pt.pizza_name
ORDER BY SUM(od.quantity) DESC;

-- Number of orders at every hour
SELECT DATEPART(HOUR,order_time) AS 'Hour of the order', COUNT(*) AS 'Total number of orders'
FROM orders
GROUP BY DATEPART(HOUR, order_time)
ORDER BY DATEPART(HOUR,order_time);

-- Number of orders every month
SELECT DATENAME(MONTH,order_date) AS 'Month', COUNT(*) AS 'Total number of orders'
FROM orders
GROUP BY DATENAME(MONTH,order_date), DATEPART(MONTH,order_date)
ORDER BY DATEPART(MONTH,order_date);

-- Total revenue based on month
SELECT DATENAME(MONTH,order_date) AS 'Month', SUM(total_price) AS 'Total revenue'
FROM orders o 
JOIN order_details od ON o.order_id = od.order_id
GROUP BY DATENAME(MONTH,order_date), DATEPART(MONTH,order_date)
ORDER BY DATEPART(MONTH,order_date);

-- Best-selling pizza by month
WITH 
monthly_sales AS 
(SELECT DATENAME(MONTH, CAST(o.order_date AS DATE)) AS month_name, DATEPART(MONTH,order_date) AS month_number, 
pt.pizza_name, SUM(od.quantity) AS total_sold
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_name_id = pt.pizza_name_id
GROUP BY DATENAME(MONTH, CAST(o.order_date AS DATE)), DATEPART(MONTH,order_date),pt.pizza_name),
ranked_sales AS
(SELECT month_name, month_number, pizza_name, total_sold,
RANK() OVER (PARTITION BY month_number ORDER BY total_sold DESC) AS sales_rank
FROM monthly_sales)

SELECT month_name AS 'Month', pizza_name AS 'Pizza name', total_sold AS 'Total sold'
FROM ranked_sales
WHERE sales_rank = 1
ORDER BY month_number;

-- Peak sales days
SELECT order_date AS 'Date', SUM(total_price) AS 'Total revenue'
FROM order_details od
JOIN orders o ON o.order_id = od.order_id
GROUP BY order_date
ORDER BY SUM(total_price) DESC;

-- Best to least profitable sizes
SELECT pizza_size AS 'Size', SUM(total_price) AS 'Total revenue'
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY pizza_size
ORDER BY SUM(total_price) DESC;


