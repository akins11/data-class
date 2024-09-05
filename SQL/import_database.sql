-- Import product order database ======================================
CREATE DATABASE ProductOrderStatus;

-- Createthe order status table
CREATE TABLE OrderStatus (
	order_id PRIMARY KEY,
	product_id INTEGER NOT NULL,
	order_date DATE NOT NULL,
	order_quantity SMALLINT,
	unit_price FLOAT,
	order_status VARCHAR(50),
	delivery_date DATE NOT NULL,
	sales FLOAT,
	customer_id INTEGER
);

-- (Optional Check)
SELECT * FROM OrderStatus;

-- Import sample data into the order status table
COPY OrderStatus (
	order_id, 
	product_id, 
	order_date, 
	order_quantity, 
	unit_price, 
	order_status, 
	delivery_date, 
	sales, 
	customer_id
)
FROM 'C:/Temp/product_order_status_view.csv'
DELIMITER ','
CSV HEADER;

-- (Optional Check)
SELECT * FROM OrderStatus;