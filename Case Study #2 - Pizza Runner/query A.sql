/* --------------------------------
SQL Enviroment --- Google BigQuery
-------------------------------- */
/* -----------
Pizza Metrics
------------ */

--- How many pizzAS were ordered?
SELECT
  COUNT(order_id) AS total_order
FROM
  p_r.customer_orders


--- How many unique customer orders were made?
SELECT
  COUNT(distinct order_id) AS total_unique_order
FROM
  p_r.customer_orders


--- How many successful orders were delivered by each runner?
SELECT
  runner_id,
  COUNT(order_id) AS successful_orders
FROM
  p_r.runner_orsers
WHERE
  cancellatiON IS NULL
GROUP BY
  runner_id


--- How many of each type of pizza wAS delivered?

SELECT
  pizza_name,
  COUNT(c.pizza_id) AS pizza_type
FROM
  p_r.customer_orders c
LEFT JOIN
  p_r.pizza_names p
ON
  p.pizza_id = c.pizza_id
GROUP BY
  1


--- How many Vegetarian and Meatlovers were ordered by each customer?

SELECT
  customer_id,
  pizza_name,
  COUNT(c.pizza_id) AS pizza_type
FROM
  p_r.customer_orders c
LEFT JOIN
  p_r.pizza_names p
ON
  p.pizza_id = c.pizza_id
GROUP BY
  1, 2
ORDER BY
  1


--- What wAS the maximum number of pizzAS delivered in a single order?

SELECT

--- For each customer, how many delivered pizzAS had at leASt 1 change and how many had no changes?



--- How many pizzAS were delivered that had both exclusiONs and extrAS?



--- What wAS the total volume of pizzAS ordered for each hour of the day?



--- What wAS the volume of orders for each day of the week?
