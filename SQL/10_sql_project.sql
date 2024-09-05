-- Create CoffeeStore Database ===========================================
CREATE DATABASE CoffeStoreDB;

-- Create Tables =========================================================
-- Product table --------------------------------------------
CREATE TABLE Product (
	product_id SERIAL PRIMARY KEY,
	product_group VARCHAR(50),
	category VARCHAR(50),
	product_type VARCHAR(50),
	product VARCHAR(100),
	description TEXT,
	unit_measure VARCHAR(10),
	current_wholesale_price FLOAT,
	current_retail_price FLOAT,
	tax_exemption VARCHAR(5),
	promotion VARCHAR(5),
	new_product VARCHAR(5)
);

COPY Product (
	product_id,
	product_group,
	category,
	product_type,
	product,
	description,
	unit_measure,
	current_wholesale_price,
	current_retail_price,
	tax_exemption,
	promotion,
	new_product
)
FROM 'C:\Temp\coffee-db\product.csv'
DELIMITER ','
CSV HEADER;

-- (Optional) Check
SELECT * FROM Product;
DROP TABLE Product CASCADE;


-- Customer Table -------------------------------------------------
CREATE TABLE Customer (
	customer_id INTEGER PRIMARY KEY,
	home_store SMALLINT NOT NULL,
	full_name VARCHAR(150),
	email VARCHAR(200),
	start_date DATE,
	loyalty_card_number VARCHAR(50),
	birth_date DATE,
	gender VARCHAR(10),
	birth_year INTEGER
);

COPY Customer (
	customer_id,
	home_store,
	full_name,
	email,
	start_date,
	loyalty_card_number,
	birth_date,
	gender,
	birth_year
)
FROM 'C:\Temp\coffee-db\customer.csv'
DELIMITER ','
CSV HEADER;

-- (Optional) Check
SELECT * FROM Customer;


-- Inventory Table -----------------------------------------------------
CREATE TABLE Inventory (
	outlet_id SMALLINT NOT NULL,
	transaction_date DATE NOT NULL,
	product_id SMALLINT NOT NULL,
	quantity_start_of_day SMALLINT,
	quantity_sold SMALLINT,
	quantity_wasted SMALLINT,
	percentage_waste FLOAT 
);


COPY Inventory (
	outlet_id,
	transaction_date,
	product_id,
	quantity_start_of_day,
	quantity_sold,
	quantity_wasted,
	percentage_waste 
)
FROM 'C:\Temp\coffee-db\inventory.csv'
DELIMITER ','
CSV HEADER;

-- (Optional) Check
SELECT * FROM Inventory;



-- Outlet Table ---------------------------------------------------
CREATE TABLE SalesOutlet (
	outlet_id SMALLINT PRIMARY KEY,
	outlet_type VARCHAR(15),
	store_square_feet INTEGER,
	address VARCHAR(255),
	city VARCHAR(50),
	state_province VARCHAR(5),
	telephone VARCHAR(20),
	postal_code INTEGER,
	longitude FLOAT,
	latitude FLOAT,
	manager_id SMALLINT NULL,
	neighorhood VARCHAR(200)
);

COPY SalesOutlet (
	outlet_id,
	outlet_type,
	store_square_feet,
	address,
	city,
	state_province,
	telephone,
	postal_code,
	longitude,
	latitude,
	manager_id,
	neighorhood
)
FROM 'C:\Temp\coffee-db\sales_outlet.csv'
DELIMITER ','
CSV HEADER;


-- (Optional) Check
SELECT * FROM SalesOutlet;

-- Staffs Table -------------------------------------------
CREATE TABLE Staff (
	staff_id SERIAL PRIMARY KEY,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	position VARCHAR(50),
	start_date DATE,
	location VARCHAR(10)
);

-- Load data
COPY Staff (
	staff_id,
	first_name,
	last_name,
	position,
	start_date,
	location
)
FROM 'C:\Temp\coffee-db\staff.csv'
DELIMITER ','
CSV HEADER;

-- (Optional) Check
SELECT * FROM Staff;

