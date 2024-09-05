--CREATE DATABASE ProductOrderStatusDB;

-- Create Customers table --------------------------------------------
CREATE TABLE Customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name VARCHAR(50)
);

-- Insert data into Customers table
INSERT INTO Customers (customer_id, customer_name)
VALUES 
(1, 'Paul'),
(2, 'Kelvin'),
(3, 'John'),
(4, 'David');

-- (Optional Check)
SELECT * FROM  Customers;


-- Create Orders table -----------------------------------
CREATE TABLE Orders (       
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,                     
    order_date DATE
);

-- Insert data into Orders table
INSERT INTO Orders (order_id, customer_id, order_date)
VALUES 
(101, 1, '2024-08-01'),
(102, 2, '2024-08-02'),
(103, 1, '2024-08-03'),
(104, 3, '2024-08-04');

-- (Optional Check)
SELECT * FROM  Orders;



-- INNER JOIN ======================================================
-- customers who have orders.
SELECT 
	Customers.customer_id, 
	Customers.customer_name, 
	Orders.order_id
FROM customers
INNER JOIN Orders
	ON customers.customer_id = Orders.customer_id;


-- LEFT JOIN ==============================================================
-- Shows all customers, including those without orders.
SELECT 
	customers.customer_id,
	customers.customer_name, 
	Orders.order_id
FROM customers
LEFT JOIN Orders
	ON customers.customer_id = Orders.customer_id;


-- RIGHT JOIN =============================================================
-- Show all orders, including those without corresponding customers.
SELECT 
	customers.customer_id, 
	customers.customer_name, 
	Orders.order_id
FROM customers
RIGHT JOIN Orders
	ON Customers.customer_id = Orders.customer_id;


-- FULL JOIN (FULL OUTER JOIN) =============================================
-- Show all customers and all orders, including those without matches.
SELECT 
	customers.customer_id, 
	customers.customer_name, 
	Orders.order_id
FROM customers
FULL OUTER JOIN Orders
	ON customers.customer_id = Orders.customer_id;


-- CROSS JOIN ==============================================================
-- Show every possible combination of customers and orders.
SELECT
	customers.customer_id, 
	Orders.customer_id,
	customers.customer_name, 
	Orders.order_id
FROM customers
CROSS JOIN Orders;


-- SELF JOIN ===============================================================
-- Show all possible pairs of different customers.
SELECT 
	a.customer_id AS a_customer_id,
	b.customer_id AS b_customer_id,
	a.customer_name AS a_customer_name, 
	b.customer_name AS b_customer_name
FROM customers AS a, customers AS b
WHERE a.customer_id <> b.customer_id;



-- 
-- Create ProductA table -----------------------
CREATE TABLE ProductA (
    product_id INTEGER,
    product_name VARCHAR(50)
);
-- Insert data into ProductA
INSERT INTO ProductA (product_id, product_name)
VALUES 
(1, 'Laptop'),
(2, 'Smartphone');

-- Create ProductB table ----------------------------------
CREATE TABLE ProductB (
    product_id INTEGER,
    product_name VARCHAR(50)
);
-- Insert data into ProductB
INSERT INTO ProductB (product_id, product_name)
VALUES 
(2, 'Smartphone'),
(3, 'Tablet');

-- (Optional Check)
SELECT * FROM ProductA;
SELECT * FROM ProductB;

-- UNION =====================================================================
SELECT product_id, product_name
FROM ProductA
UNION
SELECT product_id, product_name
FROM ProductB;

-- UNION ALL =====================================================
SELECT product_id, product_name
FROM ProductA
UNION ALL
SELECT product_id, product_name
FROM ProductB;