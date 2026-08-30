CREATE TABLE pizza_sales (
    pizza_id INT,
    order_id INT,
    pizza_name_id VARCHAR(50),
    quantity INT,
    order_date VARCHAR(20),
    order_time TIME,
    unit_price DECIMAL(10,2),
    total_price DECIMAL(10,2),
    pizza_size VARCHAR(10),
    pizza_category VARCHAR(50),
    pizza_ingredients TEXT,
    pizza_name VARCHAR(150)
);
select * from pizza_sales
--Total_Revenue
select Sum(total_price) As Total_Revenue from pizza_sales

--Average order_value
select Sum(total_price)/COUNT(DISTINCT order_id) as Avg_order_value from pizza_sales

--Total pizza solds
SELECT SUM(quantity) As Total_Pizza_Sold from pizza_sales

--Total Orders placed
SELECT COUNT(DISTINCT order_id) AS total_order from pizza_sales
--Average pizza per Order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2))/CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2)) As Avg_pizza_per_order from pizza_sales

CHARTS REQUIREMENTS:
--DAILY TREND FOR TOTAL ORDERS
SELECT 
    TO_CHAR(TO_DATE(order_date, 'DD-MM-YYYY'), 'Day') AS order_day,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY TO_CHAR(TO_DATE(order_date, 'DD-MM-YYYY'), 'Day');

----Monthly TREND FOR TOTAL ORDERS

SELECT 
    TO_CHAR(TO_DATE(order_date, 'DD-MM-YYYY'), 'Month') AS Month_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY TO_CHAR(TO_DATE(order_date, 'DD-MM-YYYY'), 'Month')
ORDER BY total_orders DESC;

--PERCENTAGE OF SALES BY PIZZA CATEGORY
SELECT 
    pizza_category,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_sales,
    CAST(
        SUM(total_price) * 100.0 /
        (
            SELECT SUM(total_price)
            FROM pizza_sales
            WHERE EXTRACT(
                MONTH FROM TO_DATE(order_date, 'DD-MM-YYYY')
            ) = 1
        )
        AS DECIMAL(10,2)
    ) AS pct
FROM pizza_sales
WHERE EXTRACT(
    MONTH FROM TO_DATE(order_date, 'DD-MM-YYYY')
) = 1
GROUP BY pizza_category
ORDER BY pct DESC;

--percentage of sales by pizza size
-- Percentage of sales by pizza size
SELECT 
    pizza_size,
	CAST(sum(total_price) As Decimal(10,2)),
    CAST(
        SUM(total_price) * 100.0 /
        (
            SELECT SUM(total_price)
            FROM pizza_sales
            WHERE EXTRACT(
                QUARTER FROM TO_DATE(order_date, 'DD-MM-YYYY')
            ) = 1
        )
        AS DECIMAL(10,2)
    ) AS pct
FROM pizza_sales
WHERE EXTRACT(
    QUARTER FROM TO_DATE(order_date, 'DD-MM-YYYY')
) = 1
GROUP BY pizza_size
ORDER BY pct DESC;

--top 5best seller by revenue
SELECT   pizza_name,SUM(total_price) as total_revenue
from pizza_sales
group by pizza_name 
order by total_revenue desc
LIMIT 5;

--BOTTOM 5best seller by revenue
SELECT   pizza_name,SUM(total_price) as total_revenue
from pizza_sales
group by pizza_name 
order by total_revenue ASC
LIMIT 5;

--top 5best seller by total_quantity
SELECT   pizza_name,SUM(quantity) as total_quantity
from pizza_sales
group by pizza_name 
order by total_quantity DESC
LIMIT 5;

--Bottom 5best seller by total_quantity
SELECT   pizza_name,SUM(quantity) as total_quantity
from pizza_sales
group by pizza_name 
order by total_quantity ASC
LIMIT 5;

--top 5best seller by total orders
SELECT   pizza_name,COUNT(DISTINCT order_id) as total_order
from pizza_sales
group by pizza_name 
order by total_order DESC
LIMIT 5;

--Bottom 5best seller by total orders
SELECT   pizza_name,COUNT(DISTINCT order_id) as total_order
from pizza_sales
group by pizza_name 
order by total_order ASC
LIMIT 5;