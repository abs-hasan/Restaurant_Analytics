

---

**_1) What is the total amount each customer spent at the restaurant?_**

---

```sql
SELECT s.customer_id,
       SUM(m.price) AS total_spent
FROM sales AS s
    JOIN menu AS m
        ON s.product_id = m.product_id
GROUP BY customer_id;
GO
```

> **Results**

<table style="width:100%">
  <tr>
    <th>customer_id</th>
    <th>total_spent</th> 
  </tr>
  <tr>
    <td>A</td>
    <td>76.00</td>
  </tr>
  <tr>
    <td>B</td>
    <td>74.00</td>
  </tr>
  <tr>
    <td>C</td>
    <td>36.00</td>
  </tr>
</table>

---

**_2) How many days has each customer visited the restaurant?_**

---

```sql
SELECT customer_id,
       COUNT(DISTINCT order_date) AS count_visit
FROM sales
GROUP BY customer_id;
GO
```

> **Results**

| Command | count_visit |
| --- | --- |
| A | 4 |
| B | 6 |
| C | 2 |

---

**_3) What was the first item from the menu purchased by each customer?_**

---

```sql
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
GO```

> **Results**


| customer_id | product_id | product_name	| order_date |
|---|---|---|---|
| A	| 1	| sushi	| 2021-01-01 | 
| A	| 2	| curry	| 2021-01-01 | 
| B	| 2	| curry	| 2021-01-01 | 
| C	| 3	| ramen	| 2021-01-01 | 

---

**_4) What is the most purchased item on the menu and how many times was it purchased by all customers?_**

---

```sql
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
```

> **Results**

| product_id | total_sold	| product_name |
| --- | --- | --- |
| 3	| 8	| ramen	| 

---

**_5 ) Which item was the most popular for each customer?_**

---

```sql
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
```

> **Results**

| customer_id	| product_name | product_count| 
| --- | --- | --- |
| A	| ramen	| 3 | 
| B	| sushi	| 2 | 
| B	| curry	| 2 | 
| B	| ramen	| 2 | 
| C	| ramen	| 3 | 

---

**_6 ) Which item was purchased first by the customer after they became a member and what date was it? (including the date they joined)_**

---

```sql
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

```

> **Results**

| customer_id |	order_date|	join_date |	product_id |	product_name |
| --- | --- | --- | --- | --- |
| A |	2021-01-01 |	2021-01-07	| 1	| sushi |
| A |	2021-01-01 |	2021-01-07	| 2	| curry |
| B |	2021-01-04 |	2021-01-09	| 1	| sushi |

---

**_7) Which menu item(s) was purchased just before the customer became a member and when?_**

---

```sql
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
```

> **Results**

| customer_id |	order_date |	join_date |	product_id | product_name |
|---|---|---|---|---|
| A | 2021-01-01 | 2021-01-07 |	1	|	sushi |
| A	| 2021-01-01 | 2021-01-07	|	2	|	curry |
| B	| 2021-01-04 | 2021-01-09	|	1	|	sushi |

---

**_8) What is the number of unique menu items and total amount spent for each member before they became a member?_**

---
```sql
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
```

> **Results**

| customer_id | 	item_purchased_prior_to_membership | total_spent_prior_to_membership |
|---|---|---|
| A	| 2	| 25.00| 
| B	| 3	| 40.00| 

---

**_9) If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?_**

---

```sql
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
```

> **Results**

| customer_id	| points| 
|---|---|
| B	| 940.00| 
| A	| 860.00| 
|C	|360.00|

---

**_10) In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
not just sushi - how many points do customer A and B have at the end of January?_**

---

```sql
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
```

> **Results**

|customer_id	|point_table|
|---|---|
|A	|1370.00|
|B	|1180.00
