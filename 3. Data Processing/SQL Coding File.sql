------------ This is just to check if the table is loaded correctly and I am can read it ----------
SELECT*
FROM workspace.default.bright_coffee_shop
LIMIT 10;
----------------------------------------------------------------------------------------------
----- 1. Checking the date range -----
---------------------------------------------------------------------------------------------
---- Data was first collected on 2023-01-01 ------
SELECT MIN(transaction_date) AS start_date
FROM workspace.default.bright_coffee_shop;

---- Data was last collected on 2023-06-30 ------
SELECT MAX(transaction_date) AS latest_date
FROM workspace.default.bright_coffee_shop;
---------------------------------------------------------------------------------------------
----- 2. Checking the different store location names -----
---------------------------------------------------------------------------------------------
-- There are 3 sotre locations - Lower Manhattan, Hell's Kitchen and Astoria --
SELECT DISTINCT store_location
FROM workspace.default.bright_coffee_shop;
---------------------------------------------------------------------------------------------
----- 3. Checking the products sold across all the stores -----
---------------------------------------------------------------------------------------------
SELECT DISTINCT product_category
FROM workspace.default.bright_coffee_shop;

SELECT DISTINCT product_detail
FROM workspace.default.bright_coffee_shop;

SELECT DISTINCT product_detail AS product_name,
                product_type AS product_type,
                product_category AS category     
FROM workspace.default.bright_coffee_shop;

SELECT DISTINCT product_type
FROM workspace.default.bright_coffee_shop;
---------------------------------------------------------------------------------------------
---- 4. Checking the product prices ------ 0.8 (lowest) and 45 (highest)
SELECT MIN (unit_price) AS cheapest_price,
       MAX (unit_price) AS expensive_price
FROM workspace.default.bright_coffee_shop;
---------------------------------------------------------------------------------------------
---- 5. Checking the number of transactions ------
SELECT COUNT(DISTINCT transaction_id) AS number_of_transactions,
       COUNT(DISTINCT product_id) AS number_of_products,
       COUNT(DISTINCT store_id) AS number_of_stores
FROM workspace.default.bright_coffee_shop;
------------------------------------------------------------------------------------------
------- 6. Checking the Day and Month of the week for the transactions -------
------------------------------------------------------------------------------------------
SELECT transaction_date, 
      dayname(transaction_date) AS day_name,
       MONTHNAME(transaction_date) AS month_name,
       transaction_qty*unit_price AS Revenue
FROM workspace.default.bright_coffee_shop;

SELECT unit_price,
       transaction_qty,
       unit_price*transaction_qty AS Revenue
FROM workspace.default.bright_coffee_shop;
------------------------------------------------------------------------------------------
--------- . Checking NULLs in Various columns ------------------------
--------------------------------------------------------------------------------------

--------- Checking combined functions to get a clean data set ------------------------
--------------------------------------------------------------------------------------
SELECT transaction_date,
       transaction_id,
       transaction_qty,
       transaction_time,
       store_id,
       store_location,
       product_id,
       unit_price,
       product_category,
       product_type,
       product_detail,
-- adding columns to enhance data and give more insight 
-- New column 1
       dayname(transaction_date) AS day_name,
---- New column 2
       monthname(transaction_date) AS month_name,
---- New column 3
       dayofmonth(transaction_date) AS date_of_month,
---- New column 4 (Determing Weekdays/Weekends)
      CASE
            WHEN dayname(transaction_date) IN ('Saturday','Sunday') THEN 'Weekend'
            ELSE 'Weekday'
      END AS Day_classification,
-- adding time buckets (New column 5)
      CASE 
            WHEN date_format(transaction_time, 'HH:MM:SS') BETWEEN '05:00:00' AND '08:59:59' THEN '01. Rush/Peak Hour'
            WHEN date_format(transaction_time, 'HH:MM:SS') BETWEEN '09:00:00' AND '11:59:59' THEN '02. Mid-morning'
            WHEN date_format(transaction_time, 'HH:MM:SS') BETWEEN '12:00:00' AND '15:59:59' THEN '03. Afternoon'
            WHEN date_format(transaction_time, 'HH:MM:SS') BETWEEN '16:00:00' AND '19:59:59' THEN '04. Evening'
       ELSE '05. Night'
      END AS Time_classification,
------ New column 6 Revenue and adding spend buckets 
      CASE 
            WHEN (transaction_qty*unit_price) <=50 THEN '01.Low Spender'
            WHEN (transaction_qty*unit_price) BETWEEN 50 AND 200 THEN '02.Medium Spender'
            WHEN (transaction_qty*unit_price) BETWEEN 201 AND 300 THEN '03.High Spender'
            ELSE '04.Msayipheni'
      END AS spending_buckets,
------- New column 7 revenue 
            transaction_qty*unit_price AS Revenue 
FROM workspace.default.bright_coffee_shop;
