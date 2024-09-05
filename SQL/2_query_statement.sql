-- Using the LibraryDB ------------------------------------------------------


-- SELECT STATEMENT ===============================================================
-- Select all columns and records from the Books table --------------------------
SELECT * FROM Books;

-- Select specific columns and records in a table -------------------------------
SELECT title, author, publication_year
FROM Books;

-- Select records based on specific FUNCTIONS -----------------------------------
-- Get the total number of rows (records) in a table
SELECT COUNT(*) AS total_records FROM Books;

-- Get the most recent year in the records.
SELECT MAX(publication_year) AS most_recent_publication_year FROM Books;


-- Select records using EXPRESSION -----------------------------------------------

-- Combine the book title and the author of the book
SELECT 'Title: ' || title || ', Author: ' || author 
FROM Books; 


-- Using the alias (AS) keyword to rename tables
SELECT book.supplier_id, book.title FROM Books AS book; 



-- WHERE CLAUSE ==================================================================

-- CONDITIONAL OPERATORS ----------------------------------------------
-- EQUAL TO:
-- Filter records of books published in 2005
SELECT * 
FROM Books
WHERE publication_year = 2005;


-- NOT EQUAL TO:
-- Filter all books except those published in 2005
SELECT * 
FROM Books
WHERE publication_year != 2005; 

-- OR we can use ( <> instead of != )

SELECT * 
FROM Books
WHERE publication_year <> 2005; 


-- LESS THAN:
-- Filter records of books published before 2003.
SELECT title, author, publication_year 
FROM Books
WHERE publication_year < 2003;


-- LESS THAN OR EQUAL TO:
-- Filter records of books published before 2003 as well as in 2003.
SELECT title, author, publication_year 
FROM Books
WHERE publication_year <= 2003;


-- GREATER THAN:
--  Filter records of books published after 2003.
SELECT title, author, publication_year 
FROM Books
WHERE publication_year > 2003;


-- GREATER THAN OR EQUAL TO:
-- Filter the records of books published in 2003 and beyond.
SELECT title, author, publication_year 
FROM Books
WHERE publication_year >= 2003;


-- LOGICAL OPERATORS ------------------------------------------------------
-- AND:
-- Filter records of books that have a fiction genre and published in 1960.
SELECT title, genre, publication_year
FROM Books
WHERE genre = 'Fiction' AND publication_year = 1960;

-- OR:
-- Filter records of books that either have a fiction genre or were published in 1960.
SELECT title, genre, publication_year
FROM Books
WHERE genre = 'Fiction' OR publication_year = 1960;


-- NOT:
-- Filter records of books where the genre is not 'fiction'.
SELECT title, genre, publication_year
FROM Books
WHERE NOT genre = 'Fiction';


-- OTHER Important Clauses

-- BETWEEN: (Filter between a specified range.)
-- Filter records of books that were published between 1997 and 2003.
SELECT title, publication_year
FROM Books
WHERE publication_year BETWEEN 1997 AND 2003;


-- NOT BETWEEN: (Filter outside a specified range.)
-- Filter records of books that were not published between 1997 and 2003.
SELECT title, publication_year
FROM Books
WHERE publication_year NOT BETWEEN 1997 AND 2003;


-- NOT IN:
-- Filter all books except those with a 'fiction' or 'crime' genre.
SELECT title, genre
FROM Books
WHERE genre NOT IN ('Fiction', 'Crime');


-- LIKE:
-- Filter authors whose name start with 'S'
SELECT title, author
FROM Books 
WHERE author LIKE 'S%';

-- Filter authors whose name end with 'n'
SELECT title, author
FROM Books 
WHERE author LIKE '%n';


-- NOT LIKE:
-- Filter all authors whose name does not start with 'S'
SELECT title, author
FROM Books 
WHERE author NOT LIKE 'S%';

-- Filter all authors whose name does not end with 'n'
SELECT title, author 
FROM Books 
WHERE author NOT LIKE '%n';

