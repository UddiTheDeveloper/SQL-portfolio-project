-- All the data analysis questions and corressponding querries are given below
-- Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS Total_orders
FROM
    orders;
-- Ans:- 21350

-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS Total_Revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;
-- Ans:- 817860.05

-- Identify the highest-priced pizza.
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY price DESC
LIMIT 1;
-- Ans:- Greek Pizza

-- Identify the most common pizza size ordered.
SELECT 
    pizzas.size, COUNT(order_details.order_id) AS total_orders
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY total_orders DESC
LIMIT 1;
-- Ans:- Large

-- List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizzas.pizza_type_id as Pizza_Type,
    COUNT(order_details.order_id) AS Total_Orders
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.pizza_type_id
ORDER BY Total_Orders DESC
LIMIT 5;

-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time) AS Hours, COUNT(order_id) AS Total_Orders
FROM
    orders
GROUP BY Hours
ORDER BY Total_Orders DESC;
-- Most Profitable hour 12 noon

-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT  category as Category, count(name) as Pizza_Count FROM pizza_types
group by Category
order by Pizza_Count desc;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(Total_Pizzas_Ordered), 0) AS Avg_Pizza_Orders
FROM
    (SELECT 
        orders.order_date AS Order_Date,
            SUM(order_details.quantity) AS Total_Pizzas_Ordered
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY Order_Date) AS order_quantity;
    
-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_types.pizza_type_id AS Pizza_Type,
    SUM(order_details.quantity * pizzas.price) AS Revenue_Per_Type
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY Pizza_Type
ORDER BY Revenue_Per_Type DESC
LIMIT 3;

-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pt.pizza_type_id AS Pizza_Type,
    round((SUM(od.quantity * p.price) / (SELECT 
            SUM(od2.quantity * p2.price)
        FROM
            order_details AS od2
                JOIN
            pizzas AS p2 ON od2.pizza_id = p2.pizza_id)) * 100,2) AS Contribution_Per_Type
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY Pizza_Type
ORDER BY Contribution_Per_Type DESC;

-- Analyze the cumulative revenue generated over Month.
select Month, round(sum(Revenue) over(order by Month),2) as Cumulative_Revenue from 
(select month(orders.order_date) as Month, round(sum(order_details.quantity*pizzas.price),2) as Revenue
from orders join order_details on orders.order_id=order_details.order_id join
pizzas on pizzas.pizza_id=order_details.pizza_id
group by Month
order by Month asc) as Monthly_Revenue;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
with Pizza_Table as
(select pizza_types.category as Category,pizza_types.pizza_type_id as Pizza_Type, sum(order_details.quantity*pizzas.price) as Revenue
from pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id join
order_details on pizzas.pizza_id=order_details.pizza_id
group by pizza_types.category, pizza_types.pizza_type_id),
Ranked_Pizza as
(select
        Category, 
        Pizza_Type, 
        ROUND(Revenue, 2) AS Revenue,
        RANK() OVER (PARTITION BY Category ORDER BY Revenue DESC) AS rn
    FROM Pizza_Table)
SELECT 
	Category,
    Pizza_Type, 
    Revenue
FROM Ranked_Pizza
WHERE rn <= 3
ORDER BY Category, rn;











         



