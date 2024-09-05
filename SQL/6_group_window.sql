-- USE ProductOrderStatus ===================================


-- Create Sales view table -----------------------
CREATE TABLE SalesView (
	sales_id SERIAL PRIMARY KEY,
	store_id INTEGER NOT NULL,
	product_id INTEGER NOT NULL,
	sales_date DATE,
	amount FLOAT,
	product_name VARCHAR(50)
);

-- (Optional Check)
SELECT * FROM SalesView;

-- Insert sample data
COPY SalesView (
	sales_id, 
	store_id, 
	product_id, 
	sales_date, 
	amount, 
	product_name
)
FROM 'C:\Temp\group_table.csv'
DELIMITER ','
CSV HEADER;

-- (Optional Check)
SELECT * FROM SalesView;

-- GROUP BY =========================================================================
-- Single column
SELECT 
	store_id, COUNT(*) AS total_number_of_sales
FROM SalesView
GROUP BY store_id;


-- Multiple Columns
SELECT store_id, product_id, COUNT(*) AS total_sales
FROM SalesView
GROUP BY store_id, product_id;


-- With Aggregate Functions
SELECT store_id, SUM(amount) AS total_sales_amount
FROM SalesView
GROUP BY store_id;

SELECT store_id, AVG(amount) AS average_sales_amount
FROM SalesView
GROUP BY store_id;

SELECT COUNT(*), SUM(amount), AVG(amount), MIN(amount), MAX(amount) 
FROM SalesView 
GROUP BY store_id;


-- HAVING Clause with GROUP BY
SELECT store_id, SUM(amount) AS total_sales_amount
FROM SalesView
GROUP BY store_id
HAVING SUM(amount) > 300;


-- With Expressions within the group by clause
SELECT  
	EXTRACT(DAY FROM sales_date) AS day, 
	SUM(amount) AS daily_sales
FROM SalesView
GROUP BY EXTRACT(DAY FROM sales_date);



-- WINDOW FUNCTION ===================================================================
-- Basic window function
SELECT 
    store_id, 
    sales_date, 
    amount,
    ROW_NUMBER() OVER (PARTITION BY store_id) AS row_num 
FROM SalesView;

-- With order 
SELECT 
    store_id, 
    sales_date, 
    amount,
    ROW_NUMBER() OVER (PARTITION BY store_id ORDER BY sales_date) AS row_num 
FROM SalesView;


-- Aggregate function --------------------------------------------------
SELECT 
    store_id, 
    sales_date, 
    amount,
    SUM(amount) OVER (PARTITION BY store_id) AS running_total
FROM SalesView;

-- Order by Date
SELECT 
    store_id, 
    sales_date, 
    amount,
    SUM(amount) OVER (PARTITION BY store_id ORDER BY sales_date) AS running_total
FROM SalesView;

-- Rank -----------------------------------------------------------
-- Rank sales amount by store
SELECT 
    store_id, 
    amount,
    RANK() OVER (PARTITION BY store_id ORDER BY amount DESC) AS rank
FROM SalesView;


-- DENSE_RANK -----------------------------------------------------
SELECT 
    store_id, 
    amount,
    DENSE_RANK() OVER (PARTITION BY store_id ORDER BY amount DESC) AS dense_rank
FROM SalesView;

SELECT 
    store_id, 
    amount,
    RANK() OVER (PARTITION BY store_id ORDER BY amount DESC) AS rank,
	DENSE_RANK() OVER (PARTITION BY store_id ORDER BY amount DESC) AS dense_rank
FROM SalesView;

-- NTILE ----------------------------------------------------------
SELECT 
    sales_id, 
    store_id, 
    amount,
    NTILE(4) OVER (ORDER BY amount) AS bucket
FROM SalesView;


-- Ungroup ------------------------------------------------------------------
SELECT 
    sales_id, 
    store_id,
	sales_date,
    amount,
    LAG(amount, 1, 0) OVER (ORDER BY sales_date) AS previous_amount
FROM SalesView;


SELECT 
    store_id,
	sales_date,
    amount,
    LEAD(amount, 1, 0) OVER (ORDER BY sales_date) AS next_amount
FROM SalesView;


-- Group -------------------------------------------------------------
SELECT 
    sales_id, 
    store_id,
	sales_date,
    amount,
    LAG(amount, 1, 0) OVER (PARTITION BY store_id ORDER BY sales_date) AS previous_amount
FROM SalesView;

SELECT 
    store_id,
	sales_date,
    amount,
    LEAD(amount, 1, 0) OVER (PARTITION BY store_id ORDER BY sales_date) AS next_amount
FROM SalesView;


-- Combining Multiple Window Functions -------------------------------
SELECT 
    store_id, 
    amount,
    ROW_NUMBER() OVER (PARTITION BY store_id ORDER BY amount DESC) AS row_num,
    SUM(amount) OVER (PARTITION BY store_id) AS total_amount,
    LAG(amount, 1, 0) OVER (ORDER BY sales_date) AS previous_amount
FROM SalesView;