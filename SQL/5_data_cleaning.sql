-- Create Property Database =====================
CREATE DATABASE PropertyDB;


-- Create a sales table in the database
CREATE TABLE PropertyValue (
	transaction_id SERIAL PRIMARY KEY,
	property_address VARCHAR(200) NOT NULL,
	sales_date VARCHAR(50),
	advertised VARCHAR(10),
	land_value VARCHAR(20),
	building_value VARCHAR(20),
	total_value VARCHAR(20)
);


-- (Optional Check)
SELECT * FROM PropertyValue;


COPY PropertyValue (
	transaction_id,
	property_address,
	sales_date,
	advertised,
	land_value,
	building_value,
	total_value
)
FROM 'C:/Temp/property_table.csv'
DELIMITER ','
CSV HEADER;

-- (Optional Check) Retrive the dirty property sales table
SELECT * FROM PropertyValue;


-- 1. Create separate columns for the street, city and state information from the `property_address` column.
SELECT property_address FROM PropertyValue;

SELECT string_to_array('Allen Avenue, Lagos Island, Lagos', ', ');

-- street name = `Allen Avenue`
-- city name = `Lagos Island`
-- state name = `Lagos`

-- Extracting the street name
SELECT (string_to_array(property_address, ', '))[1] AS street_name FROM PropertyValue;

-- Extracting the city name
SELECT (string_to_array(property_address, ', '))[2] AS city_name FROM PropertyValue;

-- Extracting the state name
SELECT (string_to_array(property_address, ', '))[3] AS state_name FROM PropertyValue;

SELECT 
	property_address,
	(string_to_array(property_address, ', '))[1] AS street,
	(string_to_array(property_address, ', '))[2] AS city,
	REPLACE((string_to_array(property_address, ', '))[3], '.', '') AS state
FROM PropertyValue;


-- Create new columns
ALTER TABLE PropertyValue
	ADD COLUMN street VARCHAR(255),
	ADD COLUMN city VARCHAR(255),
	ADD COLUMN state VARCHAR(255);

-- (optional check)
SELECT street, city, state FROM PropertyValue;

-- Update PropertyValue table
UPDATE PropertyValue
SET street = (string_to_array(property_address, ', '))[1],
	city = (string_to_array(property_address, ', '))[2],
	state = REPLACE((string_to_array(property_address, ', '))[3], '.', '');

-- (optional check)
SELECT property_address, street, city, state FROM PropertyValue;


-- 2. Convert the sales date column to a date data type ===========================================
SELECT sales_date FROM PropertyValue;

SELECT 
	sales_date,
	REPLACE(sales_date, 'date: ', '') AS cleaned_text_date,
	REPLACE(sales_date, 'date: ', '')::DATE AS cleaned_date
FROM PropertyValue;

-- Update PropertyValue: sales_date
-- Drop the text value
UPDATE PropertyValue
SET sales_date = REPLACE(sales_date, 'date: ', '');

-- Convert to date data-type
ALTER TABLE PropertyValue
ALTER COLUMN sales_date TYPE DATE USING sales_date::DATE;

-- (Optional check)
SELECT sales_date FROM PropertyValue;


-- 3. Replace bad inputed values in the advertised column ===============================
SELECT advertised FROM PropertyValue;

-- false = 0, N, No >> No
-- true  = 1, Y, Yes >> Yes

SELECT 
	advertised,
	CASE 
		WHEN advertised = '0' THEN 'No'
		WHEN advertised = 'N' THEN 'No'
		WHEN advertised = '1' THEN 'Yes'
		WHEN advertised = 'Y' THEN 'Yes'
		ELSE advertised
	END
FROM PropertyValue;

-- OR

SELECT
	advertised,
	CASE 
		WHEN advertised IN ('0', 'N', 'No') THEN 'No'
		WHEN advertised IN ('1', 'Y', 'Yes') THEN 'Yes'
		ELSE NULL
	END
FROM PropertyValue;
	
-- Update PropertyValue: advertised
UPDATE PropertyValue
SET advertised = CASE 
	WHEN advertised IN ('0', 'N', 'No') THEN 'No'
	WHEN advertised IN ('1', 'Y', 'Yes') THEN 'Yes'
	ELSE NULL
END;

-- (Optional Check)
SELECT advertised FROM PropertyValue;


-- 4. Convert the land value to a float data type ===============================
SELECT land_value FROM PropertyValue;

SELECT land_value, REPLACE(land_value, 'N', '')::FLOAT FROM PropertyValue;

-- Update PropertyValue: land_value
-- Drop the text value
UPDATE PropertyValue
SET land_value = REPLACE(land_value, 'N', '');

-- (Optional check)
SELECT land_value FROM PropertyValue;

-- Convert to land_value to float data-type
ALTER TABLE PropertyValue
ALTER COLUMN land_value TYPE FLOAT USING land_value::FLOAT;

-- (Optional check)
SELECT land_value FROM PropertyValue;


-- 5. Convert building_value column to a float data type ===================
SELECT building_value FROM PropertyValue;

SELECT 
	building_value, 
	REPLACE(building_value, 'N', '') AS replaced_naira_sign,
	REPLACE(REPLACE(building_value, 'N', ''), ',', '')::FLOAT AS replaced_naira_sign_comma
FROM PropertyValue;

-- Update the PropertyValue: building_value
-- remove the naira sign and comma
UPDATE PropertyValue
SET building_value = REPLACE(REPLACE(building_value, 'N', ''), ',', '');

-- (Optional Check)
SELECT building_value FROM PropertyValue;

-- Convert character to float
ALTER TABLE PropertyValue
ALTER COLUMN building_value TYPE FLOAT USING building_value::FLOAT;

-- (Optional Check)
SELECT building_value FROM PropertyValue;



-- 7. Convert & impute total_value column and convert it to a float data type ===================
SELECT 
	land_value, 
	building_value, 
	total_value,
	land_value + building_value AS sum_value
FROM PropertyValue;


SELECT REPLACE(total_value, 'N', '') 
FROM PropertyValue;

-- Update PropertyValue: total_value
-- replace the naira sign
UPDATE PropertyValue
SET total_value = REPLACE(total_value, 'N', '');

-- (Optional Check)
SELECT total_value FROM PropertyValue;

-- Convert character to float
ALTER TABLE PropertyValue
ALTER COLUMN total_value TYPE FLOAT USING total_value::FLOAT;

-- (Optional Check)
SELECT total_value FROM PropertyValue;

-- Impute the total value column using a sum of the land and building values.
UPDATE PropertyValue
SET total_value = land_value + building_value
WHERE total_value IS NULL;

-- (Optional Check)
SELECT 
	land_value, 
	building_value, 
	total_value,
	land_value + building_value AS sum_land_building
FROM PropertyValue;

SELECT land_value, building_value, total_value, land_value + building_value AS sum_land_building
FROM PropertyValue
WHERE total_value != land_value + building_value;
