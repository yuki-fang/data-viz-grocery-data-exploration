# Online Grocer Transaction Analysis

This project explores a sample of transaction data from an online grocer using **SQL** and **R**. The goal is to perform exploratory data analysis (EDA) to generate insights into customer behavior, product performance, and sales trends.

## Project Motivation
Understanding transaction patterns helps identify high-performing products, top customers, and emerging trends to inform marketing, inventory, and business strategy.

## Data Overview
| Dataset | Description |
|---------|-------------|
| `order_header_sample.csv` | Order-level summary information |
| `order_detail_sample.csv` | Line-level order details |
| `customer_sample.csv` | Customer demographic information |
| `lookup.csv` | Product lookup table with brand info |

## Analysis Tasks
- Link datasets and create an Entity-Relationship Diagram (ERD).  
- Calculate key metrics: total customers, total orders, mean spend per order.  
- Identify top 25 products by units sold and by sales.  
- Join customer and order data to analyze purchase behavior and find highest-spending customers.  
- Subquery to extract order-line details for top 5 orders by sales.  
- Connect product lookup to order-line details to find top brands overall and for the most recent 6 months.

## Key Methods & Tools
- **Methods:** SQL joins, subqueries, aggregation, EDA  
- **Tools:** R, SQL, SQLDF
