-- Create a sales and orders database =====================================
CREATE DATABASE SalesOrderDB;

-- Create Customers table
CREATE TABLE Customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50)
);

-- Create Products table
CREATE TABLE Products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100),
    unit_price FLOAT,
    category VARCHAR(50)
);

-- Create Orders table
CREATE TABLE Orders (
	order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE,
    amount FLOAT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Create OrderDetails table
CREATE TABLE OrderDetails (
    order_detail_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert sample data into Customers
INSERT INTO Customers (customer_id, customer_name, City) 
VALUES
(1, 'John Fellon', 'New York'),
(2, 'Jane Seffan', 'Los Angeles'),
(3, 'Ben Johnson', 'Chicago'),
(4, 'Paul Brandon', 'Houston'),
(5, 'Jon Davis', 'Phoenix');

-- (Optional check)
SELECT * FROM Customers;


-- Insert sample data into Products
INSERT INTO Products (product_id, product_name, unit_price, category) 
VALUES
(1, 'Laptop', 999.99, 'Electronics'),
(2, 'Smartphone', 599.99, 'Electronics'),
(3, 'Headphones', 149.99, 'Electronics'),
(4, 'Desk Chair', 199.99, 'Furniture'),
(5, 'Coffee Table', 299.99, 'Furniture');

-- (Optional check)
SELECT * FROM Products;


-- Insert sample data into Orders
INSERT INTO Orders (order_id, customer_id, order_date, amount) 
VALUES
(1, 1, '2023-01-15', 1599.98),
(2, 2, '2023-02-20', 749.98),
(3, 3, '2023-03-10', 1149.98),
(4, 4, '2023-04-05', 599.99),
(5, 5, '2023-05-12', 499.98);


-- Insert sample data into OrderDetails
INSERT INTO OrderDetails (order_detail_id, order_id, product_id, quantity) 
VALUES
(1, 1, 1, 1),  -- 1 Laptop
(2, 1, 2, 2),  -- 2 Smartphones
(3, 2, 2, 1),  -- 1 Smartphone
(4, 2, 3, 3),  -- 3 Headphones
(5, 3, 1, 1),  -- 1 Laptop
(6, 3, 3, 2),  -- 2 Headphones
(7, 4, 2, 1),  -- 1 Smartphone
(8, 4, 4, 2),  -- 2 Desk Chairs
(9, 5, 3, 2),  -- 2 Headphones
(10, 5, 5, 1); -- 1 Coffee Table





-- Scalar Subquery ======================================================
-- Get the product name and unit price from the product table
-- where the `unit price` is greater than the overall average unit price.

-- Subquery output (average price per unit for all products)
SELECT AVG(unit_price) FROM Products;

-- Full Query
SELECT 
	product_name, 
	unit_price
FROM Products
WHERE unit_price > (SELECT AVG(unit_price) FROM Products);



-- Multi-row Subquery ========================================================
SELECT * FROM Products;

-- Subquery output (get unit_price where the category is 'Electronics')
SELECT unit_price
FROM Products
WHERE category = 'Electronics';

-- Full query
SELECT product_name, unit_price
FROM Products
WHERE unit_price > ANY (
    SELECT unit_price
    FROM Products
    WHERE category = 'Electronics'
);

-- Using the ALL Keyword ====================================

SELECT * FROM Products;

SELECT product_name, unit_price
FROM Products
WHERE unit_price > ALL (
    SELECT unit_price
    FROM Products
    WHERE category = 'Furniture'
);


-- Correlated Subquery ==================================================
-- Find products with a price higher than the average price in their category:

SELECT * FROM Products;

-- Subquery (Get the category and average price per unit of each category)
SELECT category, AVG(unit_price) AS average_unit_price
FROM Products
GROUP BY category;

-- Full query
SELECT 
	p1.product_id, 
	p1.product_name, 
	p1.unit_price, 
	p1.category
FROM Products AS p1
WHERE p1.unit_price > (
    SELECT AVG(p2.unit_price)
    FROM Products AS p2
    WHERE p2.category = p1.category
);



-- Nested Subquery =================================================================
SELECT * FROM Orders;

-- First subquery (Get the order id for months after March)
SELECT order_id
FROM Orders
WHERE EXTRACT(MONTH FROM order_date) > 3;

SELECT * FROM OrderDetails;

-- Second Subquery (Get the product ids from the order details table where the order was placed after February)
SELECT DISTINCT(product_id)
FROM OrderDetails
WHERE order_id IN (
    SELECT order_id
    FROM Orders
    WHERE EXTRACT(MONTH FROM order_date) > 3
);


SELECT * FROM Products;

-- Full query (Get the product names and unit price of products purchased after March.)
SELECT product_name, unit_price
FROM Products
WHERE product_id IN (
    SELECT product_id
    FROM OrderDetails
    WHERE order_id IN (
        SELECT order_id
        FROM Orders
        WHERE EXTRACT(MONTH FROM order_date) > 3
    )
);


--- CTEs ==============================================================================

-- Simple CTE =================================================
-- Get all products and categories with unit price above the average unit price. 
SELECT * FROM Products;

-- Get the average unit price of all products
SELECT AVG(unit_price) AS average_unit_price
FROM Products;

-- CTE
WITH avg_unit_price_cte AS (
	SELECT AVG(unit_price) AS average_unit_price
	FROM Products
)
SELECT product_name, category, unit_price, average_unit_price
FROM Products, avg_unit_price_cte
WHERE unit_price > average_unit_price;
 

-- Recursive CTE ============================================================
SELECT * FROM Products;

-- Recursive CTE to calculate cumulative quantities of products in OrderDetails
-- Recursive CTE to calculate cumulative quantities of products in OrderDetails
WITH RECURSIVE RecursiveOrderDetails AS (
    -- Anchor member: Start with the first order detail
    SELECT 
        order_detail_id, 
        product_id, 
        quantity, 
        quantity AS cumulative_quantity
    FROM OrderDetails
    WHERE order_detail_id = 1  -- Start from the first OrderDetail (or any base case)

    UNION ALL

    -- Recursive member: Incrementally add quantities of the next order detail
    SELECT 
        od.order_detail_id, 
        od.product_id, 
        od.quantity, 
        rod.cumulative_quantity + od.quantity AS cumulative_quantity
    FROM OrderDetails od
    INNER JOIN RecursiveOrderDetails rod 
        ON od.order_detail_id = rod.order_detail_id + 1  -- Go to the next order detail
)
-- Main query using the CTE
SELECT 
    order_detail_id, 
    product_id, 
    quantity, 
    cumulative_quantity
FROM RecursiveOrderDetails
ORDER BY order_detail_id;



-- Multiple CTEs =============================================================
-- Find the highest unit price by category and then list 
-- products with unit price more than 80% of their highest product category unit price.

-- Get the highest unit price in each category
SELECT category, MAX(unit_price) AS max_unit_price_per_cat
FROM Products
GROUP BY category;

-- Get unit price more than 80% of their highest product category unit price.
WITH cat_max_unit_price_cte AS (
	SELECT category, MAX(unit_price) AS max_unit_price_per_cat
	FROM Products
	GROUP BY category
)
SELECT 
	p.product_id, 
	p.product_name, 
	p.unit_price,
	c.category, 
	c.max_unit_price_per_cat,
	0.8 * c.max_unit_price_per_cat AS unit_price_80_percent
FROM Products AS p
INNER JOIN cat_max_unit_price_cte AS c
	ON p.category = c.category
WHERE p.unit_price > 0.8 * max_unit_price_per_cat;


-- Full cte Query  (Add extra Query to select columns)
WITH cat_max_unit_price_cte AS (
	SELECT category, MAX(unit_price) AS max_unit_price_per_cat
	FROM Products
	GROUP BY category
),
high_products AS (
	SELECT 
		p.product_id, 
		p.product_name, 
		p.unit_price,
		c.category, 
		c.max_unit_price_per_cat
	FROM Products AS p
	INNER JOIN cat_max_unit_price_cte AS c
		ON p.category = c.category
	WHERE p.unit_price > 0.8 * max_unit_price_per_cat
)
SELECT 
	product_name, 
	category, 
	unit_price
FROM high_products;

-- Understand category & 80% of unit price
SELECT category, 0.8 * MAX(unit_price) AS unit_price_80_percent
FROM Products
GROUP BY category;