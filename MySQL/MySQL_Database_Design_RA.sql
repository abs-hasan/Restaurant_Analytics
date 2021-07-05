-- CREATE DATABASE
CREATE DATABASE dannys_diner;

-- Select DATABASE
USE dannys_diner;

-- CREATE TABLE
CREATE TABLE sales (customer_id VARCHAR(1) NOT NULL , order_date DATE NOT NULL, product_id INT NOT NULL, FOREIGN KEY (product_id) REFERENCES menu (product_id)  );
CREATE TABLE menu (product_id INT PRIMARY KEY NOT NULL, product_name VARCHAR(5) NOT NULL, price  decimal(10,2) NOT NULL);
CREATE TABLE members (customer_id VARCHAR(1) PRIMARY KEY,join_date DATE NOT NULL);


---- INSERT VALUES -----
INSERT INTO sales VALUES
  ('A', '2021-01-01', '1'), ('A', '2021-01-01', '2'),  ('A', '2021-01-07', '2'),  ('A', '2021-01-10', '3'),  
  ('A', '2021-01-11', '3'), ('A', '2021-01-11', '3'),  ('B', '2021-01-01', '2'),  ('B', '2021-01-02', '2'),  
  ('B', '2021-01-04', '1'), ('B', '2021-01-11', '1'),  ('B', '2021-01-16', '3'),  ('B', '2021-02-01', '3'),  
  ('C', '2021-01-01', '3'), ('C', '2021-01-01', '3'),  ('C', '2021-01-07', '3');

INSERT INTO menu (product_id, product_name, price) VALUES ('1', 'sushi', '10'), ('2', 'curry', '15'), ('3', 'ramen', '12');
INSERT INTO members (customer_id, join_date) VALUES ('A', '2021-01-07'), ('B', '2021-01-09');


-- Checking Table -- 
SELECT * FROM sales limit 5;
SELECT * FROM menu;
SELECT * FROM members;


-- Describe table -- 
DESCRIBE sales;
DESCRIBE menu;
DESCRIBE members;
