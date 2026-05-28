USE [Pizza Project]
GO

/* Function that shows total revenue of an order
CREATE OR ALTER FUNCTION total_revenue_order (@f_id INT)
RETURNS DECIMAL(10,2)
BEGIN
RETURN (SELECT SUM(total_price)
FROM order_details
WHERE order_id = @f_id)
END;*/

-- Total revenue for all orders
SELECT order_id, dbo.total_revenue_order(order_id) AS 'Total Revenue'
FROM orders;

-- Total revenue for order 156
SELECT order_id, dbo.total_revenue_order(order_id) AS 'Total Revenue'
FROM orders
WHERE order_id = 156;

/*Function that shows total revenue by date
CREATE OR ALTER FUNCTION total_revenue_by_date(@f_date DATE)
RETURNS DECIMAL(10,2)
BEGIN
RETURN (SELECT SUM(total_price)
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
WHERE o.order_date = @f_date)
END;*/

-- Total revenue for 25th of May 2025
SELECT DISTINCT order_date, dbo.total_revenue_by_date(order_date)
FROM orders
WHERE order_date = '2025-05-25'

-- Function that shows total number of pizzas based on sizes
/*CREATE OR ALTER FUNCTION total_pizzas_by_size (@size VARCHAR(3))
RETURNS INT
BEGIN 
RETURN (SELECT SUM(od.quantity)
FROM order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
WHERE p.pizza_size = @size)
END;*/

-- Total number of S pizzas
SELECT DISTINCT pizza_size, dbo.total_pizzas_by_size(pizza_size) AS 'Total number of pizzas'
FROM pizzas
WHERE pizza_size = 'S';

-- Function for a possible discount (can be used on special events)
-- Order 3 pizzas you get a discount of 10% of the entire order
-- Order 5 pizzas you get a discount of 15% of the entire order
-- Order 8 pizzas or more and get a discount of 20% of the entire order

/*CREATE OR ALTER FUNCTION possible_discount (@id INT)
RETURNS DECIMAL(10,2)
BEGIN
DECLARE @total_quantity INT;
DECLARE @total_price_order DECIMAL(10,2);
DECLARE @discount DECIMAL(5,2) = 0;

SELECT @total_quantity = SUM(quantity)
FROM order_details
WHERE order_id = @id;

SELECT @total_price_order = SUM(total_price)
FROM order_details
WHERE order_id = @id;

IF @total_quantity >= 8 SET @discount = 0.20;
ELSE IF @total_quantity >= 5 SET @discount = 0.15;
ELSE IF @total_quantity > 3 SET @discount = 0.10;

RETURN @total_price_order * (1 - @discount);
END;*/

-- Prices after possible discounts for all orders
SELECT order_id, SUM(quantity) AS 'Total quantity', SUM(total_price) AS 'Total price', 
dbo.possible_discount(order_id) AS 'Price after discount' 
FROM order_details 
GROUP BY order_id 
ORDER BY order_id;

-- Prices for International Women's Day discount
SELECT od.order_id, SUM(od.quantity) AS 'Total quantity', SUM(od.total_price) AS 'Total price', 
dbo.possible_discount(od.order_id) AS 'Price after discount' 
FROM order_details od
JOIN orders o ON o.order_id = od.order_id
WHERE o.order_date = '2025-03-08'
GROUP BY od.order_id 
ORDER BY od.order_id;

-- Procedure that shows a daily sales report based on the period of time selected
/*CREATE OR ALTER PROCEDURE daily_sales_report (@date DATE, @hour1 INT, @hour2 INT)
AS
DECLARE @time_period VARCHAR(25)
IF @hour2 = 24 SET @time_period = CONCAT('From ',@hour1,':00 to ','00:00');
ELSE SET @time_period = CONCAT('From ',@hour1,':00 to ',@hour2,':00');

IF NOT EXISTS (SELECT 1 FROM orders 
WHERE order_date = @date)
THROW 50001, 'The date was not found', 1;

IF (@hour1 < 9 OR @hour1 > 24 OR @hour2 < 9 OR @hour2 > 24)
THROW 50002, 'The restaurant takes orders from 9:00 - 00:00', 1;

IF (@hour1 = @hour2 OR @hour2 < @hour1)
THROW 50003, 'Time period introduced incorrectly', 1;

BEGIN
IF EXISTS (SELECT 1 FROM order_details od
JOIN orders o ON o.order_id = od.order_id
WHERE o.order_date = @date AND DATEPART(HOUR, o.order_time) BETWEEN @hour1 AND (@hour2 - 1))

BEGIN
SELECT o.order_date, SUM(quantity) AS 'Number of pizzas ordered', SUM(total_price) AS 'Total revenue of the day',
@time_period AS 'Time period'
FROM order_details od
JOIN orders o ON o.order_id = od.order_id
WHERE o.order_date = @date AND DATEPART(HOUR,o.order_time) BETWEEN @hour1 AND (@hour2-1)
GROUP BY o.order_date
END

ELSE
BEGIN
SELECT @date AS order_date, 0 AS 'Number of pizzas ordered', 0 AS 'Total revenue of the day', @time_period AS 'Time period';
END

END;*/

