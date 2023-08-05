# 🥘 Case Study #3 - Foodie-Fi

## Table of Contents
- [Datasets]()
  - [Entity Relationship Diagram]()
- [Case Study Questions]()

---------------------------------

## Datasets
Danny has shared with you 2 key datasets for this case study but there will be a challenge to create a new table for the Foodie-Fi team:
- plans
- subscriptions
#### New Table
- payments_new

The Foodie-Fi database schema can be found [here](https://github.com/Ayo-G/Danny-Ma-Sql-Challenge/blob/main/Case%20Study%20%233%20-%20Foodie-Fi/datasets/case-study-3-schema.sql) <br>
You can inspect the entity relationship diagram below
  ### Entity Relationship Diagram (ERD)
  
![image](https://user-images.githubusercontent.com/110608447/216818827-c89b09fa-706f-4584-8926-d7b117080507.png)
 
---------------------------------

## Case Study Questions

This case study is split into three sections:
- An initial data understanding question (Customer Journey)
- Data analysis questions 
- 1 single extension challenge (Challenge Payment Question).

### Customer Journey
Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

### Data Analysis Questions
- How many customers has Foodie-Fi ever had?

- What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

- What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

- What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

- How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

- What is the number and percentage of customer plans after their initial free trial?

- What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

- How many customers have upgraded to an annual plan in 2020?

- How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

- Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

- How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

### Challenge Payment Question
The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the subscriptions table with the following requirements:
- monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
- upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
- upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
- once a customer churns they will no longer make payments
