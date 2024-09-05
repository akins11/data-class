-- CREATE DATABASE ============================================================
-- Create the Library database
CREATE DATABASE LibraryDB;

-- DROP DATABASE ===============================================================
-- Remove the database completely.
DROP DATABASE LibraryDB;


-- CREATE TABLES ===============================================================
-- Create Supplier table
CREATE TABLE Supplier (
	supplier_id SERIAL PRIMARY KEY,
	supplier_name VARCHAR(100) NOT NULL,
	contact_person VARCHAR(100) NOT NULL,
	email VARCHAR(255),
	phone VARCHAR(100) NOT NULL,
	address VARCHAR(255) NOT NULL
);


-- Create the Books table
CREATE TABLE Books (
	book_id SERIAL PRIMARY KEY,
	supplier_id INT NOT NULL,
	title VARCHAR(255) NOT NULL,
	author VARCHAR(100) NOT NULL,
	genre VARCHAR(50),
	publication_year INT,
	isbn VARCHAR(13) UNIQUE NOT NULL,
	FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);

-- Create the Members table
CREATE TABLE Members (
	member_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	address VARCHAR(255),
	contact_number VARCHAR(20),
	membership_type VARCHAR(20) CHECK (membership_type IN ('Standard', 'Premium', 'Student'))
);


-- Create the Borrowings table
CREATE TABLE Borrowings (
	borrowing_id SERIAL PRIMARY KEY,
	book_id INT NOT NULL,
	member_id INT NOT NULL,
	borrow_date DATE NOT NULL,
	due_date DATE NOT NULL,
	return_date DATE,
	FOREIGN KEY (book_id) REFERENCES books(book_id),
	FOREIGN KEY (member_id) REFERENCES members(member_id)
);


-- SQL table manipulation =============================================================
-- Add a new column to an existing table -----------------------------
ALTER TABLE Books
  ADD price FLOAT;

-- (optional) Check
SELECT * FROM Books;


-- Deleting columns in an exisiting table ----------------------------
ALTER TABLE Books
  DROP COLUMN price;

-- (optional) Check
SELECT * FROM Books; 


-- INSERT RECORDS ==================================================================
-- Insert sample data into supplier table
INSERT INTO Supplier (supplier_name, contact_person, email, phone, address)
VALUES
('BookWorld Inc.', 'John Smith', 'john@bookworld.com', '555-1234', '123 Book St, Reading, TX'),
('Literary Distributors', 'Emily Brown', 'emily@litdist.com', '555-5678', '456 Novel Ave, Literacy, CA'),
('Novel Supplies Co.', 'Michael Johnson', 'michael@novelsupplies.com', '555-9012', '789 Story Rd, Plotville, NY'),
('Bookworm Wholesalers', 'Sarah Davis', 'sarah@bookworm.com', '555-3456', '321 Chapter Ln, Bookmark, FL'),
('Page Turner Providers', 'David Wilson', 'david@pageturner.com', '555-7890', '654 Page Blvd, Spine City, WA');

-- (Optional) Check
SELECT * FROM Supplier;


