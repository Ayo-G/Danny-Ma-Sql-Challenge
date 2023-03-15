/* --------------------------------
SQL Enviroment --- Google BigQuery
-------------------------------- */
/* -----------
Pizza Metrics
------------ */

--- How many pizzas were ordered?
SELECT
  count(order_id) as total_order
FROM
  p_r.customer_orders


--- How many unique customer orders were made?
select
  count(distinct order_id) as total_unique_order
from
  p_r.customer_orders


--- How many successful orders were delivered by each runner?
select
  runner_id,
  count(order_id) as successful_orders
from
  p_r.runner_orsers
where
  cancellation is null
group by
  runner_id


--- How many of each type of pizza was delivered?

select
  pizza_name,
  count(c.pizza_id) as pizza_type
from
  p_r.customer_orders c
left join
  p_r.pizza_names p
on
  p.pizza_id = c.pizza_id
group by
  1


--- How many Vegetarian and Meatlovers were ordered by each customer?

select
  customer_id,
  pizza_name,
  count(c.pizza_id) as pizza_type
from
  p_r.customer_orders c
left join
  p_r.pizza_names p
on
  p.pizza_id = c.pizza_id
group by
  1, 2
order by
  1


--- What was the maximum number of pizzas delivered in a single order?



--- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?



--- How many pizzas were delivered that had both exclusions and extras?



--- What was the total volume of pizzas ordered for each hour of the day?



--- What was the volume of orders for each day of the week?
