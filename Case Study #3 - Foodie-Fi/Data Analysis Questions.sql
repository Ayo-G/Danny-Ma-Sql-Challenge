/* --------------------------------
SQL Enviroment --- Azure Data Studio (MS SQL Server)
-------------------------------- */
/* -----------------------
Data Analysis Questions
----------------------- */

-- How many customers has Foodie-Fi ever had?

SELECT
    COUNT(DISTINCT customer_id) all_customers
FROM 
    subscriptions;


-- What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

SELECT 
    month_,
    SUM(distribution) total_distribution
FROM 
    (
        SELECT
            DATENAME(MONTH, start_date) month_,
            COUNT(start_date) distribution
        FROM 
            subscriptions
        WHERE 
            plan_id = 0
        GROUP BY
            start_date 
    ) AS sub
GROUP BY
    month_
ORDER BY
    total_distribution;


-- What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

SELECT 
    plan_name,
    COUNT(start_date) events
FROM 
    subscriptions s
LEFT JOIN
    plans p
ON 
    s.plan_id = p.plan_id
WHERE 
    YEAR(start_date) > 2020
GROUP BY 
    plan_name
ORDER BY
    events;


-- What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
SELECT
    (
        SELECT
            COUNT(DISTINCT customer_id)  
        FROM 
            subscriptions
        WHERE
            plan_id = 4
    ) churned_customers,
    (
        SELECT
            COUNT(DISTINCT customer_id)
        FROM 
            subscriptions
    ) total_customers,
    (
        SELECT
            CAST(churned/CAST(COUNT(DISTINCT customer_id) AS DECIMAL(5,1))*100 AS DECIMAL(5,1))
        FROM
            (
                SELECT 
                    COUNT(customer_id) churned
                FROM 
                    subscriptions
                WHERE 
                    plan_id = 4
            ) c
    ) perc_churned
FROM 
    subscriptions;


-- How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

WITH cte AS 
(
    SELECT
        *,
        RANK() OVER(PARTITION BY customer_id ORDER BY start_date) _rank
    FROM
        subscriptions
)

SELECT 
    COUNT
        (
            CASE WHEN 
                plan_name = 'churn' AND _rank = 2
            THEN 
                1
            END 
        ) AS  no_churned,
        CAST(COUNT(CASE WHEN plan_name = 'churn' AND _rank = 2 THEN 1 END) as NUMERIC)/COUNT(distinct customer_id) * 100 churned_perc
    FROM 
        plans p
    JOIN
        cte c
    ON
        p.plan_id = c.plan_id;
    

-- What is the number and percentage of customer plans after their initial free trial?

WITH cte AS 
(
    SELECT
        *,
        RANK() OVER(PARTITION BY customer_id ORDER BY start_date) _rank
    FROM
        subscriptions
)

SELECT
    p.plan_id,
    plan_name,
    COUNT(p.plan_id) AS no_of_plans,
    CAST(COUNT(p.plan_id) AS NUMERIC)/
    (
        SELECT 
            COUNT(plan_id)
        FROM 
            cte 
        WHERE 
            _rank = 2
    ) * 100
FROM
    plans p
JOIN
    cte c
ON 
    p.plan_id = c.plan_id
GROUP BY
    p.plan_id,
    plan_name
ORDER BY
    p.plan_id;


-- What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

WITH cte AS
(
    SELECT 
        *,
        RANK() OVER(PARTITION BY customer_id ORDER BY start_date) rank_
    FROM 
        subscriptions 
    WHERE
        start_date <= '2020-12-31'
)

SELECT 
    c.plan_id,
    plan_name,
    COUNT(customer_id) AS total_customers,
    CAST(COUNT(c.plan_id) AS NUMERIC)/
    (
        SELECT
            COUNT(customer_id)
        FROM 
            cte 
        WHERE 
            rank_ = 1
    ) * 100 perc_breakdown
FROM 
    cte c 
JOIN
    plans p 