-- Insert sample data into Books table
INSERT INTO Books (supplier_id, title, author, genre, publication_year, isbn)
VALUES 
(1, 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, '9780446310789'),
(3, '1984', 'George Orwell', 'Science Fiction', 1949, '9780451524935'),
(5, 'Pride and Prejudice', 'Jane Austen', 'Romance', 1813, '9780141439518'),
(4, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 1925, '9780743273565'),
(1, 'The Catcher in the Rye', 'J.D. Salinger', 'Fiction', 1951, '9780316769174'),
(5, 'The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 1937, '9780547928227'),
(2, 'Harry Potter and the Philosopher''s Stone', 'J.K. Rowling', 'Fantasy', 1997, '9780747532699'),
(4, 'The Da Vinci Code', 'Dan Brown', 'Thriller', 2003, '9780307474278'),
(5, 'The Hunger Games', 'Suzanne Collins', 'Young Adult', 2008, '9780439023481'),
(3, 'The Girl with the Dragon Tattoo', 'Stieg Larsson', 'Crime', 2005, '9780307454546');

-- (Optional) Check
SELECT * FROM Books;


-- Insert sample data into Members table
INSERT INTO Members (first_name, last_name, address, contact_number, membership_type)
VALUES 
('John', 'Doe', '123 Main St, Anytown, USA', '555-1234', 'Standard'),
('Jane', 'Smith', '456 Elm St, Somewhere, USA', '555-5678', 'Premium'),
('Alice', 'Johnson', '789 Oak St, Nowhere, USA', '555-9012', 'Student'),
('Bob', 'Williams', '321 Pine St, Everywhere, USA', '555-3456', 'Standard'),
('Emily', 'Brown', '654 Maple St, Anywhere, USA', '555-7890', 'Premium'),
('Michael', 'Davis', '987 Cedar St, Someplace, USA', '555-2345', 'Student'),
('Sarah', 'Miller', '159 Birch St, Othertown, USA', '555-6789', 'Standard'),
('David', 'Wilson', '753 Walnut St, Thisplace, USA', '555-0123', 'Premium'),
('Lisa', 'Moore', '951 Cherry St, Thatplace, USA', '555-4567', 'Student'),
('James', 'Taylor', '357 Ash St, Lastplace, USA', '555-8901', 'Standard');

-- (Optional) Check
SELECT * FROM Members;


-- Insert sample data into Borrowings table
INSERT INTO Borrowings (book_id, member_id, borrow_date, due_date, return_date)
VALUES 
(1, 3, '2024-08-01', '2024-08-15', '2024-08-14'),
(2, 5, '2024-08-02', '2024-08-16', NULL),
(3, 1, '2024-08-03', '2024-08-17', '2024-08-16'),
(4, 7, '2024-08-04', '2024-08-18', NULL),
(5, 2, '2024-08-05', '2024-08-19', '2024-08-18'),
(6, 9, '2024-08-06', '2024-08-20', NULL),
(7, 4, '2024-08-07', '2024-08-21', '2024-08-20'),
(8, 10, '2024-08-08', '2024-08-22', NULL),
(9, 6, '2024-08-09', '2024-08-23', '2024-08-22'),
(10, 8, '2024-08-10', '2024-08-24', NULL);

-- (Optional) Check
SELECT * FROM Borrowings;


-- Updating data ==================================================================
-- Update a single value -------------------------------------------
SELECT * FROM Members;

-- Update a member's membership type
UPDATE Members
SET membership_type = 'Premium'
WHERE member_id = 3;

-- (Optional) Check
SELECT * FROM Members;

-- Update multiple values -------------------------------------------
SELECT * FROM Supplier;

UPDATE Supplier
SET phone = '555-1010'
WHERE supplier_id IN (1, 4);

-- (Optional) Check
SELECT * FROM Supplier;

-- Update all records -------------------------------------------------
UPDATE Supplier
SET phone = '555-2020';

-- (Optional) Check
SELECT * FROM Supplier;


-- DELETE data ======================================================================
-- Create temporary table
CREATE TABLE TempTable (
    temp_id SERIAL PRIMARY KEY,
    temp_name VARCHAR(100) NOT NULL,
    temp_price FLOAT
);

-- Insert sample data into the temporary table
INSERT INTO TempTable (temp_name, temp_price)
VALUES 
	('John', 101.45),
	('Mary', 102.58),
	('Benjamin', 108.45),
	('Paul', 108.45),
	('Alice', 108.45),
	('Tom', 107.45);

-- (Optional) Check
SELECT * FROM TempTable;


-- Delete a single record ----------------------------------
DELETE FROM TempTable
WHERE temp_id = 3;

-- (Optional) Check
SELECT * FROM TempTable;


-- Delete multiple all records -----------------------------
DELETE FROM TempTable
WHERE temp_id IN (1, 4);

-- (Optional) Check
SELECT * FROM TempTable;


-- Delete all records ---------------------------------------
DELETE FROM TempTable;

-- (Optional) Check
SELECT * FROM TempTable;

-- DELETE TABLES in a database ======================================================
-- Without Foreign Keys ----------------------------------------
-- (Optional) Check
SELECT * FROM TempTable;

-- Drop the temporary table
DROP TABLE TempTable;



-- With Foreign Keys --------------------------------------------
DROP TABLE Supplier;   -- Returns an error..

DROP TABLE Supplier CASCADE;


-- Drop foreign key constraint in the referencing table

-- Query to find all constraints on the 'borrowings' table
SELECT
    conname AS constraint_name,
    contype AS constraint_type,
    conrelid::regclass AS table_name,
    a.attname AS column_name,
    confrelid::regclass AS referenced_table,
    af.attname AS referenced_column
FROM
    pg_constraint AS c
    JOIN pg_attribute AS a ON a.attnum = ANY(c.conkey) AND a.attrelid = c.conrelid
    JOIN pg_attribute AS af ON af.attnum = ANY(c.confkey) AND af.attrelid = c.confrelid
WHERE
    conrelid = 'borrowings'::regclass;


ALTER TABLE Borrowings DROP CONSTRAINT borrowings_book_id_fkey;

-- Then drop the table
DROP TABLE Books;
