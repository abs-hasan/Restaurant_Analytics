-- CREATE DATABASE
CREATE DATABASE dannys_diner;
GO

-- Select Database
USE dannys_diner;
GO


-- CREATE TABLE
CREATE TABLE sales (customer_id VARCHAR(1) NOT NULL , order_date DATE NOT NULL, product_id INT NOT NULL FOREIGN KEY REFERENCES menu (product_id)  );
GO

CREATE TABLE menu (product_id INT PRIMARY KEY NOT NULL, product_name VARCHAR(5) NOT NULL, price  decimal(10,2) NOT NULL);
GO

CREATE TABLE members (customer_id VARCHAR(1) PRIMARY KEY,join_date DATE NOT NULL);
GO

---- INSERT VALUES -----
INSERT INTO sales VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
GO

INSERT INTO menu (product_id, product_name, price) VALUES ('1', 'sushi', '10'), ('2', 'curry', '15'), ('3', 'ramen', '12');
GO

INSERT INTO members (customer_id, join_date) VALUES ('A', '2021-01-07'), ('B', '2021-01-09');
GO




-- Checking all tables

SELECT * FROM INFORMATION_SCHEMA.TABLES;
GO

SELECT TOP (5) * FROM sales;
GO

SELECT * FROM menu;
GO

SELECT * FROM members;
GO


--  Describe TABLE
EXEC SP_COLUMNS sales;
GO

EXEC SP_COLUMNS menu;
GO

EXEC SP_COLUMNS members;
GO




