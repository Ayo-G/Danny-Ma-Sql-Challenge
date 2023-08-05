/* --------------------------------
SQL Enviroment --- Azure Data Studio (MS SQL Server)
-------------------------------- */
/* ----------------------------
Runner and Customer Experience
---------------------------- */

--- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

select 
    datepart(week, registration_date) as week_period,
    count(runner_id) as runner_count
from 
    runners
group by
    datepart(week, registration_date);


--- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

select
    runner_id,
    avg(datepart(minute, pickup_time)) as avg_time_in_minutes
from 
    runner_orders
group by
    runner_id;


--- Is there any relationship between the number of pizzas and how long the order takes to prepare?

select
    r.order_id,
    count(r.order_id) as order_count,
    datediff(minute, order_time, pickup_time) as prep_time_min
from 
    runner_orders r
left join 
    customer_orders c
on 
    r.order_id = c.order_id
group by
    r.order_id,
    datediff(minute, order_time, pickup_time)
order by
    order_count desc;
/* The result from the query above shows that orders that have a higher number of pizzas take longer to prepare */  

--- What was the average distance travelled for each customer?

select
    customer_id,
    round(avg(distance), 2) as avg_distance
from 
    runner_orders r
left join
    customer_orders c
on 
    r.order_id = c.order_id
group by 
    customer_id;


--- What was the difference between the longest and shortest delivery times for all orders?

select 
    max(duration) as longest_duration,
    min(duration) as shortest_duration
from 
    runner_orders


--- What was the average speed for each runner for each delivery and do you notice any trend for these values?

select
    runner_id,
    round(avg(distance/(duration/60)), 2) as avg_speed
from 
    runner_orders
where order_id in 
    (
        select
            order_id
        from 
            runner_orders
        where 
            cancellation is null
    )
group by
    runner_id;
/* Runner 1 & 3 had close average speeds unlike runner 2 who had a significantly higher average speed. */

--- What is the successful delivery percentage for each runner?