ON 
    c.plan_id = p.plan_id
GROUP BY
    c.plan_id,
    plan_name

-- How many customers have upgraded to an annual plan in 2020?

SELECT
    COUNT(DISTINCT customer_id) upgraded_customers
FROM 
    subscriptions
WHERE
    YEAR(start_date) = 2020
AND
    plan_id = 3;


-- How many days on average does it take for a customer to upgrade to an annual plan FROM the day they join Foodie-Fi?

SELECT 
    AVG(DATEDIFF(DAY, s.start_date, a.start_date)) average_days
FROM 
    subscriptions s
JOIN 
    subscriptions a 
ON 
    s.customer_id = a.customer_id
AND 
    s.plan_id + 3 = a.plan_id
WHERE
    a.plan_id = 3;


-- Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

with cte as
(
    SELECT 
        DATEDIFF(DAY, s.start_date, a.start_date) duration,
        case 
            when DATEDIFF(DAY, s.start_date, a.start_date) >= 0 and DATEDIFF(DAY, s.start_date, a.start_date) < 31
            then '0-30 days'
            when DATEDIFF(DAY, s.start_date, a.start_date) >= 31 and DATEDIFF(DAY, s.start_date, a.start_date) < 61
            then '31-60 days'
            when DATEDIFF(DAY, s.start_date, a.start_date) >= 61 and DATEDIFF(DAY, s.start_date, a.start_date) < 91
            then '61-90 days'
            when DATEDIFF(DAY, s.start_date, a.start_date) >= 91 and DATEDIFF(DAY, s.start_date, a.start_date) < 121
            then '91-120 days'
            when DATEDIFF(DAY, s.start_date, a.start_date) >= 121 and DATEDIFF(DAY, s.start_date, a.start_date) < 151
            then '121-150 days'
            when DATEDIFF(DAY, s.start_date, a.start_date) >= 151 and DATEDIFF(DAY, s.start_date, a.start_date) < 181
            then '151-180 days'
            when DATEDIFF(DAY, s.start_date, a.start_date) >= 181 and DATEDIFF(DAY, s.start_date, a.start_date) < 210
            then '181-210 days'
            when DATEDIFF(DAY, s.start_date, a.start_date) >= 211 and DATEDIFF(DAY, s.start_date, a.start_date) < 241
            then '211-240 days'
            when DATEDIFF(DAY, s.start_date, a.start_date) >= 241 and DATEDIFF(DAY, s.start_date, a.start_date) < 271
            then '241-270 days'
            when DATEDIFF(DAY, s.start_date, a.start_date) >= 271 and DATEDIFF(DAY, s.start_date, a.start_date) < 300
            then '271-300 days'
            when DATEDIFF(DAY, s.start_date, a.start_date) >= 301 and DATEDIFF(DAY, s.start_date, a.start_date) < 331
            then '301-330 days'
            when DATEDIFF(DAY, s.start_date, a.start_date) >= 331 and DATEDIFF(DAY, s.start_date, a.start_date) < 361
            then '331-360 days'
            else 'unallocated'
        end as breakdown
    FROM 
        subscriptions s
    JOIN 
        subscriptions a 
    ON 
        s.customer_id = a.customer_id
    AND 
        s.plan_id + 3 = a.plan_id
    WHERE
        a.plan_id = 3
)

SELECT
    breakdown,
    AVG(duration) avg_days,
    COUNT(breakdown) customers
FROM 
    cte
GROUP BY
    breakdown
ORDER BY 
    breakdown;


-- How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

SELECT 
    COUNT(p.customer_id) downgraded_customers
FROM 
    subscriptions b 
JOIN 
    subscriptions p
ON 
    b.customer_id = p.customer_id 
AND 
    p.plan_id - 1 = b.plan_id 
WHERE
    p.plan_id = 1
AND 
    YEAR(p.start_date) = 2020
AND 
    DATEDIFF(DAY, p.start_date, b.start_date) > 0;