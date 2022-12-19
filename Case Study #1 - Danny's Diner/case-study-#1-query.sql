-- What is the total amount each customer spent at the restaurant?

select
  customer_id,
  sum(price) amount_spent
from
  d_m.sales s
left join
  d_m.menu m
on
  s.product_id = m.product_id
group by
  1


-- How many days has each customer visited the restaurant?

select
  customer_id,
  count(distinct order_date) days_visited
from
  d_m.sales
group by
  1



-- What was the first item from the menu purchased by each customer?

with cte as
(
  select
    product_name,
    s.product_id,
    customer_id,
    order_date
  from
    d_m.sales s
  left join
    d_m.menu m
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
  order by
    customer_id,
    rank_
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
  1



-- What is the most purchased item on the menu and how many times was it purchased by all customers?

with items as
(
  select
    product_name,
    count(s.product_id) times_bought,
    dense_rank() over(order by count(s.product_id) desc) as rank_
  from
    d_m.sales s
  left join
    d_m.menu m 
  on
    s.product_id = m.product_id
  group by
    1
)

select
  product_name,
  times_bought
from
  items
where
  rank_ =1


-- Which item was the most popular for each customer?

with items_sales as
(
  select
    customer_id,
    product_name,
    count(s.product_id) times_bought
  from
    d_m.sales s
  left join
    d_m.menu m 
  on
    s.product_id = m.product_id
  group by
    1, 2
),

ranked_sales as
(
  select
    customer_id,
    product_name,
    rank() over(partition by customer_id order by times_bought desc) rank_
  from
    items_sales
)

select
  customer_id,
  product_name
from
  ranked_sales
where
  rank_ = 1
order by
  1


-- Which item was purchased first by the customer after they became a member?





-- Which item was purchased just before the customer became a member?





-- What is the total items and amount spent for each member before they became a member?





-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?





-- In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?