-- Sales receipt table -----------------------------------
CREATE TABLE SalesReciept (
	transaction_id SERIAL PRIMARY KEY,
	customer_transaction_id INTEGER NOT NULL,
	transaction_date DATE NOT NULL,
	transaction_time TIME NOT NULL,
	outlet_id SMALLINT NOT NULL,
	staff_id SMALLINT NOT NULL,
	customer_id INTEGER NOT NULL,
	product_instore VARCHAR(5),
	sales_order SMALLINT,
	line_item_id SMALLINT NOT NULL,
	product_id SMALLINT NOT NULL,
	quantity SMALLINT,
	line_item_amount FLOAT,
	unit_price FLOAT,
	promoted_item VARCHAR(5),
	FOREIGN KEY (outlet_id) REFERENCES SalesOutlet(outlet_id),
	FOREIGN KEY (staff_id) REFERENCES Staff(staff_id),
	FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
	FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

COPY SalesReciept (
	transaction_id,
	customer_transaction_id,
	transaction_date,
	transaction_time,
	outlet_id,
	staff_id,
	customer_id,
	product_instore,
	sales_order,
	line_item_id,
	product_id,
	quantity,
	line_item_amount,
	unit_price,
	promoted_item
)
FROM 'C:\Temp\coffee-db\sales_reciepts.csv'
DELIMITER ','
CSV HEADER;

-- (Optional) Check
SELECT * FROM SalesReciept;

-- Data analysis project =========================================================

-- Sales Performance Analysis -------------------------------
--+ Revenue by Store:
SELECT 
    so.sales_outlet_id AS store,
    SUM(sr.line_item_amount) AS total_revenue
FROM 
    SalesReceipt AS sr
JOIN 
    SalesOutlet AS so ON sr.sales_outlet_id = so.sales_outlet_id
GROUP BY 
    so.store_id
ORDER BY 
    total_revenue DESC;


--+ Sales Volume by Product:
SELECT 
    p.product AS product_name,
    SUM(sr.quantity) AS total_sales_volume
FROM 
    SalesReceipt AS sr
JOIN 
    Product AS p ON sr.product_id = p.product_id
GROUP BY 
    p.product
ORDER BY 
    total_sales_volume DESC;


--+ Weekly sales Trend: 
SELECT 
    DATEPART(WEEK, sr.transaction_date) AS week_number,
    SUM(sr.line_item_amount) AS weekly_revenue
FROM 
    SalesReceipt AS sr
GROUP BY 
    DATEPART(WEEK, sr.transaction_date)
ORDER BY 
    week_number;


-- Product Performance Analysis -------------------------------------------
--+ Best-Selling Product Category in Each Sales Outlet:
WITH CategorySales AS (
    SELECT 
        sr.sales_outlet_id,
        p.product_category,
        SUM(sr.quantity) AS total_quantity_sold,
        SUM(sr.line_item_amount) AS total_revenue
    FROM 
        SalesReceipt AS sr
    JOIN 
        Product AS p ON sr.product_id = p.product_id
    GROUP BY 
        sr.sales_outlet_id, p.product_category
),
BestSellingCategories AS (
    SELECT 
        cs.sales_outlet_id,
        cs.product_category,
        cs.total_quantity_sold,
        cs.total_revenue
        RANK() OVER (PARTITION BY cs.sales_outlet_id ORDER BY cs.total_quantity_sold DESC) AS product_category_rank
    FROM 
        CategorySales AS cs
)
SELECT 
    bsc.sales_outlet_id,
    so.store_city AS store_location,
    bsc.product_category AS best_selling_category,
    bsc.total_quantity_sold
    bsc.total_revenue
FROM 
    BestSellingCategories AS bsc
JOIN 
    SalesOutlet AS so ON bsc.sales_outlet_id = so.sales_outlet_id
WHERE 
    bsc.product_category_rank = 1
    -- bsc.product_category_rank < 5  -- (Top 5 Selling product category by outlet)
ORDER BY 
    StoreLocation;


--+ Best-Selling Products in Each Sales Outlet:
WITH ProductSales AS (
    SELECT 
        sr.sales_outlet_id,
        sr.product_id,
        SUM(sr.quantity) AS total_quantity_sold,
        SUM(sr.line_item_amount) AS total_revenue
    FROM 
        SalesReceipt sr
    GROUP BY 
        sr.sales_outlet_id,  sr.product_id
),
BestSellingProducts AS (
    SELECT 
        ps.sales_outlet_id,
        ps.product_id,
        ps.total_quantity_sold,
        ps.total_revenue
        RANK() OVER (PARTITION BY ps.sales_outlet_id ORDER BY ps.total_quantity_sold DESC) AS sales_rank
    FROM 
        ProductSales AS ps
)
SELECT 
    bsp.sales_outlet_id,
    so.store_city AS store_location,
    p.product AS product_name,
    bsp.total_quantity_sold,
    bsp.total_revenue
FROM 
    BestSellingProducts AS bsp
JOIN 
    Product AS p ON bsp.product_id = p.product_id
JOIN 
    SalesOutlet AS so ON bsp.sales_outlet_id = so.sales_outlet_id
WHERE 
    bsp.sales_rank = 1
   -- bsp.sales_rank <= 5  -- Top 5 best selling products.
ORDER BY 
    bsp.sales_outlet_id;


--+ Product with the Least Wastage:
WITH ProductWaste AS (
    SELECT 
        i.product_id,
        p.product,
        AVG(i.percentage_of_waste) AS avg_waste_percentage
    FROM 
        Inventory AS i
    JOIN 
        Product AS p ON i.product_id = p.product_id
    GROUP BY 
        i.product_id, p.product
),
LeastWasteProduct AS (
    SELECT 
        pw.product_id,
        pw.product,
        pw.avg_waste_percentage,
        RANK() OVER (ORDER BY pw.avg_waste_percentage ASC) AS waste_rank
    FROM 
        ProductWaste AS pw
)
SELECT 
    lwp.product AS product_with_least_waste,
    lwp.avg_waste_percentage
FROM 
    LeastWasteProduct  AS lwp
WHERE 
    lwp.waste_rank = 1;
   -- iwp.waste_rank < 5 -- (top five products with the least westage across all stores)


-- Operational efficiency Analysis: ------------------------------------------------
--+ Sales Per Employee:
SELECT 
    s.first_name + ' ' + s.last_name AS employee_name,
    s.position,
    SUM(sr.line_item_amount) AS total_sales,
    COUNT(DISTINCT sr.transaction_id) AS number_of_transactions,
    (SUM(sr.line_item_amount) / COUNT(DISTINCT sr.transaction_id)) AS sales_per_transaction
FROM 
    SalesReceipt AS sr
JOIN 
    Staff AS s ON sr.staff_id = s.staff_id
GROUP BY 
    s.first_name, s.last_name, s.position  -- Remove: s.last_name to make sure you are not calculating for the same staff twice
ORDER BY 
    total_sales DESC;


--+ Potential Revenue Lost Due to Wastage by Store ID:
SELECT 
    i.sales_outlet_id,
    so.store_city AS store_location,
    SUM(i.wast * p.current_retail_price) AS potential_revenue_lost
FROM 
    Inventory AS i
JOIN 
    Product AS p ON i.product_id = p.product_id
JOIN 
    SalesOutlet AS so ON i.sales_outlet_id = so.sales_outlet_id
GROUP BY 
    i.sales_outlet_id,  so.store_city  -- Remove the store_city as this is likely going to increase the granularity.
ORDER BY 
    potential_revenue_lost DESC;


--  Customer Behavior Analysis: ----------------------------------------------
--+ Average Transaction Value by Customer: 
SELECT 
    c.customer_id,
    c.customer_first_name,
    c.customer_email,                    -- Remove
    AVG(sr.line_item_amount) AS average_transaction_value
FROM 
    SalesReceipt AS sr
JOIN 
    Customer AS c ON sr.customer_id = c.customer_id
GROUP BY 
    c.customer_id, c.customer_first_name, c.customer_email
ORDER BY 
    average_transaction_value DESC;


--+ Popular Purchase Combination by Customer:
WITH CustomerPurchases AS (
    SELECT 
        sr.customer_id,
        sr.transaction_id,
        STRING_AGG(p.product, ', ') AS purchase_combination
    FROM 
        SalesReceipt AS sr
    JOIN 
        Product AS p ON sr.product_id = p.product_id
    GROUP BY 
        sr.customer_id, sr.transaction_id                            -- Check that tansaction_id is not blocking any thing (suggestion remove transaction id)
),
CombinationFrequency AS (
    SELECT 
        purchase_combination,
        COUNT(*) AS frequency
    FROM 
        CustomerPurchases
    GROUP BY 
        purchase_combination
)
SELECT 
    purchase_combination,
    frequency
FROM 
    CombinationFrequency
ORDER BY 
    frequency DESC
LIMIT 1;  -- This gets the highest combination  || Also no LIMIT in MS SQL


--+ Frequency of Visit by Customers:
SELECT 
    c.customer_id,
    sr.transaction_date, 
    sr.transaction_time,
    c.customer_first_name,
    c.customer_email,                     --- < Remove >
    COUNT(DISTINCT sr.transaction_id) AS visit_frequency
FROM 
    SalesReceipt AS sr
JOIN 
    Customer AS c ON sr.customer_id = c.customer_id
GROUP BY 
    c.customer_id, sr.transaction_date, sr.transaction_time
ORDER BY 
   visit_frequency DESC;