-- IS NULL:
-- Filter records of return date with NULL values.
SELECT *
FROM Borrowings
WHERE return_date IS NULL;


-- IS NOT NULL:
-- Filter records of return date without NULL values.
SELECT * 
FROM Borrowings
WHERE return_date IS NOT NULL;

-- Combining Conditions --------------------------------------------------------
-- Retrieve all records from the books table where the books 
-- were published before the year 2000 OR the author's name begins with 'J' 
-- AND the book genre is 'Fantasy'.

-- First & Second condition
SELECT * 
FROM Books
WHERE publication_year < 2000 OR author LIKE 'J%';

-- Third condition
SELECT * 
FROM Books
WHERE genre = 'Fantasy';

SELECT title, author, genre, publication_year 
FROM Books
WHERE (publication_year < 2000 OR author LIKE 'J%') AND genre = 'Fantasy';


-- ORDER BY Statement ==============================================================
-- Change database to ProductOrderStatus

-- Sorting a single column ------------------------------------------
-- In ascending order
SELECT * FROM OrderStatus;

SELECT *
FROM OrderStatus
ORDER BY unit_price;

-- OR we can also include the ASC keyword

SELECT * 
FROM OrderStatus
ORDER BY unit_price ASC;


-- In descending order
SELECT * 
FROM OrderStatus
ORDER BY unit_price  DESC;


-- Sorting Multiple columns ----------------------------------------------
SELECT product_id, unit_price, sales
FROM OrderStatus
ORDER BY unit_price, sales;

SELECT unit_price, sales
FROM OrderStatus
ORDER BY unit_price, sales DESC;

SELECT unit_price, sales
FROM OrderStatus
ORDER BY unit_price DESC, sales DESC;


-- Using an Alias in ORDER BY ------------------------------------------
SELECT unit_price, unit_price + 5.2 AS adjusted_unit_price
FROM OrderStatus
ORDER BY adjusted_unit_price;


-- Sorting by Column Position ------------------------------------------
SELECT unit_price, order_quantity, sales
FROM OrderStatus
ORDER BY 1 DESC;


-- Aggregating Data ==========================================================
-- Get the summary statistics of sales
-- Without taking care of NULL values
SELECT 
	MIN(sales) minimum_sales,
	ROUND(AVG(sales)) average_sales,
	MAX(sales) maximum_sales,
	SUM(sales) total_sales
FROM OrderStatus;

-- After taking care of NULL values
SELECT sales, COALESCE(sales, 100.01) AS cleaned_sales FROM OrderStatus;

SELECT 
	MIN(COALESCE(sales, order_quantity * unit_price)) AS minimum_sales,
	ROUND(AVG(COALESCE(sales, order_quantity * unit_price))) AS average_sales,
	MAX(COALESCE(sales, order_quantity * unit_price)) AS maximum_sales,
	SUM(COALESCE(sales, order_quantity * unit_price)) AS total_sales
FROM OrderStatus;


-- CONDITIONAL STATEMENT =========================================================

-- Simple CASE Expression --------------------------------------
SELECT 
    product_id,
    CASE product_id
        WHEN 1 THEN 'Product One'
        WHEN 2 THEN 'Product Two'
        WHEN 3 THEN 'Product Three'
        WHEN 4 THEN 'Product Four'
        ELSE 'Unknown Product'
    END AS product_name
FROM OrderStatus;


-- Searched CASE Expression:
SELECT 
	order_quantity,
	CASE
		WHEN order_quantity > 5 THEN 'Above 5 Quantities'
		WHEN order_quantity < 5 THEN 'Below 5 Quantities'
		ELSE '5 Quantities'
	END AS grouped_order_quantity
FROM OrderStatus;


--- With Order By 
SELECT 
	order_quantity, order_status
FROM OrderStatus
ORDER BY 
	CASE 
		WHEN order_status = 'Completed' THEN 1
		WHEN order_status = 'Cancelled' THEN 0
		ELSE 3
	END;
