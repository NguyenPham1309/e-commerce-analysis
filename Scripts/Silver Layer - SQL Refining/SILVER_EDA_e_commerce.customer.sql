SELECT 
	DISTINCT marital_status
FROM e_commerce.CUSTOMER;
SELECT 
	DISTINCT gender
FROM e_commerce.CUSTOMER;
SELECT 
	DISTINCT education_level 
FROM e_commerce.CUSTOMER;
SELECT 
	DISTINCT occupation
FROM e_commerce.CUSTOMER;
SELECT 
	DISTINCT home_owner
FROM e_commerce.CUSTOMER;
SELECT TOP 200 customer_id
FROM e_commerce.CUSTOMER
ORDER BY customer_id DESC;

--email, all are hotmail
SELECT COUNT(email_address)
FROM e_commerce.CUSTOMER
WHERE email_address LIKE '%hotmail%'

--% gender
SELECT ROUND(
	SUM(CASE WHEN gender = 'F' THEN 1 END)*100.0 / 
	(SELECT COUNT (customer_id) FROM e_commerce.CUSTOMER),2) AS FEMALE,
	ROUND(
	SUM(CASE WHEN gender = 'M' THEN 1 END)*100.0 / 
	(SELECT COUNT (customer_id) FROM e_commerce.CUSTOMER),2) AS MALE
FROM e_commerce.customer 

--%marital status
SELECT
	ROUND(
	SUM (CASE WHEN marital_status = 'S' THEN 1 END)*100.0/
	(SELECT COUNT(customer_id) FROM e_commerce.CUSTOMER),2) AS SINGLE,
	ROUND(
	SUM (CASE WHEN marital_status = 'M' THEN 1 END)*100.0/
	(SELECT COUNT(customer_id) FROM e_commerce.CUSTOMER),2) AS MARRIED
FROM e_commerce.customer

--% educational level
SELECT
	ROUND(
	SUM (CASE WHEN education_level = 'Partial High School' THEN 1 END)*100.0/
	(SELECT COUNT(customer_id) FROM e_commerce.CUSTOMER),2) AS PHS,
	ROUND(
	SUM (CASE WHEN education_level = 'High School' THEN 1 END)*100.0/
	(SELECT COUNT(customer_id) FROM e_commerce.CUSTOMER),2) AS HS,
	ROUND(
	SUM (CASE WHEN education_level = 'Partial College' THEN 1 END)*100.0/
	(SELECT COUNT(customer_id) FROM e_commerce.CUSTOMER),2) AS PC,
	ROUND(
	SUM (CASE WHEN education_level = 'Bachelors' THEN 1 END)*100.0/
	(SELECT COUNT(customer_id) FROM e_commerce.CUSTOMER),2) AS B,
	ROUND(
	SUM (CASE WHEN education_level = 'Graduate Degree' THEN 1 END)*100.0/
	(SELECT COUNT(customer_id) FROM e_commerce.CUSTOMER),2) AS GD
FROM e_commerce.customer;

--% occupation
SELECT
	ROUND(
	SUM (CASE WHEN occupation = 'Professional' THEN 1 END)*100.0/
	(SELECT COUNT(customer_id) FROM e_commerce.CUSTOMER),2) AS Prof,
	ROUND(
	SUM (CASE WHEN occupation = 'Clerical' THEN 1 END)*100.0/
	(SELECT COUNT(customer_id) FROM e_commerce.CUSTOMER),2) AS Cler,
	ROUND(
	SUM (CASE WHEN occupation  = 'Manual' THEN 1 END)*100.0/
	(SELECT COUNT(customer_id) FROM e_commerce.CUSTOMER),2) AS Man,
	ROUND(
	SUM (CASE WHEN occupation = 'Management' THEN 1 END)*100.0/
	(SELECT COUNT(customer_id) FROM e_commerce.CUSTOMER),2) AS Manager,
	ROUND(
	SUM (CASE WHEN occupation = 'Skilled Manual' THEN 1 END)*100.0/
	(SELECT COUNT(customer_id) FROM e_commerce.CUSTOMER),2) AS Skil
FROM e_commerce.customer;

--% home_owner
SELECT ROUND(
	SUM(CASE WHEN home_owner = 'N' THEN 1 END)*100.0 / 
	(SELECT COUNT (customer_id) FROM e_commerce.CUSTOMER),2) AS No,
	ROUND(
	SUM(CASE WHEN home_owner = 'Y' THEN 1 END)*100.0 / 
	(SELECT COUNT (customer_id) FROM e_commerce.CUSTOMER),2) AS Yes
FROM e_commerce.customer; 

--% null in gender column
SELECT ROUND(COUNT (customer_id)*100.0 / 
	(SELECT COUNT (customer_id) FROM e_commerce.CUSTOMER),2)
FROM e_commerce.customer 
WHERE gender IS NULL;

--annual_income
SELECT 
	MAX(annual_income) AS MAX,
	MIN(annual_income) AS MIN,
	AVG(annual_income) AS AVG,
	SUM(annual_income) AS TOTAL
FROM e_commerce.customer