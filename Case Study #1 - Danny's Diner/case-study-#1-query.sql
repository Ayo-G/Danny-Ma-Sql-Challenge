/* --------------------------
Solved using SQL SERVER
-------------------------- */
-- Q1
-- What is the total amount each customer spent at the restaurant?

select
  customer_id,
  sum(price) amount_spent
from
  sales s
left join
  menu m
on
  s.product_id = m.product_id
group by
  customer_id;


-- Q2
-- How many days has each customer visited the restaurant?

select
  customer_id,
  count(distinct order_date) days_visited
from
  sales
group by
  customer_id;


-- Q3
-- What was the first item from the menu purchased by each customer?

with cte as
(
  select
    product_name,
    s.product_id,
    customer_id,
    order_date
  from
    sales s
  left join
    menu m
  on
    s.product_id = m.product_id
),

cte2 as
(
  select
    customer_id,
    product_name,
    rank() over(partition by customer_id order by order_date) as rank_
  from 
    cte
)

select
  customer_id,
  product_name
from 
  cte2
where
  rank_ = 1
group by
  customer_id,
  product_name
order by
  customer_id;


-- Q4
-- What is the most purchased item on the menu and how many times was it purchased by all customers?

with items as
(
  select
    product_name,
    count(s.product_id) times_bought,
    dense_rank() over(order by count(s.product_id) desc) as rank_
  from
    sales s
  left join
    menu m 
  on
    s.product_id = m.product_id
  group by
    product_name
)
select
  product_name,
  times_bought
from
  items
where
  rank_ = 1;


-- Q5
-- Which item was the most popular for each customer?

WITH items_sales AS
(
  SELECT
    customer_id,
    product_name,
    COUNT(s.product_id) times_bought,
    RANK() OVER(PARTITION BY customer_id ORDER BY COUNT(s.product_id) DESC) rank_
  FROM
    sales s
  LEFT JOIN
    menu m 
  ON
    s.product_id = m.product_id
  GROUP BY
    customer_id,
    product_name
)

SELECT
  customer_id,
  product_name as popular_item
FROM
  items_sales
WHERE
  rank_ = 1
ORDER BY
  customer_id;



-- Q6
-- Which item was purchased first by the customer after they became a member?

WITH cte AS
  (
    SELECT
      b.customer_id,
      m.product_name,
      ROW_NUMBER() OVER(PARTITION BY b.customer_id ORDER BY DATEDIFF(DAY, order_date, join_date)) AS purchase_no
    FROM
      menu m
    LEFT JOIN
      sales s
    ON
      m.product_id = s.product_id
    RIGHT JOIN
      members b
    ON
      b.customer_id = s.customer_id
    AND
      b.join_date >= s.order_date
  )


SELECT
  customer_id,
  product_name
FROM
  cte
WHERE
 purchase_no = 1;


-- Q7
-- Which item was purchased just before the customer became a member?

WITH cte AS
  (
    SELECT
      b.customer_id,
      m.product_name,
      DATEDIFF(DAY, order_date, join_date) ad,
      ROW_NUMBER() OVER(PARTITION BY b.customer_id ORDER BY DATEDIFF(DAY, order_date, join_date) DESC) AS purchase_pos
    FROM
      menu m
    LEFT JOIN
      sales s
    ON
      m.product_id = s.product_id
    RIGHT JOIN
      members b
    ON
      b.customer_id = s.customer_id
    AND
      b.join_date < s.order_date
  )

SELECT
  customer_id,
  product_name
FROM
  cte
WHERE
  purchase_pos = 1;


-- Q8
-- What is the total items and amount spent for each member before they became a member?

WITH cte AS
(
  SELECT
    b.customer_id,
    s.product_id,
    m.price
  FROM
    menu m
  LEFT JOIN
    sales s
  ON
    m.product_id = s.product_id
  RIGHT JOIN
    members b
  ON
    b.customer_id = s.customer_id
  AND
    b.join_date < s.order_date
)

SELECT
  customer_id,
  COUNT(product_id) item_count,
  SUM(price) total_spent
FROM
  cte
GROUP BY
  customer_id;


-- Q9
-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

WITH points_cte AS
(
  SELECT
    product_id,
    CASE 
      WHEN product_name = 'sushi' THEN 20 * price
      ELSE 10 * price
    END AS points
  FROM
    menu 
)

SELECT
  customer_id,
  SUM(points) as total_points
FROM
  sales s
LEFT JOIN
  points_cte c
ON
  s.product_id = c.product_id
GROUP BY
  customer_id;


-- Q10
-- In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

WITH cte AS
(
  SELECT
    b.customer_id,
    s.product_id,
    order_date,
    DATEDIFF(DAY, join_date, order_date) AS m_duration,
    price
  FROM
    menu m
  LEFT JOIN
    sales s
  ON
    m.product_id = s.product_id
  RIGHT JOIN
    members b
  ON
    b.customer_id = s.customer_id
  AND
    b.join_date < s.order_date
),

cte2 AS 
(
  SELECT
    customer_id,
	  CASE 
      WHEN m_duration <= 7 THEN price * 20
      ELSE price * 10
    END AS points 
  FROM 
    cte
  WHERE 
    DATEPART(MONTH, order_date) = 1
)

SELECT
  customer_id,
  SUM(points) as january_points
FROM
  cte2
GROUP BY
  customer_id