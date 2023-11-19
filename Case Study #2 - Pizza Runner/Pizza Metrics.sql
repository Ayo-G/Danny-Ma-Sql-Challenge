/* --------------------------------
SQL Enviroment --- Azure Data Studio (MS SQL Server)
-------------------------------- */
/* -----------
Pizza Metrics
------------ */

--- How many pizzas were ordered?
SELECT
  COUNT(order_id) AS total_order
FROM
  customer_orders;


--- How many unique customer orders were made?
SELECT
  COUNT(distinct order_id) AS total_unique_order
FROM
 customer_orders;


--- How many successful orders were delivered by each runner?
SELECT
  runner_id,
  COUNT(order_id) AS successful_orders
FROM
  runner_orders
WHERE
  cancellation IS NULL
GROUP BY 
  runner_id;


--- How many of each type of pizza was delivered?

SELECT
  pizza_name,
  COUNT(c.pizza_id) AS pizza_type
FROM
  customer_orders c
LEFT JOIN
  pizza_names p
ON
  p.pizza_id = c.pizza_id
GROUP BY 
  pizza_name;


--- How many Vegetarian AND Meatlovers were ordered by each customer?

SELECT
  customer_id,
  pizza_name,
  COUNT(c.pizza_id) AS pizza_type
FROM
 customer_orders c
LEFT JOIN
  pizza_names p
ON
  p.pizza_id = c.pizza_id
GROUP BY 
  customer_id,
  pizza_name
ORDER BY 
  1;


--- What was the maximum number of pizzas delivered in a single order?

WITH cte AS
(
  SELECT
    order_id,
    COUNT(pizza_id) as no_of_pizza
  FROM
    customer_orders
  GROUP BY 
    order_id
),

cte2 AS
(
  SELECT
    RANK() OVER(ORDER BY no_of_pizza DESC) as rank_,
    order_id,
    no_of_pizza
  FROM
    cte
)

SELECT
  DISTINCT no_of_pizza
FROM
  cte2
WHERE
  rank_ = 1;


--- For each customer, how many delivered pizzas had at least 1 change AND how many had no changes?

with cte as 
(
  SELECT
    customer_id,
    pizza_id,
    case 
      when exclusions is not null then 'changed'
      else 'unchanged'
    end as order_condition
  FROM 
    customer_orders c
  left join 
    runner_orders r
  on 
    c.order_id = r.order_id
  WHERE
    cancellation is null
)
  
SELECT 
  customer_id,
  order_condition,
  COUNT(pizza_id) as delivered_pizzas

FROM 
  cte
GROUP BY 
  customer_id,
  order_condition
ORDER BY 
  customer_id,
  order_condition;


--- How many pizzas were delivered that had both exclusions AND extras?

SELECT 
  COUNT(pizza_id) as pizza_COUNT
FROM 
  customer_orders
WHERE 
  exclusions is not null 
AND 
  extras is not null; 


--- What was the total volume of pizzas ordered for each hour of the day?

with cte as
(
  SELECT 
    DATEPART(hour, order_time) as hour_,
    COUNT(order_id) as volume
  FROM 
    customer_orders
  GROUP BY  
    order_time
)

SELECT 
  hour_,
  SUM(volume) as total_volume
FROM 
  cte
GROUP BY 
  hour_
ORDER BY 
  hour_;


--- What was the volume of orders for each day of the week?

with cte as
(
  SELECT 
    DATEPART(weekday, order_time) as day_of_week,
    COUNT(order_id) as volume
  FROM 
    customer_orders
  GROUP BY  
    order_time
)

SELECT 
  day_of_week,
  SUM(volume) as total_volume
FROM 
  cte
GROUP BY 
  day_of_week
ORDER BY 
  day_of_week;