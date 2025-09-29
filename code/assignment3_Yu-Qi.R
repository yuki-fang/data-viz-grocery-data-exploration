### IMC461
### Assignment 3

library(sqldf) 
getwd()
setwd("/Applications/IMC461/datasets/grocery")  

# Read in the csv files
customer_table<-read.csv("customer_sample.csv", header=TRUE)
prod_category<-read.csv("lookup.csv", header=TRUE)
order_detail<-read.csv("order_detail_sample.csv", header=TRUE)
order_header<-read.csv("order_header_sample.csv", header=TRUE)
session_data<-read.csv("session_sample.csv", header=TRUE)

# Check datasets
head(customer_table)
head(prod_category)
head(order_detail)
head(order_header)
head(session_data)

# 1a: Show total number of customer records
sqldf("SELECT COUNT(*) AS customer_records
      FROM customer_table")

# 1b: total number of orders
sqldf("SELECT COUNT(ord_id) AS number_of_orders
      FROM order_header")

# 1c: mean spend per order 
sqldf("SELECT ROUND(AVG(it_dmnd_qy),2) AS mean_spend
      FROM order_header")

# 2a: What are the top 25 products sold by units?  
sqldf("SELECT o.pod_id AS product_ID, p.it_long_name_tx AS product_name, SUM(o.it_qy) AS total_units_sold
      FROM order_detail AS o
      LEFT JOIN prod_category AS p ON o.pod_id = p.pod_id
      GROUP BY o.pod_id
      ORDER BY SUM(o.it_qy) DESC
      LIMIT 25;")

# 2b: What are the top 25 products by sales?
sqldf("SELECT o.pod_id AS product_ID, p.it_long_name_tx AS product_name, SUM(o.tot_pr_qy) AS total_sales
      FROM order_detail AS o 
      LEFT JOIN prod_category AS p ON o.pod_id = p.pod_id
      GROUP BY o.pod_id
      ORDER BY SUM(o.tot_pr_qy) DESC
      LIMIT 25;")

# Write a join between the order header and the customer table. 
# Include only the customers with a record on the order table.  

# 3: How many customers have an order? Identify the customer ID with the highest sales.
sqldf("SELECT c.cnsm_id AS customer_ID, SUM(o.it_dmnd_qy) AS sales
      FROM customer_table AS c
      LEFT JOIN order_header AS o ON c.cnsm_id = o.cnsm_id
      GROUP BY c.cnsm_id
      ORDER BY SUM(o.it_dmnd_qy) DESC
      LIMIT 1;")
#head(order_detail)
#head(order_header)

# 4: Write a subquery to pull the order-line detail for the 5 orders with the highest sales on the Order Header table
sqldf("SELECT *
FROM order_detail 
WHERE ord_id IN (SELECT ord_id
      FROM order_header
      GROUP BY ord_id
      ORDER BY SUM(it_dmnd_qy) DESC
      LIMIT 5)")

# 5: Write a join to connect the lookup table to the order-line detail table
sqldf("SELECT p.*, o.*
      FROM prod_category AS p 
      LEFT JOIN order_detail AS o ON p.pod_id = o.pod_id")

#head(order_detail)
#head(prod_category)
#head(order_header)

# 6: What are the top 10 brands in the order data

# top 10 brands by total sales
sqldf("SELECT p.brnd_desc AS brand, SUM(o.tot_pr_qy) AS total_sales
      FROM prod_category AS p
      LEFT JOIN order_detail AS o ON p.pod_id = o.pod_id
      GROUP BY brand
      ORDER BY total_sales DESC
      LIMIT 10;
      ")

# top 10 brands by total items sold
sqldf("SELECT p.brnd_desc AS brand, SUM(o.it_qy) AS total_items_sold
      FROM prod_category AS p
      LEFT JOIN order_detail AS o ON p.pod_id = o.pod_id
      GROUP BY brand
      ORDER BY total_items_sold DESC
      LIMIT 10;
      ")

# 7: What are the top 10 brands in the most recent 6 months 
# check date range 
range(order_header$dlv_dt, na.rm = TRUE)

#check data type 
str(order_header$dlv_dt)

# top 10 brands by total sales in last 6 months 
sqldf("SELECT p.brnd_desc AS brand, SUM(o.tot_pr_qy) AS total_sales
      FROM prod_category AS p
      LEFT JOIN order_detail AS o ON p.pod_id = o.pod_id
      LEFT JOIN order_header AS od ON o.ord_id = od.ord_id 
      WHERE strftime('%Y', od.dlv_dt) = '2013' 
        AND strftime('%m', od.dlv_dt) IN ('01', '02', '03', '04', '05', '06')
      GROUP BY brand
      ORDER BY total_sales DESC
      LIMIT 10;
      ")

# another method  
sqldf("SELECT p.brnd_desc AS brand, SUM(o.tot_pr_qy) AS total_sales
      FROM prod_category AS p
      LEFT JOIN order_detail AS o ON p.pod_id = o.pod_id
      LEFT JOIN order_header AS od ON o.ord_id = od.ord_id 
      WHERE od.dlv_dt >= DATE('2013-06-25','-6 months')
      GROUP BY brand
      ORDER BY total_sales DESC
      LIMIT 10;
      ")