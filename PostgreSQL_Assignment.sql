-- Active: 1742315199235@@127.0.0.1@5432@bookstore_db



-- 1. Create Books Table
CREATE TABLE books(
id SERIAL PRIMARY KEY,
title VARCHAR(200),
author VARCHAR(100),
price DECIMAL(8, 2) CHECK (price > 0),
stock INT,
published_year INT
);

-- INSERT BOOK DATA
INSERT INTO books(title, author, price, stock, published_year)
VALUES
('The Pragmatic Programmer', 'Andrew Hunt', 40.00 , 10, 1999),
('Clean Code', 'Robert C. Martin', 35.00 , 5, 2008),
('You Dont Know JS', 'Kyle Simpson', 30.00  , 8, 2014),
('Refactoring', 'Martin Fowler', 50.00  , 3, 1999),
('Database Design Principles', 'Jane Smith ', 20.00  , 0, 2018);

-- Get All Book Data
SELECT * FROM books;



-- 2. Create Customers Table
CREATE TABLE customers(
    id SERIAL PRIMARY KEY,
    name VARCHAR(150),
    email VARCHAR(150) UNIQUE,
    joined_date DATE DEFAULT CURRENT_DATE
);

-- INSERT Customers DATA
INSERT INTO customers(name, email, joined_date)
VALUES
('Alice', 'alice@email.com', '2023-01-10'),
('Bob', 'bob@email.com', '2022-05-15'),
('Charlie', 'charlie@email.com', ' 2023-06-20')

-- Get All Coustomers
SELECT * FROM customers;

-- 3. Create Order Table
CREATE TABLE orders(
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    book_id INT REFERENCES books(id),
    quantity INTEGER CHECK (quantity > 0),
    order_date TIMESTAMP DEFAULT now()
);


-- Insert Order Data
INSERT INTO orders(customer_id, book_id, quantity, order_date)
VALUES
(1,2,1,'2024-03-10'),
(2,1,1,'2024-02-20'),
(1,3,2,'2024-03-05');

-- Get All Orders
SELECT * FROM orders;


-- 📂 PostgreSQL Problems & Sample Outputs 


-- 1. Find books that are out of stock.
SELECT title FROM books
WHERE stock =0;

-- 2. Retrieve the most expensive book in the store.
SELECT * FROM books 
ORDER BY price DESC
LIMIT (1)

-- 3. Find the total number of orders placed by each customer.
SELECT customers.name, COUNT(orders.id) as total_orders FROM customers
JOIN orders on customers.id= orders.customer_id
GROUP BY customers.name;


--  4. Calculate the total revenue generated from book sales.
SELECT SUM(books.price * orders.quantity ) as total_revenue FROM orders
JOIN books ON orders.book_id= books.id;



-- 5. List all customers who have placed more than one order.
SELECT customers.name, COUNT(orders.id) as orders_count FROM customers
JOIN orders ON customers.id=orders.customer_id
GROUP BY customers.name
HAVING COUNT(orders.id) > 1

-- 6. Find the average price of books in the store.
SELECT ROUND(AVG(price), 2) as avg_book_price FROM books;

-- 7. Increase the price of all books published before 2000 by 10%.
UPDATE books
SET price = price * 1.10
WHERE published_year <2000;

-- 8. Delete customers who haven't placed any orders.
DELETE FROM customers
WHERE id NOT IN(SELECT customer_id FROM orders GROUP BY customer_id);