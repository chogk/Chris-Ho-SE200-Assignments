DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS borrowers;

-- Task 1: Create Table
-- 1. Create a table books with the following structure:
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(50) NOT NULL,
    publication_year INTEGER,
    isbn VARCHAR(13) UNIQUE,
    price DECIMAL(8,2),
    stock INTEGER
);

-- 2. Create a table borrowers with the following structure:
CREATE TABLE borrowers (
    borrower_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    registration_date DATE
);

---------------------------------------------------------------------------------------------

-- Task 2: Insert Data
-- 1. Insert the following content into the books table:
INSERT INTO books (title, author, publication_year, isbn, price, stock )
VALUES
	('To Kill a Mockingbird','Harper Lee',1960, '9780446310789', 12.99, 5),
    ('1984','George Orwell',1949, '9780451524935', 9.99, 8),
    ('Pride and Prejudice', 'Jane Austen',1813,'9780141439518',7.99,10),
    ('The Great Gatsby','F.Scott Fitzgerald',1925, '9780743273565',11.99,6),
    ('One Hundred Years of Solitude','Gabriel Garcia Marquez',1967,'9780060883287',14.99,4),
    ('The Catcher in the Rye', 'J.D.Salinger',1951,'9780316769174',8.99,7),
    ('To the Lighthouse','Virginia Woolf',1927,'9780156907392', 10.99,3),
    ('Brave New World','Aldous Huxley', 1932, '9780060850524', 11.99,5),
    ('The Hobbit','J.R.R. Tolkien',1937,'9780261102217', 13.99,9),
    ('Fahrenheit 451','Ray Bradbury',1953,'9781451673319',3.99,6)

-- 2. Insert the following content into the borrowers table:
INSERT INTO borrowers (first_name, last_name, email, registration_date )
VALUES
	('John','Doe','john.doe@email.com','2024-01-15'),
	('Jane', 'Smith','jane.smith@email.com','2024-02-03'),
	('Michael', 'Johnson','michael.j@email.com', '2024-01-22'),
	('Emily','Brown','emily.brown@email.com', '2024-03-10'),
	('David', 'Wilson','david.wilson@email.com', '2024-02-18'),
	('Sarah', 'Taylor', 'sarah.t@email.com','2024-01-30'),
	('Robert', 'Anderson','robert.a@email.com', '2024-03-05'),
	('Lisa','Martinez','lisa.m@email.com', '2024-02-12'),
	('William','Thomas','william.t@email.com', '2024-01-19'),
	('Jennifer','Garcia','jennifer.g@email.com','2024-03-01')

---------------------------------------------------------------------------------------------
  
-- Task 3: Basic Queries
-- 1. Select all books published after 1950
SELECT *
FROM books
WHERE publication_year > 1950;

-- 2. List all borrowers who registered in 2024 
SELECT * 
FROM borrowers
WHERE EXTRACT(YEAR FROM registration_date) = 2024;

-- 3. Find the total number of books in stock
SELECT sum(stock) AS total_stock
FROM books;

-- 4. Display the full names of all borrowers
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM borrowers;

---------------------------------------------------------------------------------------------

-- Task 4: Calculated Columns and String Functions
-- 1. Calculate the total value of inventory for each book (price * stock)
SELECT 
    title,
    TO_CHAR(price * stock, 'FM999999999.00') AS inventory_value
FROM books

-- 2. Concatenate the author's name with the book title
SELECT CONCAT(author,': ', title) AS author_title
FROM books;

-- 3. Convert all book titles to uppercase
SELECT UPPER(title) AS uppercase_title
FROM books;

---------------------------------------------------------------------------------------------

-- Task 5: Filtering and Comparison
-- 1. Find all books with a price between $10 and $20
SELECT * 
FROM books
WHERE price > 10 AND price < 20;

-- 2. List borrowers whose last name starts with 'S'
SELECT * 
FROM borrowers
WHERE LOWER(last_name) like 's%';

-- 3. Identify books with less than 5 items in stock
SELECT * 
FROM books
WHERE stock < 5;

---------------------------------------------------------------------------------------------

-- Task 6: Compound Clauses
-- 1. Find books published before 1960 with a price less than $10
SELECT * 
FROM books
WHERE publication_year < 1960 and price <10;

-- 2.List borrowers who registered in 2024 and have an email ending with '@email.com'.
SELECT * 
FROM borrowers
WHERE EXTRACT(YEAR FROM registration_date) = 2024 
AND LOWER(email) LIKE '%@email.com';

---------------------------------------------------------------------------------------------

-- Task 7
-- Update and Delete
-- Increase the price of all books by 10% and show all columns



-- Remove all borrowers who registered before 2023.
DELETE FROM borrowers
WHERE registration_date < '2023-01-01';

---------------------------------------------------------------------------------------------

-- Task 8: Order By, Limit And Offset
-- 1. List the 5 most expensive books
SELECT * 
FROM books
ORDER BY price DESC 
LIMIT 5;

-- 2. Display the 3rd to 7th most recently registered borrowers
SELECT *
FROM borrowers
ORDER BY registration_date DESC
OFFSET 2  -- Skips the first 2 most recent borrowers
LIMIT 5;  -- Retrieves the next 5 borrowers (3rd to 7th most recent)

---------------------------------------------------------------------------------------------

-- Task 9: Group by and Having
-- 1. Count the number of books by each author, only showing authors with more than 2 books.
SELECT author, COUNT(*) AS book_count
FROM books
GROUP BY author
HAVING COUNT(*) > 2;

-- 2. Calculate the average price of books for each publication year, only for years with more than 3 books.
SELECT publication_year, ROUND(AVG(price), 2) AS avg_price
FROM books
GROUP BY publication_year
HAVING COUNT(*) > 3;
