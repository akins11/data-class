-- Using the ProductDeliveryDB -----------------------

-- Create the Customers table
CREATE TABLE Customers (
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
	address VARCHAR(255) NOT NULL,
	category VARCHAR(50),
	comment VARCHAR(255),
	registration_date DATE
);

-- (Optional Check)
SELECT * FROM Customers;

-- Insert records into the Customers table
INSERT INTO Customers (first_name, last_name, address, category, comment, registration_date)
VALUES
    ('John', 'Colman', '123 Elm St, Apt 4', 'Regular', ' Good service ', '2024-01-15'),
    ('Jane', 'Willinton', '456 Oak St, Apt 10', 'Reglar', ' Needs assistance ', '2024-02-10'),
    ('Michael', 'Brown', '789 Pine St, Apt 22', 'VIP', ' Excellent customer ', '2024-03-05'),
    ('Emilia', 'Davis', '321 Cedar St, Apt 8', 'Regular', ' Repeat customer ', '2024-01-25'),
    ('Sarah', 'Wilson', '654 Spruce St, Apt 15', 'Regular', ' Happy with service ', '2024-02-18'),
    ('Jakin', 'Taylor', '987 Birch St, Apt 7', 'Reglar', ' Loyal customer ', '2024-03-12');

-- (Optional Check)
SELECT * FROM Customers;



-- Basic string functions ========================================================

-- String Length -------------------------------------------------
SELECT 'hello' AS str_name, LENGTH('Hello') length_str_name;




-- Concatenation --------------------------------------------------
SELECT 'Hello ' || ' World' AS concat_string;
-- OR
SELECT CONCAT('Hello ', ' World')

-- Example get the full name of customers
SELECT 
	first_name,
	last_name,
	first_name || ' ' || last_name AS concat_full_name,
	CONCAT(first_name, ' ', last_name) AS full_name
FROM Customers;



-- Extracting parts of a string =============================================
-- LEFT ------------------------------------------------
SELECT 
	comment, 
	LEFT(comment, 5) AS first_5_comment_characters
FROM Customers;

-- RIGHT -----------------------------------------------
SELECT 
	comment, 
	RIGHT(comment, 5) AS last_5_comment_characters
FROM Customers;


-- SUBSTRING -------------------------------------------
SELECT 
	comment, 
	SUBSTRING(comment, 4, 8) AS middle_4_comment_characters
FROM Customers;


-- Character index ===========================================================
SELECT POSITION(',' IN 'John, Doe') AS char_index_comma;

-- Example
-- Extract the street in the address column.
SELECT * FROM Customers;

SELECT 
	address, 
	POSITION(',' IN address) AS chr_index_comma, 
	POSITION(',' IN address)-1 AS chr_index_comma_minus_one,
	LEFT(address, POSITION(',' IN address)-1) AS street
FROM Customers;


-- String replacement and removal ==============================================
-- REPLACE ---------------------------------------------
SELECT 'DATABA' AS bad_string, REPLACE('DATABA', 'DATABA', 'DATABASE') AS replace_string;
SELECT 'DATABASE:' AS bad_string, REPLACE('DATABASE:', ':', '') AS replace_string;

-- Example
-- Replace all 'Reglar' with 'Regular' in the category column
SELECT 
	category, 
	REPLACE(category, 'Reglar', 'Regular')
FROM Customers;

-- TRIM ----------------------------------------------------------
-- Whitespace
-- Sample string with potential leading or trailing whitespace
SELECT 
    '  hello  ' AS original_string,
    LENGTH('  hello  ') AS original_length,
    LENGTH(TRIM('  hello  ')) AS trimmed_length,
    LENGTH('  hello  ') <> LENGTH(TRIM('  hello  ')) AS has_whitespace
;

-- LTRIM
-- Detecting leading Whitespace
SELECT 
    '  hello' AS original_string,
    LENGTH('  hello') AS original_length,
    LENGTH(LTRIM('  hello')) AS ltrimmed_length,
    LENGTH('  hello') <> LENGTH(LTRIM('  hello')) AS has_leading_whitespace
;

-- RTRIM
-- Detecting trailing  Whitespace
SELECT 
    'hello  ' AS original_string,
    LENGTH('hello  ') AS original_length,
    LENGTH(RTRIM('hello  ')) AS rtrimmed_length,
    LENGTH('hello  ') <> LENGTH(RTRIM('hello  ')) AS has_trailing_whitespace
;



-- String formatting =========================================================================
-- UPPER -----------------------------------------------
SELECT first_name, UPPER(first_name) AS upper_case_first_name
FROM Customers;

-- LOWER -----------------------------------------------
SELECT first_name, LOWER(first_name) AS lower_case_first_name
FROM Customers;

-- Title case ------------------------------------------
SELECT LOWER(first_name), INITCAP(LOWER(first_name)) AS title_case_first_name
FROM Customers;


-- String search ======================================================================
-- SIMILAR TO -----------------------------
-- Get all customers in the VIP & Regular category
SELECT * 
FROM Customers 
WHERE category SIMILAR TO '%(VIP|Regular)%';

-- OR using the IN keyword
SELECT * 
FROM Customers
WHERE category IN ('VIP', 'Regular');



-- String splitting ===================================================================
SELECT string_to_array('John,Paul,George,Ringo', ',') AS members;
SELECT string_to_array('apple|banana|cherry', '|') AS fruits;

-- with null values
SELECT string_to_array('red--green--blue--', '--', '') AS colors;

-- splitting on a New Line Character:
SELECT string_to_array('line1\nline2\nline3', E'\n') AS lines;


-- Example 
-- Separate the address into street name and apartment name 
SELECT 
	address,
	string_to_array(address, ', ') AS address_array,
	(string_to_array(address, ', '))[1] AS street_name,
	(string_to_array(address, ', '))[2] AS apartment_name
FROM Customers;

-- Using the split_part function
SELECT 
    'John Smith' AS full_name,
    split_part('John Smith', ' ', 1) AS first_name,
    split_part('John Smith', ' ', 2) AS last_name;


-- String aggregation ===========================================================
-- Combine/collapse row 
SELECT STRING_AGG(first_name, ', ') AS customer_first_names
FROM Customers;

-- Ordering Values
SELECT STRING_AGG(first_name, ', ' ORDER BY first_name) AS customer_first_names
FROM Customers;


-- Regular Expressions =====================================================
-- regexp_match ------------------------------------------
SELECT regexp_match('Hello World', 'World');

-- Get all digits in the string
SELECT regexp_match('foo123bar', '\d+');

SELECT regexp_match(REPLACE('$156,478', ',', ''), '\d+');
SELECT (regexp_match(REPLACE('$156,478', ',', ''), '\d+'))[1];

SELECT regexp_match('hello world', 'WORLD', 'i');

-- regexp_replace -----------------------------------
-- replace the a string based on a regular expression pattern
SELECT regexp_replace('Hello 123 World', '\d+', 'NUM');

SELECT regexp_replace('The current year is 2023', '\d+', '2024');

-- Replace multiple space between words
SELECT regexp_replace('This   is   an example', '\s+', ' ', 'g');














-- Group names 
-- SELECT category, STRING_AGG(first_name, ', ') AS customer_first_names
-- FROM Customers
-- GROUP BY category;
