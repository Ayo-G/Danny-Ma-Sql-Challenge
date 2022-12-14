/* --------------------------
Solved using Google BigQuery
-------------------------- */

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


with cte as
  (
    select
      b.customer_id,
      m.product_name,
      DATE_DIFF(order_date, join_date, day) as post_membership
    from
      d_m.menu m
    left join
      d_m.sales s
    on
      m.product_id = s.product_id
    left join
      d_m.members b
    on
      b.customer_id = s.customer_id
  ),

cte_ranked as
(
  select
    customer_id,
    product_name,
    rank() over(partition by customer_id order by post_membership) as rank_
  from
    cte
  where
    post_membership >= 0
)

select
  customer_id,
  product_name
from
  cte_ranked
where
 rank_ = 1



-- Which item was purchased just before the customer became a member?


with cte as
  (
    select
      b.customer_id,
      m.product_name,
      DATE_DIFF(order_date, join_date, day) as pre_membership
    from
      d_m.menu m
    left join
      d_m.sales s
    on
      m.product_id = s.product_id
    left join
      d_m.members b
    on
      b.customer_id = s.customer_id
  ),

cte_ranked as
(
  select
    customer_id,
    product_name,
    rank() over(partition by customer_id order by pre_membership desc) as rank_
  from
    cte
  where
    pre_membership < 0
)

select
  customer_id,
  product_name
from
  cte_ranked
where
  rank_ = 1



-- What is the total items and amount spent for each member before they became a member?


with cte as
  (
    select
      b.customer_id,
      m.product_id,
      m.price,
      DATE_DIFF(order_date, join_date, day) as pre_membership
    from
      d_m.menu m
    left join
      d_m.sales s
    on
      m.product_id = s.product_id
    left join
      d_m.members b
    on
      b.customer_id = s.customer_id
  )

select
  customer_id,
  count(product_id) item_count,
  sum(price) total_spent
from
  cte
where
  pre_membership < 0
group by
  1



-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

with cte as
(
  select
    product_id,
    case when product_name = 'sushi' then 20 * price
    else 10 * price
    end as points
  from
    d_m.menu 
)

select
  customer_id,
  sum(points) as total_points
from
  d_m.sales s
left join
  cte c
on
  s.product_id = c.product_id
group by
  1



-- In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?


with cte as
(
  select
    s.customer_id,
    s.product_id,
    order_date,
    DATE_DIFF(order_date, join_date, day) as post_purchase,
    price
  from
    d_m.menu m
  left join
    d_m.sales s
  on
    m.product_id = s.product_id
  left join
    d_m.members b
  on
    b.customer_id = s.customer_id
),

cte2 as 
(
  select
    customer_id,
	  case 
      when post_purchase <= 7 and post_purchase >= 0 then price * 20
      else price * 10
    end as points 
  from 
    cte
  where 
    extract(month from order_date) = 1
  and 
    customer_id in ('A', 'B')
)

select
  customer_id,
  sum(points) as total_points
from
  cte2
group by
  1