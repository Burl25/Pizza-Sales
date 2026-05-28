CREATE TABLE pizza_sales_raw (
    pizza_id INT,
    order_id INT,
    pizza_name_id VARCHAR(50),
    quantity INT,
    order_date VARCHAR(50),
    order_time VARCHAR(50),
    unit_price DECIMAL(10,2),
    total_price DECIMAL(10,2),
    pizza_size VARCHAR(5),
    pizza_category VARCHAR(50),
    pizza_ingredients VARCHAR(MAX),
    pizza_name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date VARCHAR(50),
    order_time VARCHAR(50)
);

CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT,
    pizza_id INT,
    quantity INT,
    total_price DECIMAL(10,2),

    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE pizzas (
    pizza_id INT PRIMARY KEY,
    pizza_name_id VARCHAR(50),
    pizza_size VARCHAR(5),
    unit_price DECIMAL(10,2)
);

CREATE TABLE pizza_types (
    pizza_name_id VARCHAR(50) PRIMARY KEY,
    pizza_name VARCHAR(100),
    pizza_category VARCHAR(50),
    pizza_ingredients VARCHAR(255)
);

-- truncate the table first
TRUNCATE TABLE dbo.pizza_sales_raw;
GO
 
-- import the file
BULK INSERT dbo.pizza_sales_raw
FROM 'C:\Users\Ioana\Desktop\Pizza Sales\pizza_sales.csv'
WITH
(
        FORMAT='CSV',
        FIRSTROW=2
)
GO

SELECT * FROM pizza_sales_raw;

INSERT INTO pizzas (pizza_id, pizza_name_id, pizza_size, unit_price)
SELECT DISTINCT
       pizza_id,
       pizza_name_id,
       pizza_size,
       unit_price
FROM pizza_sales_raw;

INSERT INTO pizza_types (pizza_name_id, pizza_name, pizza_category, pizza_ingredients)
SELECT DISTINCT
       pizza_name_id,
       pizza_name,
       pizza_category,
       pizza_ingredients
FROM pizza_sales_raw;

INSERT INTO orders (order_id, order_date, order_time)
SELECT DISTINCT
       order_id,
       order_date,
       order_time
FROM pizza_sales_raw;

INSERT INTO order_details (order_id, pizza_id, quantity, total_price)
SELECT
       order_id,
       pizza_id,
       quantity,
       total_price
FROM pizza_sales_raw;

ALTER TABLE orders ADD newcol DATE;

UPDATE orders 
SET newcol = CONVERT(DATETIME,order_date,103);

ALTER TABLE orders DROP COLUMN order_date;
EXEC sp_rename 'dbo.orders.newcol', 'order_date', 'COLUMN';

ALTER TABLE orders
ALTER COLUMN order_time TIME(0);

