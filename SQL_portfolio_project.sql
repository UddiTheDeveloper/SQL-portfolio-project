-- Q1. Highest profit per segment, region-wise
SELECT region, segment, total_profit
FROM (
    SELECT region,
           segment,
           ROUND(SUM(profit), 2) AS total_profit,
           RANK() OVER (PARTITION BY region ORDER BY SUM(profit) DESC) AS rnk
    FROM   superstore.orders
    GROUP  BY region, segment
) t
WHERE rnk = 1
ORDER BY region;
-- Q2. City with the highest profit in each state (with profit value)
SELECT state, city, total_profit
FROM (
    SELECT state,
           city,
           ROUND(SUM(profit), 2) AS total_profit,
           RANK() OVER (PARTITION BY state ORDER BY SUM(profit) DESC) AS rnk
    FROM   superstore.orders
    GROUP  BY state, city
) t
WHERE rnk = 1
ORDER BY state;
-- Q3. Category with the highest profit in each segment (with profit value)
SELECT segment, category, total_profit
FROM (
    SELECT segment,
           category,
           ROUND(SUM(profit), 2) AS total_profit,
           RANK() OVER (PARTITION BY segment ORDER BY SUM(profit) DESC) AS rnk
    FROM   superstore.orders
    GROUP  BY segment, category
) t
WHERE rnk = 1
ORDER BY segment;
-- Q4. Segment with the highest profit in each state (with profit value)
SELECT state, segment, total_profit
FROM (
    SELECT state,
           segment,
           ROUND(SUM(profit), 2) AS total_profit,
           RANK() OVER (PARTITION BY state ORDER BY SUM(profit) DESC) AS rnk
    FROM   superstore.orders
    GROUP  BY state, segment
) t
WHERE rnk = 1
ORDER BY state;
-- Q5. Ship mode with the highest profit in each category (with profit value)
SELECT category, ship_mode, total_profit
FROM (
    SELECT category,
           ship_mode,
           ROUND(SUM(profit), 2) AS total_profit,
           RANK() OVER (PARTITION BY category ORDER BY SUM(profit) DESC) AS rnk
    FROM   superstore.orders
    GROUP  BY category, ship_mode
) t
WHERE rnk = 1
ORDER BY category;
-- Q6. Top 3 persons by average profit, with their total number of customers
SELECT person,
       ROUND(AVG(profit), 2)        AS avg_profit,
       COUNT(DISTINCT customer_id)  AS total_customers
FROM   superstore.orders 
JOIN   superstore.people 
       ON orders.region = people.region
GROUP  BY person
ORDER  BY avg_profit DESC
LIMIT  3;













