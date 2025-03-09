select COUNT(*)
from retail_sales;


-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL 
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS  NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL 
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS  NULL
	OR
	price_per_unit IS nULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration
-- How many sales we have
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many unique customers we have
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

-- How many unique category we have
SELECT DISTINCT category  FROM retail_sales

-- Data Analysis & Business key problems & answers

-- Q1 Write a SQL query to retrieve all columns from sales made on '2022-11-05'
-- Q2 Write a SQL query to retrieve all transactions where the category is' Clothing' and the quatity sold is more than 4 in the month of Nov-2022
-- Q3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q4 Write a SQL query to find the average age of customers who purchased items from the' Beauty' category.
-- Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q6 Write a SQL query to find the total number of transactions(transaction_id) made by each gender in each category.
-- Q7 Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year
-- Q8 Write a SQL query to find the top 5 customers based on the highest total sales
-- Q9 Write a SQL query to find the number of uniques customers who purchased items from each category
-- Q10 Write a SQL query to create each shift and number of orders(Eg morning <= 12, afternoon btw 12 & 17, evening > 17)

-- Q1
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05'

-- Q2
SELECT *
FROM retail_sales
WHERE 
	category ='Clothing'
	AND 
	TO_CHAR(sale_date,'YYYY-MM') ='2022-11'
	AND
	quantiy >=4

-- Q3
SELECT 
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- Q4
SELECT 
	ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- Q5
SELECT * FROM retail_sales 
WHERE total_sale >= 1000

-- Q6
SELECT 
	category, 
	gender,
	COUNT(*) as total_trans
FROM retail_sales
GROUP BY
	category,
	gender
	ORDER BY 1

-- Q7

SELECT 
	year,
	month,
	avg_sale
FROM
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC ) as rank
	FROM retail_sales
	GROUP BY 1, 2
) as t1
WHERE rank = 1

--ORDER BY 1, 3 DESC
-- use window function RANK() to get the month which have the highest sale

-- Q8
SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 5

-- Q9
SELECT 
	category,
	COUNT(DISTINCT customer_id) as cnt_unique_customer
FROM retail_sales
GROUP BY category 

--Q10
--store the below query in CTE- Common Table Expressions
WITH hourly_sales
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time)< 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) as total_orders
FROM hourly_sales
GROUP BY shift

--SELECT EXTRACT(HOUR FROM CURRENT_TIME)