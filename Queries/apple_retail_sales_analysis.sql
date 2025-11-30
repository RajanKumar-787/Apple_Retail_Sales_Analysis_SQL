-- Apple Retails Millions Rows Sales Schemas

-- DROP TABLE commands

DROP TABLE IF EXISTS warranty;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS category; -- parent
DROP TABLE IF EXISTS stores; -- parent

-- CREATE TABLE commands

CREATE TABLE stores
(
store_id VARCHAR(5) PRIMARY KEY,
store_name VARCHAR(30),
city VARCHAR(25),
country VARCHAR(25)
);

CREATE TABLE category
(
category_id VARCHAR(10) PRIMARY KEY,
category_name VARCHAR(20)
);

CREATE TABLE products
(
product_id VARCHAR(10) PRIMARY KEY,
products_name VARCHAR(35),
category_id VARCHAR(10),
launch_date DATE,
price FLOAT,
CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE sales
(
sale_id VARCHAR(15) PRIMARY KEY,
sale_date DATE,
store_id VARCHAR(10),
product_id VARCHAR(10),
quantity INT,
CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(store_id),
CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE warranty
(
claim_id VARCHAR(10) PRIMARY KEY,
claim_date DATE,
sale_id VARCHAR(15),
repair_status VARCHAR(15),
CONSTRAINT fk_orders FOREIGN KEY (sale_id) REFERENCES sales(sale_id)
);

-- Success Message

SELECT 'Schema Created Successful' as Success_Message;

-- Fetching all records from every table for initial data exploration

SELECT * FROM category;
SELECT * FROM products;
SELECT * FROM stores ;
SELECT * FROM sales;
SELECT * FROM warranty;

-- Exploratory Data Analysis

SELECT DISTINCT repair_status FROM warranty;

SELECT COUNT(*) FROM sales;

-- Improving Query Performance

EXPLAIN ANALYZE  -- Planning Time: 0.13 ms, Execution Time: 166.71 ms
SELECT * FROM sales
WHERE product_id = 'p-44';

EXPLAIN ANALYZE  -- Planning Time: 0.21 ms, Execution Time: 169.41 ms
SELECT * FROM sales
WHERE store_id = 'ST-31';

EXPLAIN ANALYZE  -- Planning Time: 0.10, Execution Time: 0.22
SELECT * FROM sales
WHERE sale_id = 'ST-31';

CREATE INDEX sales_product_id ON sales(product_id);

CREATE INDEX sales_store_id ON sales(store_id);

CREATE INDEX sales_sale_id ON sales(sale_id);

EXPLAIN ANALYZE  -- Planning Time: 2.82 ms, Execution Time: 0.19 ms
SELECT * FROM sales
WHERE product_id = 'p-44';

EXPLAIN ANALYZE  -- Planning Time: 0.14 ms, Execution Time: 24.05 ms
SELECT * FROM sales
WHERE store_id = 'ST-31';

EXPLAIN ANALYZE  -- Planning Time: 0.14, Execution Time: 0.15
SELECT * FROM sales
WHERE sale_id = 'ST-31';

-- Business Problems

-- Easy to Medium (10 Questions)

-- Q1. Find the number of stores in each country.

SELECT country, count(store_id) as total_stores
FROM stores GROUP BY 1
ORDER BY 2 DESC;

-- Q2. Calculate the total number of units sold by each store.

SELECT s.store_id, st.store_name, sum(s.quantity) as total_unit_sold
FROM sales as s
JOIN
stores as st
ON st.store_id = s.store_id
GROUP BY 1,2
ORDER BY 3 DESC;

-- Q3. Identify how many sales occurred in December 2023.

SELECT COUNT(sale_id) as total_sale
FROM sales
WHERE TO_CHAR(sale_date, 'MM-YYYY') = '12-2023';

-- Q4. Determine how many stores have never had a warranty claim filed.

SELECT COUNT(*) AS stores_without_claims FROM stores
WHERE store_id NOT IN 
(
SELECT DISTINCT store_id
FROM sales as s
JOIN warranty as w
ON s.sale_id = w.sale_id
);

-- Q5. Calculate the percentage of warranty claims marked as "Rejected".

SELECT 
ROUND(COUNT(claim_id)/(SELECT COUNT(*) FROM warranty)::numeric * 100, 2) as Rejected_percentage
FROM warranty
WHERE repair_status = 'Rejected';

-- Q6. Identify which store had the highest total units sold in the last year.
-- sale_date <= "2024-11-12"

SELECT
s.store_id,
st.store_name,
SUM(s.quantity) AS total_units
FROM sales as s
JOIN stores as st
ON s.store_id = st.store_id
WHERE sale_date >= (CURRENT_DATE - INTERVAL '1 year')
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1;

-- Q7. Count the number of unique products sold in the last year.
-- sale_date <= "2024-11-12"

SELECT COUNT(DISTINCT product_id) AS unique_products
FROM sales
WHERE sale_date >= (CURRENT_DATE - INTERVAL '1 year');

-- Q8. Find the average price of products in each category.

SELECT 
p.category_id,
c.category_name,
AVG(p.price) as avg_price
FROM products as p
JOIN
category as c
ON p.category_id = c.category_id
GROUP BY 1, 2
ORDER BY 3 DESC;

-- Q9. How many warranty claims were filed in 2020?

SELECT COUNT(*) as warranty_claims_2020
FROM warranty 
WHERE EXTRACT(YEAR FROM claim_date) = 2020;

-- Q10. For each store, identify the best-selling day based on highest quantity sold.

SELECT * 
FROM
(
SELECT store_id,
TO_CHAR(sale_date, 'Day') as day_name,
SUM(quantity) as total_unit_sold,
RANK() OVER(PARTITION BY store_id ORDER BY SUM(quantity) DESC) as rank
FROM sales
GROUP BY 1, 2 
) as t1
WHERE rank = 1;

-- Medium to Hard (5 Questions)

-- Q11. Identify the least selling product in each country for each year based on total units sold.

WITH product_rank AS (
    SELECT
        st.country,
        EXTRACT(YEAR FROM s.sale_date) as sale_year,
        p.products_name,
        SUM(s.quantity) as total_qty_sold,
        RANK() OVER(PARTITION BY st.country, EXTRACT(YEAR FROM s.sale_date) 
                    ORDER BY SUM(s.quantity)) as rank
    FROM sales as s
    JOIN stores as st
        ON s.store_id = st.store_id
    JOIN products as p
        ON s.product_id = p.product_id
    GROUP BY 1, 2, 3
)
SELECT 
    country,
    sale_year,
    products_name,
    total_qty_sold
FROM product_rank
WHERE rank = 1;

-- Q12. Calculate how many warranty claims were filed within 180 days of a product sale.

SELECT 
COUNT(*) AS claims_within_180_days
FROM warranty as w
JOIN
sales as s
ON s.sale_id = w.sale_id
WHERE w.claim_date - sale_date <= 180;

-- Q13. Determine how many warranty claims were filed for products launched in the last two years.

SELECT 
p.products_name,
COUNT(w.claim_id) as total_claims
FROM sales as s
JOIN 
warranty AS w ON s.sale_id = w.sale_id
JOIN 
products as p ON p.product_id = s.product_id
WHERE p.launch_date >= CURRENT_DATE - INTERVAL '2 years'
GROUP BY 1
HAVING COUNT(w.claim_id) > 0
ORDER BY total_claims DESC;
 
-- Q14. List the months in the last three years where sales exceeded 5,000 units in the United States.

SELECT 
TO_CHAR(sale_date, 'MM-YYYY') as month,
SUM(s.quantity) as total_unit_sold
FROM sales as s
JOIN
stores as st
ON s.store_id = st.store_id
WHERE st.country = 'United States'
AND s.sale_date >= CURRENT_DATE - INTERVAL '3 year'
GROUP BY 1
HAVING SUM(s.quantity) > 5000
ORDER BY month;

-- Q15. Identify the product category with the most warranty claims filed in the last two years.

SELECT 
    c.category_name,
    COUNT(w.claim_id) as total_claims
FROM sales as s
JOIN warranty as w ON w.sale_id = s.sale_id
JOIN products as p ON p.product_id = s.product_id
JOIN category as c ON c.category_id = p.category_id
WHERE w.claim_date >= CURRENT_DATE - INTERVAL '2 years'
GROUP BY 1
ORDER BY total_claims DESC
LIMIT 1;

-- Complex (5 Questions)

-- Q16. Determine the percentage chance of receiving warranty claims after each purchase for each country.

SELECT
country,
total_unit_sold,
total_claim,
ROUND(
	COALESCE(total_claim::numeric / total_unit_sold::numeric * 100, 0)
	, 2)AS warranty_claim_percentage
FROM
(
SELECT
st.country,
SUM(s.quantity) AS total_unit_sold,
COUNT(w.claim_id) AS total_claim
FROM sales AS s
JOIN stores AS st ON s.store_id = st.store_id
JOIN warranty AS w ON w.sale_id = s.sale_id
GROUP BY 1) AS t1
ORDER BY 4 DESC;

-- Q17. Analyze the year-by-year growth ratio for each store.

WITH yearly_sales
AS
(
SELECT 
s.store_id,
st.store_name,
EXTRACT(YEAR FROM s.sale_date) as year,
SUM(s.quantity * p.price) as total_sale
FROM sales as s
JOIN
products as p
ON s.product_id = p.product_id
JOIN stores as st
ON st.store_id = s.store_id
GROUP BY 1, 2, 3
),
growth_ratio
AS
(
SELECT
store_name,
year,
LAG(total_sale, 1) OVER(PARTITION BY store_name ORDER BY year) as last_year_sale,
total_sale as current_year_sale
FROM yearly_sales
)
SELECT
store_name,
year,
last_year_sale,
current_year_sale,
ROUND(
(current_year_sale - last_year_sale)::numeric / last_year_sale::numeric * 100
,3) as growth_ratio_percentage
FROM growth_ratio
WHERE last_year_sale IS NOT NULL
AND
YEAR <> EXTRACT(YEAR FROM CURRENT_DATE)
ORDER BY 1, 2;
 
-- Q18. Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.

SELECT
CASE WHEN p.price < 500 THEN 'Budget (< $500)'
     WHEN p.price BETWEEN 500 AND 1000 THEN 'Mid-Range ($500-$1000)'
ELSE 'Premium (> $1000)'
END AS price_segment,
COUNT(w.claim_id) as total_claim
FROM sales as s
JOIN warranty as w ON w.sale_id = s.sale_id
JOIN products as p ON p.product_id = s.product_id
WHERE claim_date >= CURRENT_DATE - INTERVAL '5 year'
GROUP BY 1
ORDER BY total_claim DESC;

-- Q19. Identify the store with the highest percentage of "Rejected" claims relative to total claims filed.

WITH rejected AS
(
SELECT s.store_id, COUNT(w.claim_id) AS rejected
FROM sales AS s
JOIN warranty AS w ON w.sale_id = s.sale_id
WHERE w.repair_status = 'Rejected'
GROUP BY 1
), total_claims AS
(
SELECT s.store_id, COUNT(w.claim_id) AS total_claims
FROM sales AS s
JOIN warranty AS w ON w.sale_id = s.sale_id
GROUP BY 1
)
SELECT
t.store_id,
st.store_name,
r.rejected,
t.total_claims, 
ROUND(r.rejected::numeric / t.total_claims::numeric * 100, 2
	 ) AS rejected_percentage
FROM rejected AS r
JOIN total_claims AS t ON r.store_id = t.store_id
JOIN stores AS st ON t.store_id = st.store_id
ORDER BY rejected_percentage DESC
LIMIT 1;

-- Q20. Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period.

WITH monthly_sales AS
(
SELECT
s.store_id,
EXTRACT(YEAR FROM s.sale_date) as year,
EXTRACT(MONTH FROM s.sale_date) as month,
SUM(p.price * s.quantity) as total_revenue
FROM sales as s
JOIN products as p ON s.product_id = p.product_id
WHERE s.sale_date >= CURRENT_DATE - INTERVAL '4 years'
GROUP BY 1,2,3
)
SELECT
store_id,
month,
year,
total_revenue,
SUM(total_revenue) OVER(PARTITION BY store_id ORDER BY year, month) as running_total
FROM monthly_sales
ORDER BY 1,2,3;

-- Bonus Question

-- Q21. Analyze product sales trends over time, segmented into key periods: from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.

SELECT
p.product_name,
CASE
    WHEN s.sale_date BETWEEN p.launch_date
        AND p.launch_date + INTERVAL '6 month'
        THEN '0-6 month'

    WHEN s.sale_date BETWEEN p.launch_date + INTERVAL '6 month'
        AND p.launch_date + INTERVAL '12 month'
        THEN '6-12 month'

    WHEN s.sale_date BETWEEN p.launch_date + INTERVAL '12 month'
        AND p.launch_date + INTERVAL '18 month'
        THEN '12-18 month'

    ELSE '18+ months'
END as product_lifecycle_stage,
SUM(s.quantity) as total_qty_sale
FROM sales AS s 
JOIN products AS p ON s.product_id = p.product_id
GROUP BY 1, 2
ORDER BY 1, 3 DESC;