-- Sales report for 4th of April 2025
EXEC dbo.daily_sales_report @date = '2025-04-04', @hour1 = 9, @hour2 = 24;

-- Sales report for 23th of October 2025 between 23:00 - 00:00
EXEC dbo.daily_sales_report @date = '2025-10-23', @hour1 = 23, @hour2 = 24;

-- Sales report for 14th of July 2025 between 9:00 - 10:00
EXEC dbo.daily_sales_report @date = '2025-07-14', @hour1 = 9, @hour2 = 10;

-- Procedure that shows monthly sales report by category - (Veggie, Chicken, Classic, Supreme)
/*CREATE OR ALTER PROCEDURE sales_report_by_category (@n INT, @category VARCHAR(20))
AS

IF (@n < 1 OR @n > 12)
THROW 5005, 'Not a valid month', 1;

IF NOT EXISTS (SELECT 1 FROM pizza_types 
WHERE pizza_category = @category)
THROW 50006, 'The category was not found', 1;

BEGIN
SELECT DATENAME (MONTH, DATEFROMPARTS(2025, @n, 1)) AS 'Month', pt.pizza_category AS 'Pizza category', 
SUM(od.quantity) AS 'Quantity ordered', SUM(od.total_price) AS 'Total revenue'
FROM pizza_types pt
JOIN pizzas p ON p.pizza_name_id = pt.pizza_name_id
JOIN order_details od ON od.pizza_id = p.pizza_id
JOIN orders o ON o.order_id = od. order_id
WHERE pt.pizza_category = @category AND DATEPART(MONTH,o.order_date) = @n
GROUP BY pt.pizza_category
END;*/

-- March sales report for Veggie category
EXEC dbo.sales_report_by_category @n = 3, @category = 'Veggie'

-- April sales report for Veggie category
EXEC dbo.sales_report_by_category @n = 4, @category = 'Veggie'

-- October sales report for Classic category
EXEC dbo.sales_report_by_category @n = 10, @category = 'Classic'

-- Procedure that shows top N pizzas based on total revenue from a given date
/*CREATE OR ALTER PROCEDURE top_pizzas (@n INT, @date DATE)
AS

IF NOT EXISTS (SELECT 1 FROM orders 
WHERE order_date = @date)
THROW 50004, 'The date was not found', 1;

BEGIN
SELECT TOP(@n) pt.pizza_name, SUM(od.total_price) AS 'Total revenue'
FROM pizza_types pt
JOIN pizzas p ON p.pizza_name_id = pt.pizza_name_id
JOIN order_details od ON od.pizza_id = p.pizza_id
JOIN orders o ON o.order_id = od. order_id
WHERE o.order_date = @date
GROUP BY pt.pizza_name
ORDER BY SUM(od.total_price) DESC
END;*/

-- Top 5 pizzas sold on 25th of May 2025
EXEC dbo.top_pizzas @date = '2025-05-25', @n = 5;

-- Top 10 pizzas sold on Valentine's Day 2025
EXEC dbo.top_pizzas @date = '2025-02-14', @n = 10;

-- Procedure that shows worst-selling pizzas based on quantity in a given month 
/*CREATE OR ALTER PROCEDURE worst_pizzas (@n INT, @month INT)
AS

IF NOT EXISTS (SELECT 1 FROM orders 
WHERE DATEPART(MONTH,order_date) = @month)
THROW 50004, 'The date was not found', 1;

BEGIN
SELECT TOP(@n) pt.pizza_name, SUM(od.quantity) AS 'Total quantity'
FROM pizza_types pt
JOIN pizzas p ON p.pizza_name_id = pt.pizza_name_id
JOIN order_details od ON od.pizza_id = p.pizza_id
JOIN orders o ON o.order_id = od. order_id
WHERE DATEPART(MONTH,o.order_date) = @month
GROUP BY pt.pizza_name
ORDER BY SUM(od.quantity)
END;*/

-- Top 3 least sold pizzas in October
EXEC dbo.worst_pizzas @month = 10, @n = 3;
