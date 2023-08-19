# 👚 Case Study #7 - Balanced Tree Clothing Co.

## Table of Contents
- [Datasets]()
  - [Entity Relationship Diagram]()
- [Case Study Questions]()

---------------------------------

## Datasets
For this case study there is a total of 4 datasets:
- product_details
- product_sales
- product_heirarchy
- product_prices

The balanced tree clothing database schema can be found [here]() <br>
You can inspect the entity relationship diagram below
  ### Entity Relationship Diagram (ERD)
  
![image]()
 
---------------------------------

## Case Study Questions
The case study questions have been broken into different areas of focus including:

- High Level Sales Analysis
- Transaction Analysis
- Product Analysis
- Reporting Challenge
- Bonus Challenge 

#### High Level Sales Analysis
- What was the total quantity sold for all products?
- What is the total generated revenue for all products before discounts?
- What was the total discount amount for all products?

#### Transaction Analysis
- How many unique transactions were there?
- What is the average unique products purchased in each transaction?
- What are the 25th, 50th and 75th percentile values for the revenue per transaction?
- What is the average discount value per transaction?
- What is the percentage split of all transactions for members vs non-members?
- What is the average revenue for member transactions and non-member transactions?

#### Product Analysis
- What are the top 3 products by total revenue before discount?
- What is the total quantity, revenue and discount for each segment?
- What is the top selling product for each segment?
- What is the total quantity, revenue and discount for each category?
- What is the top selling product for each category?
- What is the percentage split of revenue by product for each segment?
- What is the percentage split of revenue by segment for each category?
- What is the percentage split of total revenue by category?
- What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)
- What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?

#### Reporting Challenge
Write a single SQL script that combines all of the previous questions into a scheduled report that the Balanced Tree team can run at the beginning of each month to calculate the previous month’s values.

Imagine that the Chief Financial Officer (which is also Danny) has asked for all of these questions at the end of every month.

He first wants you to generate the data for January only - but then he also wants you to demonstrate that you can easily run the samne analysis for February without many changes (if at all).

Feel free to split up your final outputs into as many tables as you need - but be sure to explicitly reference which table outputs relate to which question for full marks :)

#### Bonus Challenge
Use a single SQL query to transform the product_hierarchy and product_prices datasets to the product_details table.