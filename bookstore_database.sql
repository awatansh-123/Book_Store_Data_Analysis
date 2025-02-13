create database bookstore1;
use  bookstore1;

create table books (
Book_ID serial primary key,
Title varchar(150),
Author varchar(100),
Genre varchar(50),
Published_Year int,
Price numeric(10,2),
Stock int
);

create table customers(
Customer_ID serial primary key,
Name varchar(100),
Email varchar(100),
Phone varchar(50),
City varchar(50),
Country varchar(100)
);

create table orders(
Order_ID serial primary key,
Customer_ID int references customers(Customers_ID),
Book_ID int references books(Book_ID),
Order_Date date,
Quantity int,
Total_Amount numeric(10,2)
);

select * from books;
select * from customers;
select * from orders;

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Books.csv"
into table books
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customers.csv"
into table customers
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Orders.csv"
into table orders
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

-- 1)retrieve all books in the 'Fiction' Genre:
select * from books where Genre='Fiction';

-- 2) find books published after 1950:
select * from books where Published_Year > 1950;

-- 3) List all customers from Canada:
select * from customers where Country='Canada';

-- 4) Show orders placed in November 2023:
select * from orders where Order_Date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:
select sum(Stock) as totalStock from books ;

-- 6) Find details of most expensive book:
select * from books order by Price desc limit 1;

-- 7) show customers who ordered more than 1 quantity of books
select * from orders where Quantity > 1;

-- 8) List all genres available in books table:
select distinct Genre from books;

-- 9) Find the book with lowest stock:
select * from books order by Stock limit 1;

-- 10) Calculate the total revenue generated from all orders:
select sum(Total_Amount) from orders; 

-- Advance Queries:
-- 1) Retrieve the total number of books sold for each genre:
select b.Genre , sum(o.Quantity) as total_number_sold
 from orders o join books b 
 on o.Book_Id=b.Book_Id 
 group by b.Genre;

-- 2) Find the average price of book in the 'Fantasy' genre:
select avg(Price) from books where Genre='Fantasy';

-- 3) list customers who have placed atleast 2 orders:
select c.Name,o.Customer_ID,count(o.Order_Id) as order_count from orders o 
join customers c
on o.Customer_ID = c.Customer_ID 
group by o.Customer_ID,c.Name
having count(Order_ID) >=2;

-- 4) Most frequently ordered book:
select o.Book_ID ,b.title, count(o.Order_ID) as order_count from orders o
join books b on o.Book_ID= b.Book_ID
group by o.Book_Id , b.Title
order by order_count desc limit 1;

-- 5) show the top three most expensive books of 'Fantasy' Genre:
select * from books where Genre='Fantasy' order by Price desc limit 3 ;

-- 6) Retrieve the total quantity of books sold by each author:
select b.Author, sum(o.Quantity) as total_quantity from orders o
join books b on b.Book_ID=o.Book_ID
group by b.Author;

-- 7) list the cities where customers who spent over $30 are located:
select distinct c.City,Total_Amount from orders o 
join customers c on c.Customer_ID = o.Customer_ID
where o.Total_Amount > 30 ;

-- 8) find the customers who spent most on orders:
select c.Name,sum(o.Total_Amount) as Total_Spent from orders o
join customers c on c.Customer_ID=o.Customer_ID
group by c.Name
order by Total_Spent desc limit 1;

-- 9) calculate the stock remaining after fulfilling all orders:
select b.Book_ID,b.Title,b.Stock,coalesce(sum(Quantity),0) as order_quantity , b.Stock - coalesce(sum(o.Quantity),0) as remaining_quantity
from books b
left join orders o on b.Book_ID=o.Book_ID
group by b.Book_ID
order by b.Book_ID; 
