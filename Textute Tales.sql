--1. Total quantity sold for all products
SELECT SUM(qty) AS total_quantity_sold
FROM sales;

--2. Total generated revenue for all products before discounts
-- Revenue = quantity * price
SELECT SUM(qty * price) AS total_revenue_before_discounts
FROM sales;

--3. Total discount amount for all products
-- Discount amount per row = qty * price * discount / 100
SELECT SUM(qty * price * discount / 100.0) AS total_discount_amount
FROM sales;

--4. Number of unique transactions
SELECT COUNT(DISTINCT txn_id) AS unique_transactions
FROM sales;

--5. Average unique products purchased in each transaction
SELECT AVG(product_count) AS avg_unique_products_per_transaction
FROM (
  SELECT txn_id, COUNT(DISTINCT prod_id) AS product_count
  FROM sales
  GROUP BY txn_id
) AS txn_products;

--6. Average discount value per transaction
SELECT AVG(total_discount) AS avg_discount_per_transaction
FROM (
  SELECT txn_id, SUM(qty * price * discount / 100.0) AS total_discount
  FROM sales
  GROUP BY txn_id
) AS txn_discounts;

--7. Average revenue for member and non-member transactions
SELECT member,
       AVG(qty * price) AS avg_revenue
FROM sales
GROUP BY member;

--8. Top selling product for each segment (by quantity)
SELECT segment_name, product_id, product_name, total_qty
FROM (
  SELECT pd.segment_name, s.prod_id AS product_id, pd.product_name,
         SUM(s.qty) AS total_qty,
         RANK() OVER (PARTITION BY pd.segment_name ORDER BY SUM(s.qty) DESC) AS rank
  FROM sales s
  JOIN product_details pd ON s.prod_id = pd.product_id
  GROUP BY pd.segment_name, s.prod_id, pd.product_name
) ranked
WHERE rank = 1;

--9. Total quantity, revenue, and discount for each category
SELECT pd.category_name,
       SUM(s.qty) AS total_qty,
       SUM(s.qty * s.price) AS total_revenue,
       SUM(s.qty * s.price * s.discount / 100.0) AS total_discount
FROM sales s
JOIN product_details pd ON s.prod_id = pd.product_id
GROUP BY pd.category_name;

--10. Top selling product for each category (by quantity)
SELECT category_name, product_id, product_name, total_qty
FROM (
  SELECT pd.category_name, s.prod_id AS product_id, pd.product_name,
         SUM(s.qty) AS total_qty,
         RANK() OVER (PARTITION BY pd.category_name ORDER BY SUM(s.qty) DESC) AS rank
  FROM sales s
  JOIN product_details pd ON s.prod_id = pd.product_id
  GROUP BY pd.category_name, s.prod_id, pd.product_name
) ranked
WHERE rank = 1;