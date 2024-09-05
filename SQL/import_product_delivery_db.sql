-- Import product delivery database ======================================
CREATE DATABASE ProductDeliveryDB;

-- Createthe order delivery table
CREATE TABLE OrderDelivery (
	delivery_id SERIAL PRIMARY KEY,
	product_id INTEGER,
	order_timestamp TIMESTAMP,
	delivery_timestamp TIMESTAMP,
	quantity_order SMALLINT,
	cost FLOAT
);

-- (Optional check)
SELECT * FROM OrderDelivery;

-- Import sample data into the order status table
COPY OrderDelivery (
	delivery_id, 
	product_id, 
	order_timestamp, 
	delivery_timestamp, 
	quantity_order, 
	cost
)
FROM 'C:/Temp/delivery_db_orders_table.csv'
DELIMITER ','
CSV HEADER;


-- (Optional check)
SELECT * FROM OrderDelivery;