/* --------------------------------
SQL Enviroment --- Azure Data Studio (MS SQL Server)
-------------------------------- */
/* --------------
Customer Journey
-------------- */


/*
Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!
*/

-- CUSTOMER 1

SELECT
    customer_id,
    plan_name,
    start_date
FROM
    subscriptions s
JOIN
    plans p
ON 
    s.plan_id = p.plan_id
WHERE
    customer_id = 1;

SELECT
    'customer 1 started his/her trial on 1st August, 2020 and subscribed to the basic monthly plan immediately after' as customer_1_description;

-- CUSTOMER 2

SELECT
    customer_id,
    plan_name,
    start_date
FROM
    subscriptions s
JOIN
    plans p
ON 
    s.plan_id = p.plan_id
WHERE
    customer_id = 2;

SELECT
    'customer 2 started his/her trial 20th September, 2020 and subscribed to the pro annual plan immediately after' as customer_2_description;


-- CUSTOMER 11

SELECT
    customer_id,
    plan_name,
    start_date
FROM
    subscriptions s
JOIN
    plans p
ON 
    s.plan_id = p.plan_id
WHERE
    customer_id = 11;

SELECT
    'customer 11 started his/her trial 19th November, 2020 and churned immediately after' as customer_11_description;



-- CUSTOMER 13

SELECT
    customer_id,
    plan_name,
    start_date
FROM
    subscriptions s
JOIN
    plans p
ON 
    s.plan_id = p.plan_id
WHERE
    customer_id = 13;

SELECT
    'customer 13 started his/her trial 15th December, 2020 and subscribed to the basic monthly plan immediately after the trial period. Then upgraded to the pro annual plan after 3 months and a week' as customer_13_description;


-- CUSTOMER 15

SELECT
    customer_id,
    plan_name,
    start_date
FROM
    subscriptions s
JOIN
    plans p
ON 
    s.plan_id = p.plan_id
WHERE
    customer_id = 15;

SELECT
    'customer 15 started his/her trial 17th March, 2020 and subscribed to the pro monthly plan immediately after the trial period. Then churned at the end of the pro monthly plan' as customer_15_description;


-- CUSTOMER 16

SELECT
    customer_id,
    plan_name,
    start_date
FROM
    subscriptions s
JOIN
    plans p
ON 
    s.plan_id = p.plan_id
WHERE
    customer_id = 16;

SELECT
    'customer 16 started his/her trial 17th March, 2020 and subscribed to the pro monthly plan immediately after the trial period. Then churned at the end of the pro monthly plan' as customer_16_description;


-- CUSTOMER 18

SELECT
    customer_id,
    plan_name,
    start_date
FROM
    subscriptions s
JOIN
    plans p
ON 
    s.plan_id = p.plan_id
WHERE
    customer_id = 18;

SELECT
    'customer 18 started his/her trial 6th July, 2020 and subscribed to the pro monthly plan immediately after the trial period' as customer_18_description;


-- CUSTOMER 19
SELECT
    customer_id,
    plan_name,
    start_date
FROM
    subscriptions s
JOIN
    plans p
ON 
    s.plan_id = p.plan_id
WHERE
    customer_id = 19;

SELECT
    'customer 19 started his/her trial 22nd June, 2020 and subscribed to the pro monthly plan immediately after the trial period. Then upgraded to pro annual plan exactly 2 months after' as customer_19_description;
