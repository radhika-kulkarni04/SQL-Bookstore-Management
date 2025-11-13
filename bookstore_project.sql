CREATE DATABASE OnlineBookstore;

-- Created Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:/sql project-1/Books.csv'
DELIMITER ',' CSV HEADER;


-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'C:/sql project-1/Customers.csv'
DELIMITER ',' CSV HEADER;


-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'C:/sql project-1/Orders.csv'
DELIMITER ',' CSV HEADER;



-- 1) Retrieve all books in the "Fiction" genre:

SELECT* from books
WHERE genre ='Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM books
where published_year>1950;

-- 3) List all customers from the New zealand
SELECT * from customers 
WHERE country = 'New Zealand'

-- 4) Show orders placed in November 2023:
SELECT* from orders
where order_date BETWEEN '2023-11-01' AND '2023-11-30'

-- 5) Retrieve the total stock of books available:
SELECT sum(stock)
from books

-- 6) Find the details of the most expensive book:
select price from books
order by price DESC LIMIT 1

-- 7) Show all customers who ordered more than 1 quantity of a book:

SELECT* from orders
where quantity >1

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders 
where total_amount>20

-- 9) List all genres available in the Books table:
select distinct books.genre
from books;

-- 10) Find the book with the lowest stock:
select *
from books 
ORDER by stock ASC
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:

SELECT
sum(total_amount) as total_revenue_gen
FROM orders;

-- Advance Queries: 

-- 1) Retrieve the total number of books sold for each genre:

SELECT * FROM ORDERS;
SELECT* FROM BOOKS;

SELECT b.genre,
SUM(o.quantity) as total_sold_books
FROM orders as o
JOIN books as b
ON b.book_id= o.book_id
GROUP by b.genre
-- 2) Find the average price of books in the "Fantasy" genre:

SELECT 
round(avg(price),2) AS Avg_price
FROM books
WHERE genre ='Fantasy'

-- 3) List customers who have placed at least 2 orders:
SELECT o.customer_id ,c.name,count(o.order_id) as total_count
FROM orders as o
join customers as c
on o.customer_id=c.customer_id
group by o.customer_id,c.name
HAVING count(o.order_id)>=2;

-- 4) Find the most frequently ordered book:
SELECT o.Book_id, b.title, COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY ORDER_COUNT DESC LIMIT 1;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM books
WHERE genre ='Fantasy'
ORDER BY price DESC LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT b.author,sum(o.quantity) as total_books_sold
FROM orders o
JOIN books b
ON b.book_id = o.book_id
GROUP by b.author


-- 7) List the cities where customers who spent over $30 are located:
SELECT c.city, o.total_amount as amt_spent
FROM customers as c
JOIN orders as o
ON c.customer_id = o.customer_id
WHERE o.total_amount>30 ;



-- 8) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;



--9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;
