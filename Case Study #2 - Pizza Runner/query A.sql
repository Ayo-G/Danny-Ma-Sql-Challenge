/* --------------------------------
SQL Enviroment --- MS SQL SERVER
-------------------------------- */
/* -----------
Pizza Metrics
------------ */

--- How many pizzAS were ordered?
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


--- How many of each type of pizza wAS delivered?

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


--- How many Vegetarian and Meatlovers were ordered by each customer?

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
    order_id
  FROM
    cte
)

SELECT
  order_id
FROM
  cte2
WHERE
  rank_ = 1;


--- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

with cte as 
(
  select
    customer_id,
    pizza_id,
    case 
      when exclusions is not null then 'changed'
      else 'unchanged'
    end as order_condition
  from 
    customer_orders c
  left join 
    runner_orders r
  on 
    c.order_id = r.order_id
  where
    cancellation is null
)
  
select 
  customer_id,
  order_condition,
  count(pizza_id) as delivered_pizzas
from 
  cte
group by
  customer_id,
  order_condition
order by
  customer_id,
  order_condition;


--- How many pizzas were delivered that had both exclusions and extras?

select 
  count(pizza_id) as pizza_count
from 
  customer_orders
where 
  exclusions is not null 
and 
  extras is not null; 


--- What was the total volume of pizzas ordered for each hour of the day?

with cte as
(
  select 
    DATEPART(hour, order_time) as hour_,
    count(order_id) as volume
  from 
    customer_orders
  group by 
    order_time
)

select 
  hour_,
  sum(volume) as total_volume
from 
  cte
group by
  hour_
order by 
  hour_;


--- What was the volume of orders for each day of the week?

with cte as
(
  select 
    DATEPART(weekday, order_time) as dow,
    count(order_id) as volume
  from 
    customer_orders
  group by 
    order_time
)

select 
  dow,
  sum(volume) as total_volume
from 
  cte
group by
  dow
order by 
  dow;