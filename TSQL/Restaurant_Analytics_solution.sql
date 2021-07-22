USE dannys_diner;
GO

-- 1) What is the total amount each customer spent at the restaurant?--
SELECT s.customer_id,
       SUM(m.price) AS total_spent
FROM sales AS s
    JOIN menu AS m
        ON s.product_id = m.product_id
GROUP BY customer_id;
GO

-- 2) How many days has each customer visited the restaurant?
SELECT customer_id,
       COUNT(DISTINCT order_date) AS count_visit
FROM sales
GROUP BY customer_id;
GO

-- 3) What was the first item(s) from the menu purchased by each customer?

SELECT s.customer_id,
       s.product_id,
       m.product_name,
       min(t1.order_d) order_date
FROM
(
    SELECT min(order_date) AS order_d
    FROM sales
    GROUP BY customer_id
) AS t1
    JOIN sales AS s
        ON t1.order_d = s.order_date
    JOIN menu AS m
        ON m.product_id = s.product_id
GROUP BY s.customer_id,
         s.product_id,
         m.product_name;
GO

-- 4) What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT TOP(1)
    s.product_id,
    COUNT(s.order_date) AS total_sold,
    m.product_name
FROM
    sales AS s
        JOIN
    menu AS m ON m.product_id = s.product_id
GROUP BY s.product_id , product_name
ORDER BY total_sold DESC;
GO


-- 5) Which item(s) was the most popular for each customer?
WITH favourite_rank
AS (SELECT s.customer_id,
           COUNT(s.product_id) AS product_count,
           m.product_name,
           RANK() OVER (PARTITION BY s.customer_id ORDER BY count(s.product_id) DESC) AS rank
    FROM sales AS s
        JOIN menu AS m
            ON s.product_id = m.product_id
    GROUP BY s.customer_id,
             m.product_name
   )
SELECT customer_id,
       product_name,
       product_count
FROM favourite_rank
where rank = 1;
GO



-- 6 ) Which item was purchased first by the customer after they became a member and what date was it? (including the date they joined)
WITH members_details
AS (SELECT s.*,
           mbr.join_date,
           m.product_name,
           rank() over (partitiON by s.customer_id order by order_date) AS order_rank
    FROM sales AS s
        JOIN members AS mbr
            ON s.customer_id = mbr.customer_id
        JOIN menu AS m
            ON m.product_id = s.product_id
    WHERE s.order_date >= mbr.join_date
   )
SELECT customer_id,
       order_date,
       join_date,
       product_id,
       product_name
FROM members_details
WHERE order_rank = 1;

GO

-- 7) Which menu item(s) was purchased just before the customer became a member and when?
WITH members_details
AS (SELECT s.*,
           mbr.join_date,
           m.product_name,
           rank() over (partitiON by s.customer_id order by order_date DESC) AS order_rank
    FROM sales AS s
        JOIN members AS mbr
            ON s.customer_id = mbr.customer_id
        JOIN menu AS m
            ON m.product_id = s.product_id
    WHERE s.order_date < mbr.join_date
   )
SELECT customer_id,
       order_date,
       join_date,
       product_id,
       product_name
FROM members_details
WHERE order_rank = 1;
GO

-- 8) What is the number of unique menu items and total amount spent for each member before they became a member?
SELECT s.customer_id,
       COUNT(s.product_id) AS item_purchased_prior_to_membership,
       SUM(m.price) AS total_spent_prior_to_membership
FROM sales AS s
    LEFT JOIN menu AS m
        ON s.product_id = m.product_id
    LEFT JOIN members AS mbr
        ON s.customer_id = mbr.customer_id
WHERE s.order_date < mbr.join_date
GROUP BY s.customer_id;
GO


-- 9) If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT s.customer_id,
       SUM(   CASE
                  WHEN s.product_id = 1 THEN
                      m.price * 20
                  ELSE
                      m.price * 10
              END
          ) AS points
FROM sales AS s
    JOIN menu AS m
        ON m.product_id = s.product_id
GROUP BY customer_id ORDER BY points DESC;
GO





-- 10) In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

SELECT s.customer_id,
       sum(   CASE
                  WHEN s.product_id <> 1
                       and s.order_date < mbr.join_date THEN
                      price * 10
                  ELSE
                      m.price * 20
              END
          ) AS point_table
FROM sales AS s
    JOIN menu AS m
        ON m.product_id = s.product_id
    JOIN members AS mbr
        ON mbr.customer_id = s.customer_id
GROUP BY s.customer_id;
GO