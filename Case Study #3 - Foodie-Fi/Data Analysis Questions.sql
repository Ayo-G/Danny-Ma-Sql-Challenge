/* --------------------------------
SQL Enviroment --- Azure Data Studio (MS SQL Server)
-------------------------------- */
/* -----------------------
Data Analysis Questions
----------------------- */

-- How many customers has Foodie-Fi ever had?

SELECT
    COUNT(customer_id) all_customers
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
    ) as sub
GROUP BY
    month_;


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
    COUNT(customer_id) customer_count,
    (
        SELECT
            cast(churned/cast(COUNT(customer_id) as decimal(5,1))*100 as decimal(5,1))
        FROM
            (
                SELECT 
                    count(customer_id) churned
                from 
                    subscriptions
                where 
                    plan_id = 4
            ) c
    ) perc_churned
FROM 
    subscriptions;


-- How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

SELECT
    (
        SELECT 
            CAST(no_sub/CAST(COUNT(customer_id) as DECIMAL(5,1)) * 100 as DECIMAL(1,0))
        FROM
            (
                SELECT
                    COUNT(customer_id) no_sub
                FROM
                    subscriptions
                WHERE 
                    customer_id in     
                    (
                        SELECT 
                            customer_id 
                        FROM 
                            subscriptions 
                        WHERE 
                            plan_id in (0, 4)
                    )
                AND 
                    customer_id not in    
                    (  
                        SELECT 
                            customer_id 
                        FROM 
                            subscriptions 
                        WHERE 
                            plan_id in (1, 2, 3)
                    )
            ) pns
    ) perc_no_sub
FROM 
    subscriptions;

-- What is the number and percentage of customer plans after their initial free trial?




-- What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

-- How many customers have upgraded to an annual plan in 2020?

-- How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

-- Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

-- How many customers downgraded from a pro monthly to a basic monthly plan in 2020?