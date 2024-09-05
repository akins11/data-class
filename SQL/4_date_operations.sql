-- Using the ProductDeliveryDB -----------------------
SELECT * FROM OrderDelivery;

-- Get Current Date ===========================================================================
-- CURRENT_DATE - Returns the current date:
SELECT CURRENT_DATE AS current_date;

-- CURRENT_TIME - Returns the current time:
SELECT CURRENT_TIME AS current_time;

-- CURRENT_TIMESTAMP - Returns the current date and time or timestamp:
SELECT CURRENT_TIMESTAMP AS current_date_time;
-- OR
SELECT NOW() AS current_date_time;

-- LOCALTIMESTAMP - Returns the current date & time without any timezone information.
SELECT LOCALTIMESTAMP;


-- MAKE_DATE() - Creates a date from separate year, month, and day values:
SELECT 
  2023 AS year,
  12 AS month,
  31 AS day,
  MAKE_DATE(2023, 12, 31) AS constructed_date;
  
-- OR ========================================
SELECT 
  2023 AS year,
  12 AS month,
  31 AS day,
  '2023-12-31'::DATE AS constructed_date;


-- Extracting Date and Time Parts ==============================================================

-- EXTRACT() - Extracts a specific part of a date:
SELECT 
    order_timestamp,
    -- Date Part
    EXTRACT(YEAR FROM order_timestamp) AS order_year,
    EXTRACT(QUARTER FROM order_timestamp) AS order_quarter,
    EXTRACT(MONTH FROM order_timestamp) AS order_month,
    EXTRACT(DAY FROM order_timestamp) AS order_day,
    -- Time Part
    EXTRACT(HOUR FROM order_timestamp) AS order_hour,
    EXTRACT(MINUTE FROM order_timestamp) AS order_minute,
    EXTRACT(SECOND FROM order_timestamp) AS order_second
FROM OrderDelivery;


SELECT 
	order_timestamp, 
	TO_CHAR(order_timestamp, 'FMMonth') AS full_month_name,
	TO_CHAR(order_timestamp, 'Mon') AS abbrevaited_month_name,
	TO_CHAR(order_timestamp, 'FMDay') AS order_weekday_name,
	TO_CHAR(order_timestamp, 'FMDay, FMMonth DD, YYYY HH24:MI:SS') AS combined_date_format
FROM OrderDelivery;



-- Date and Time Calculations =================================================================
-- INTERVAL - Adds a specified time interval to a date -----------------------
SELECT 
  NOW() AS current_date_time,
  NOW() + INTERVAL '10 days' AS date_plus_ten_days,
  NOW() + INTERVAL '2 months' AS date_plus_two_months,
  NOW() + INTERVAL '1 year' AS date_plus_one_year;


SELECT 
	order_timestamp, 
	order_timestamp + INTERVAL '2 days'  AS additional_two_days 
FROM OrderDelivery;


-- Calculates the difference between two dates ----------------------------------
SELECT 
	'2023-12-31'::date, 
	('2023-12-31'::date - '2023-01-01'::date) AS days_difference;


SELECT 
	order_timestamp,
	delivery_timestamp,
	delivery_timestamp - order_timestamp AS days_difference
FROM OrderDelivery;



-- ==================================================================
-- Now, let's look at some common operations and scenarios:
-- Find events within a date range:
SELECT *
FROM OrderDelivery
WHERE order_timestamp BETWEEN '2024-01-01' AND '2024-08-31';

-- Find products that were delivered on the same day
SELECT *
FROM OrderDelivery
WHERE order_timestamp::date = delivery_timestamp::date;

-- Find the number of orders per month
SELECT 
	EXTRACT(YEAR FROM order_timestamp) AS order_year, 
    EXTRACT(MONTH FROM order_timestamp) AS order_month, 
    COUNT(*) AS order_count
FROM OrderDelivery
GROUP BY EXTRACT(YEAR FROM order_timestamp), EXTRACT(MONTH FROM order_timestamp)
ORDER BY order_year, order_month;

-- Find orders that were placed on weekends
SELECT *
FROM OrderDelivery
WHERE EXTRACT(DOW FROM order_timestamp) IN (0, 6); -- 0 = Sunday, 6 = Saturday

SELECT *
FROM OrderDelivery
WHERE EXTRACT(DOW FROM order_timestamp) NOT IN (0, 6);

