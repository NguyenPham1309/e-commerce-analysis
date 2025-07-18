# Project: e-commerce-analysis

**Author:** NGUYEN PHAM
**Date:** July 01, 2025
**Contact:** nguyen.pham961309@gmail.com | [https://www.linkedin.com/in/khoinguyenpham/]
---

## 1. Introduction & Objectives

* This project presents how to handle datawarehouse structures using SQL (BigQuery), how to explore the data through EDA process with Python (Google Colab), and how to do the data visualization (Looker Studio) 
* The primary objective is to handle a database from scratch, as a requirement from a client for a consultant to newly come to an e-commerce business. The project will be built on three different phases:
    * First, I need to build a datawarehouse structure that can serve a more long-term analysis in the future (self-service)
    * Second, I need to explore the data thoroughly, using distribution analysis, statistical analysis and correlation among the variables
    * Third, I need to support the decision-making process of the business by enhancing how the company can retrieve the actionable insights by analyzing the visualization.
* This builds upon experience in understanding how to plan analytical layers, build data warehousing (analysis-ready structure), and visualization at my latest company, AIA Vietnam, and other studies throughout my education and personal projects. 

---

## 2. Data Modeling
This dataset is decently structured and standardized, but there are rooms for further exploration to have the analysis efficient

🏁 **Analytical layers**
![Define Analytical Layers - Analysis Flow](https://github.com/user-attachments/assets/5e90a8cb-d102-402f-ad44-bef0a9616884)

💡 **Data Lineage**
![Warehousing and Modeling_Data Lineage](https://github.com/user-attachments/assets/3a8fa59d-3e01-4d7b-a4b3-9ccf705fed4b)

⛯ **Entity Relationship Diagram**
<img width="1040" height="753" alt="Data Availability checking_ERDDiagram_28 06" src="https://github.com/user-attachments/assets/d50f0557-c71e-4ff5-bab1-95c7db7671e9" />

⛯ **Setting partitioning column in the fact table**
* **Using the column order_date as the partitioning column for better performance and cost-saving while querying on BigQuery**

<img width="641" height="357" alt="Connection Setup_SetupCloudEnvironment_Partitioningsettings_01 07" src="https://github.com/user-attachments/assets/ce7be7f1-7bf1-4d3e-84a3-2d4a3bcb1d13" />

📜 **Data Dictionary**
* **This data dictionary has been enhanced to meet the rigorous standards of government documentation.** In addition to standard column descriptions, the following metadata fields have been included to ensure clarity, data quality assurance, and unambiguous interpretation:
[Data Dictionary file](https://github.com/NguyenPham1309/e-commerce-analysis/blob/main/Docs/SQL%20Layers%20-%20Warehousing%20and%20Modeling_DataDictionary_16.07.pdf)
---

## 3. Tools & Technologies Used
*   **Data Preparation:** DBeaver, Google BigQuery, Google Colab
*   **Data Visualization & Dashboarding:** Looker Studio 
*   **Version Control:** Git & GitHub
*   **IDE/Editor (for this README):** Visual Studio Code
*   **Planning**: [Notion](https://www.notion.so/E_commerce-project_SQL-22087cc4273f8034ac63dec17e820406?source=copy_link)
<img width="572" height="330" alt="Project Initialization_ProjectPlanning_18 07" src="https://github.com/user-attachments/assets/afb16e19-ac28-4b64-a9d2-8cb68bf353c8" />
---

## 4. Task Solutions
#### Bronze Layer
**Metadata information of the tables**
``` sql
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'e_commerce'
  AND TABLE_NAME = 'customer';
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'e_commerce'
  AND TABLE_NAME = 'ecom_sales';
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'e_commerce'
  AND TABLE_NAME = 'product';
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'e_commerce'
  AND TABLE_NAME = 'region';
```

#### Silver Layer
**Simple EDA of customer table using SQL**
```sql
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
```
**Logic of Sales_Quantity_Discount_Cost**
* **Test case 1 - Product with quantity and sales**
```sql
SELECT
	row_id,
	order_date,
	order_id,
	product_code,
	quantity,
	sales,
	discount,
	profit
FROM e_commerce.ecom_sales
WHERE order_date >= '2023-01-01'
    AND order_date < '2023-09-01'
	AND product_code IN ('P002378','P000194','P000157')
ORDER BY product_code, quantity DESC
--The most efficient way to filter a date range 
--is to avoid running functions on the column in the WHERE clause. 
--This allows the database to use an index on the order_date column if one exists. 
--The best practice is to define a date range.
```
* **Test case 1.2 - Product with price movement through time**
```sql
--Calculate the unit price for every single transaction
--I am thinking of calculating by product
WITH 
price_check AS
(
	SELECT 
	product_code,
	sales/quantity AS calculated_unit_price
	FROM 
		e_commerce.ecom_sales
	WHERE 
		quantity > 0 AND sales > 0 --No division on zero
)
--Check to see any price movements through time
SELECT
	product_code,
	COUNT(*) AS number_of_sales,
    MIN(calculated_unit_price) AS min_price,
    MAX(calculated_unit_price) AS max_price,
    AVG(calculated_unit_price) AS avg_price,
    STDEV(calculated_unit_price) AS sd_price 
    --standard deviation for seeing the gap of price
FROM price_check
GROUP BY product_code
--HAVING MAX(calculated_unit_price) > MIN(calculated_unit_price)--To check if any specific products has price change over time
ORDER BY 
	sd_price DESC, number_of_sales DESC;
```
* **Test case 2 - Discount view with product**
```sql
--For each order, there are multiple discounts. Therefore, the discounts tie to the product, not order
WITH order_view AS(
SELECT DISTINCT
	e.order_id,
	e.order_date,
	MAX(e.discount) OVER (PARTITION BY e.order_id) AS max_dis,
	MIN(e.discount) OVER (PARTITION BY e.order_id) AS min_dis
FROM e_commerce.ecom_sales e
)
SELECT 
	order_id,
	order_date,
	max_dis,
	min_dis
FROM order_view
WHERE max_dis - min_dis > 0;

--For each product, there are multiple discounts. 
SELECT
    e.product_code,
    COUNT(*) as num_sales,
    MIN(e.discount) AS min_lifetime_discount,
    MAX(e.discount) AS max_lifetime_discount
FROM
    e_commerce.ecom_sales e
GROUP BY
    e.product_code
HAVING
    MIN(e.discount) < MAX(e.discount) 
ORDER BY
    product_code;

--Discounts can be wary even within a single order date
--Find the time where there is a difference between discount of a product
SELECT
	e.product_code,
	e.order_date,
	MAX(e.discount) AS max_dis,
	MIN(e.discount) AS min_dis,
	MAX(e.discount) - MIN(e.discount) AS dis_diff
FROM e_commerce.ecom_sales e
GROUP BY e.product_code, e.order_date
HAVING MAX(e.discount) - MIN(e.discount) > 0

--Sales after discount and profit
--Assume that the discount here is in percentage, 0.5 = 50%
--In this entire dataset, there is not a single recorded transaction where a product was sold at its exact break-even price 
--(i.e., with zero discount and resulting in zero profit). 
--This implies that the company's pricing or accounting strategy does not allow for simple break-even sales.
--They either sell a product for a profit (profit > 0) 
--or they sell it at a deliberate loss (profit < 0) to attract customers, perhaps as part of a promotion.
SELECT
	e.order_id,
	e.order_date,
	e.product_code,
	e.sales,
	e.discount,
	e.sales*(1-e.discount)AS sale_after_discounts,
	e.sales / e.quantity AS unit_price,
	e.sales*(1-e.discount) / e.quantity AS unit_price_after_discount,
	e.profit,
	e.profit*100.0/e.sales AS profit_margin
FROM e_commerce.ecom_sales e
WHERE discount = 0
	AND profit = 0
ORDER BY order_date, order_id ,product_code;

-- Hypothesis: The implied cost for a product is stable within a specific country.
-- Test: Calculate the min, max, and average implied cost for each product/country pair.

WITH CostAnalysis AS (
    SELECT
        e.product_code,
        r.country,
        -- This is our universal formula for cost on every single line item
        (e.sales * (1 - e.discount) - e.profit)*1.0 AS implied_cost_per_sale,
        -- We also need to calculate the cost per single unit
        (e.sales * (1 - e.discount) - e.profit) *1.0/ e.quantity AS implied_cost_per_unit
    FROM
        e_commerce.ecom_sales AS e
    JOIN
        e_commerce.region AS r ON e.region_code = r.region_code -- Adjust join key if needed
    WHERE
        e.quantity > 0 -- Avoid division by zero
)
SELECT
    product_code,
    country,
    COUNT(*) AS number_of_sales,
    MIN(implied_cost_per_unit) AS min_cost_per_unit,
    MAX(implied_cost_per_unit) AS max_cost_per_unit,
    AVG(implied_cost_per_unit) AS avg_cost_per_unit,
    -- This column is key: it shows the difference between the highest and lowest calculated cost
    (MAX(implied_cost_per_unit) - MIN(implied_cost_per_unit))*1.0 AS cost_variance
FROM
    CostAnalysis
GROUP BY
    product_code,
    country
ORDER BY
    cost_variance DESC; -- Sort to see the products with the least stable costs first
```

* **Test case 3 - Order view with country**
```sql
-- This query checks if any order spans multiple countries
SELECT
    order_id,
    COUNT(DISTINCT r.country) AS number_of_countries
FROM
    e_commerce.ecom_sales e
JOIN
    e_commerce.region r ON e.region_code = r.region_code
GROUP BY
    order_id
HAVING
    COUNT(DISTINCT r.country) > 1;
--no order has more than 1 country
```
💡 **Foundation logic after Data Exploration**
![Data Exploration Findings](https://github.com/user-attachments/assets/3ca2c140-91ab-47e6-8dc5-66891df38486)

#### Gold Layer
* **Create a VIEW functioning as Data Modeling in BigQuery**
```sql
CREATE OR REPLACE VIEW `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1` AS
(
-- =======================================================================================
-- STEP 1: CalculatedSales CTE
-- Purpose: Create all required derived columns based on the data within each sales record.
-- =======================================================================================
WITH CalculatedSales AS (
  SELECT
    -- Base columns from the Sales table
    row_id,
    order_id,
    order_date,
    customer_id,
    region_code,
    product_code,
    segment,
    quantity,
    sales AS gross_sales, -- Renamed for clarity
    discount,
    profit,

    -- ===================================================================
    -- DERIVED COLUMNS
    -- ===================================================================

    -- 1. Sales After Promotion: The net revenue after the discount is applied.
    --    Formula: sales - (sales * discount)
    (sales - (sales * discount)) AS sales_after_discount,

    -- 2. Unit Price: The gross price per single unit before discount.
    --    Formula: sales / quantity
    SAFE_DIVIDE(sales, quantity) AS unit_price_bdiscount,

    -- 3. Profit Margin %: The standard business definition of profit margin.
    --    Formula: profit / sales
    SAFE_DIVIDE(profit, sales) AS profit_margin_bdiscount,

    -- 4. Implied Cost (Record Level): The calculated cost for the entire line item.
    --    Formula: sales - profit - (sales * discount)
    (sales - profit - (sales * discount)) AS implied_cost_record_level,

    -- 5. Implied Unit Cost: The calculated cost per single unit.
    --    Formula: implied_cost_record_level / quantity
    SAFE_DIVIDE((sales - profit - (sales * discount)), quantity) AS implied_unit_cost

  FROM
    `e-commerce-sql-project-464611.my_server_data.ecom_sales`
)

-- =======================================================================================
-- STEP 2: Final SELECT with Joins
-- Purpose: Join the calculated sales data with all dimension tables (Customer, Product,
-- Region) to create a single, complete, and easy-to-query master view.
-- =======================================================================================
SELECT
  -- Identifiers from Sales table
  cs.row_id,
  cs.order_id,
  cs.order_date,
  
  -- Base Calculations from Sales table
  cs.gross_sales, 
  cs.discount,
  cs.quantity,
  cs.profit, 

  -- NEW DERIVED COLUMNS
  cs.sales_after_discount,
  cs.unit_price_bdiscount,
  cs.profit_margin_bdiscount,
  cs.implied_cost_record_level,
  cs.implied_unit_cost,
  
  -- Customer Information (joined from Customer table)
  -- The view did not take the personal info of customer names and emails
  c.customer_id,
  c.birth_date,
  c.marital_status,
  c.gender,
  c.annual_income,
  c.education_level,
  c.occupation,
  c.home_owner,
  
  -- Product Information (joined from Product table)
  p.product_code,
  p.product AS product_name, -- Using correct column name from ERD
  p.category AS product_category,
  p.subcategory AS product_subcategory,

  -- Region Information (joined from Region table)
  r.region_code,
  r.market,
  r.region,
  r.country,
  r.state,
  r.city
FROM
  CalculatedSales AS cs
--The table name is case-sensitive in BigQuery
LEFT JOIN
  `my_server_data.customer` AS c ON cs.customer_id = c.customer_id
LEFT JOIN
  `my_server_data.product` AS p ON cs.product_code = p.product_code
LEFT JOIN
  `my_server_data.region` AS r ON cs.region_code = r.region_code
);
```
* **Analyzing Revenue, Cost, Price, and Unit Cost under different views**
    * **By time**
    ```sql
    -- Purpose: Track monthly revenue and cost to identify trends and seasonality.
    -- Calculate their Month-over-Month percentage change
    -- Full period:

    WITH MonthlySummary AS(
    SELECT 
        FORMAT_DATE('%Y-%m', order_date) AS SaleMonth,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit
    FROM `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1` 
    WHERE EXTRACT (YEAR FROM order_date) IN (2020,2021,2022,2023)
    GROUP BY
        SaleMonth
    )
    -- Step 2: Use the CTE to calculate MoM changes using the LAG() function window
    SELECT
        SaleMonth,
        TotalRevenue,
        TotalCost,
        TotalProfit,
        -- Calculate Revenue MoM Change (%)
        ROUND((TotalRevenue - LAG(TotalRevenue, 1) OVER (ORDER BY SaleMonth)) * 100.0 / NULLIF(LAG(TotalRevenue, 1) OVER (ORDER BY SaleMonth), 0),2) AS Revenue_MoM_Change_Percent,
        -- Calculate Cost MoM Change (%)
        ROUND((TotalCost - LAG(TotalCost, 1) OVER (ORDER BY SaleMonth)) * 100.0 / NULLIF(LAG(TotalCost, 1) OVER (ORDER BY SaleMonth), 0),2) AS Cost_MoM_Change_Percent,
        -- Calculate Profit MoM Change (%)
        ROUND((TotalProfit - LAG(TotalProfit, 1) OVER (ORDER BY SaleMonth)) * 100.0 / NULLIF(LAG(TotalProfit, 1) OVER (ORDER BY SaleMonth), 0),2) AS Profit_MoM_Change_Percent
    FROM
        MonthlySummary
    ORDER BY
        SaleMonth;

    -- Year: 2023
    -- Step 1: Create a CTE to calculate total revenue, cost, and profit for each month
    WITH MonthlySummary2023 AS(
    SELECT 
        FORMAT_DATE('%Y-%m', order_date) AS SaleMonth,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit
    FROM `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1` 
    WHERE EXTRACT (YEAR FROM order_date) = 2023
    GROUP BY
        SaleMonth
    )
    -- Step 2: Use the CTE to calculate MoM changes using the LAG() function window
    SELECT
        SaleMonth,
        TotalRevenue,
        TotalCost,
        TotalProfit,
        -- Calculate Revenue MoM Change (%)
        ROUND((TotalRevenue - LAG(TotalRevenue, 1) OVER (ORDER BY SaleMonth)) * 100.0 / NULLIF(LAG(TotalRevenue, 1) OVER (ORDER BY SaleMonth), 0),2) AS Revenue_MoM_Change_Percent,
        -- Calculate Cost MoM Change (%)
        ROUND((TotalCost - LAG(TotalCost, 1) OVER (ORDER BY SaleMonth)) * 100.0 / NULLIF(LAG(TotalCost, 1) OVER (ORDER BY SaleMonth), 0),2) AS Cost_MoM_Change_Percent,
        -- Calculate Profit MoM Change (%)
        ROUND((TotalProfit - LAG(TotalProfit, 1) OVER (ORDER BY SaleMonth)) * 100.0 / NULLIF(LAG(TotalProfit, 1) OVER (ORDER BY SaleMonth), 0),2) AS Profit_MoM_Change_Percent
    FROM
        MonthlySummary2023
    ORDER BY
        SaleMonth;

    -- Year: 2022
    -- Step 1: Create a CTE to calculate total revenue, cost, and profit for each month
    WITH MonthlySummary2022 AS(
    SELECT 
        FORMAT_DATE('%Y-%m', order_date) AS SaleMonth,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit
    FROM `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1` 
    WHERE EXTRACT (YEAR FROM order_date) = 2022
    GROUP BY
        SaleMonth
    )
    -- Step 2: Use the CTE to calculate MoM changes using the LAG() function window
    SELECT
        SaleMonth,
        TotalRevenue,
        TotalCost,
        TotalProfit,
        -- Calculate Revenue MoM Change (%)
        ROUND((TotalRevenue - LAG(TotalRevenue, 1) OVER (ORDER BY SaleMonth)) * 100.0 / NULLIF(LAG(TotalRevenue, 1) OVER (ORDER BY SaleMonth), 0),2) AS Revenue_MoM_Change_Percent,
        -- Calculate Cost MoM Change (%)
        ROUND((TotalCost - LAG(TotalCost, 1) OVER (ORDER BY SaleMonth)) * 100.0 / NULLIF(LAG(TotalCost, 1) OVER (ORDER BY SaleMonth), 0),2) AS Cost_MoM_Change_Percent,
        -- Calculate Profit MoM Change (%)
        ROUND((TotalProfit - LAG(TotalProfit, 1) OVER (ORDER BY SaleMonth)) * 100.0 / NULLIF(LAG(TotalProfit, 1) OVER (ORDER BY SaleMonth), 0),2) AS Profit_MoM_Change_Percent
    FROM
        MonthlySummary2022
    ORDER BY
        SaleMonth;

    -- Year: 2021
    -- Step 1: Create a CTE to calculate total revenue, cost, and profit for each month
    WITH MonthlySummary2021 AS(
    SELECT 
        FORMAT_DATE('%Y-%m', order_date) AS SaleMonth,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit
    FROM `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1` 
    WHERE EXTRACT (YEAR FROM order_date) = 2021
    GROUP BY
        SaleMonth
    )
    -- Step 2: Use the CTE to calculate MoM changes using the LAG() function window
    SELECT
        SaleMonth,
        TotalRevenue,
        TotalCost,
        TotalProfit,
        -- Calculate Revenue MoM Change (%)
        ROUND((TotalRevenue - LAG(TotalRevenue, 1) OVER (ORDER BY SaleMonth)) * 100.0 / NULLIF(LAG(TotalRevenue, 1) OVER (ORDER BY SaleMonth), 0),2) AS Revenue_MoM_Change_Percent,
        -- Calculate Cost MoM Change (%)
        ROUND((TotalCost - LAG(TotalCost, 1) OVER (ORDER BY SaleMonth)) * 100.0 / NULLIF(LAG(TotalCost, 1) OVER (ORDER BY SaleMonth), 0),2) AS Cost_MoM_Change_Percent,
        -- Calculate Profit MoM Change (%)
        ROUND((TotalProfit - LAG(TotalProfit, 1) OVER (ORDER BY SaleMonth)) * 100.0 / NULLIF(LAG(TotalProfit, 1) OVER (ORDER BY SaleMonth), 0),2) AS Profit_MoM_Change_Percent
    FROM
        MonthlySummary2021
    ORDER BY
        SaleMonth;

    -- Year: 2020
    -- Step 1: Create a CTE to calculate total revenue, cost, and profit for each month
    WITH MonthlySummary2020 AS(
    SELECT 
        FORMAT_DATE('%Y-%m', order_date) AS SaleMonth,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit
    FROM `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1` 
    WHERE EXTRACT (YEAR FROM order_date) = 2020
    GROUP BY
        SaleMonth
    )
    -- Step 2: Use the CTE to calculate MoM changes using the LAG() function window
    SELECT
        SaleMonth,
        TotalRevenue,
        TotalCost,
        TotalProfit,
        -- Calculate Revenue MoM Change (%)
        ROUND((TotalRevenue - LAG(TotalRevenue, 1) OVER (ORDER BY SaleMonth)) * 100.0 / NULLIF(LAG(TotalRevenue, 1) OVER (ORDER BY SaleMonth), 0),2) AS Revenue_MoM_Change_Percent,
        -- Calculate Cost MoM Change (%)
        ROUND((TotalCost - LAG(TotalCost, 1) OVER (ORDER BY SaleMonth)) * 100.0 / NULLIF(LAG(TotalCost, 1) OVER (ORDER BY SaleMonth), 0),2) AS Cost_MoM_Change_Percent,
        -- Calculate Profit MoM Change (%)
        ROUND((TotalProfit - LAG(TotalProfit, 1) OVER (ORDER BY SaleMonth)) * 100.0 / NULLIF(LAG(TotalProfit, 1) OVER (ORDER BY SaleMonth), 0),2) AS Profit_MoM_Change_Percent
    FROM
        MonthlySummary2020
    ORDER BY
        SaleMonth;

    -- Check to see if any years < 2020 or > 2023
    SELECT 
        DISTINCT
        EXTRACT (YEAR FROM order_date)
        FROM `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1` 
        WHERE EXTRACT (YEAR FROM order_date) > 2023
            OR EXTRACT (YEAR FROM order_date) < 2020;
    ```

    * **By time in transaction level**
    ```sql
    -- Purpose: Get a single, high-level statistical summary of all transactions.
    SELECT
        'Overall' AS AggregationLevel,
        ROUND(AVG(sales_after_discount),2) AS AverageTransactionRevenue,
        ROUND(MIN(sales_after_discount),2) AS MinTransactionRevenue,
        ROUND(MAX(sales_after_discount),2) AS MaxTransactionRevenue,
        ROUND(AVG(implied_cost_record_level),2) AS AverageTransactionCost,
        ROUND(SUM(profit),2) AS TotalProfit,
        ROUND(SUM(profit)/IFNULL(SUM(sales_after_discount),Null),2) AS ProfitMargin
    FROM
        `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1` 
    WHERE EXTRACT (YEAR FROM order_date) IN (2020, 2021, 2022, 2023);

    -- Purpose: Get a statistical summary aggregated by Year.
    SELECT
        EXTRACT(YEAR FROM order_date) AS SaleYear,
        ROUND(AVG(sales_after_discount),2) AS AverageTransactionRevenue,
        ROUND(MIN(sales_after_discount),2) AS MinTransactionRevenue,
        ROUND(MAX(sales_after_discount),2) AS MaxTransactionRevenue,
        ROUND(AVG(implied_cost_record_level),2) AS AverageTransactionCost,
        ROUND(SUM(profit),2) AS TotalProfit,
        ROUND(SUM(profit)/IFNULL(SUM(sales_after_discount),Null),2) AS ProfitMargin
    FROM
        `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1`
    WHERE EXTRACT (YEAR FROM order_date) IN (2020, 2021, 2022, 2023) 
    GROUP BY
        SaleYear
    ORDER BY
        SaleYear;

    -- Purpose: Get a statistical summary aggregated by Month-Year.
    SELECT
        FORMAT_DATE('%Y-%m', order_date) AS SaleMonth,
        ROUND(AVG(sales_after_discount),2) AS AverageTransactionRevenue,
        ROUND(MIN(sales_after_discount),2) AS MinTransactionRevenue,
        ROUND(MAX(sales_after_discount),2) AS MaxTransactionRevenue,
        ROUND(AVG(implied_cost_record_level),2) AS AverageTransactionCost,
        ROUND(SUM(profit),2) AS TotalProfit,
        ROUND(SUM(profit)/IFNULL(SUM(sales_after_discount),Null),2) AS ProfitMargin
    FROM
        `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1`
    WHERE EXTRACT (YEAR FROM order_date) IN (2020, 2021, 2022, 2023)  
    GROUP BY
        SaleMonth
    ORDER BY
        MIN(order_date); -- Order by the actual first date of the month
    ```

    * **By Customer**
    ```sql
    -- Purpose: Analyze revenue, cost and profit with different categorical variables of customer view:
    -- By occupation: 
    WITH OccupationSummary AS (
    SELECT
        occupation,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit,
        ROUND(AVG(sales_after_discount), 2) AS AverageRevenue,
        ROUND(AVG(implied_cost_record_level), 2) AS AverageCost,
        ROUND(AVG(profit), 2) AS AverageProfit,
        ROUND(AVG(profit_margin_bdiscount), 2) AS AverageProfitMargin
    FROM
        `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1`
    WHERE
        EXTRACT(YEAR FROM order_date) IN (2020, 2021, 2022, 2023)
    GROUP BY
        occupation
    )
    SELECT
        *,
        ROUND(TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (),2) AS RevenueContribution_Percent,
        ROUND((TotalCost * 100.0 / SUM(TotalCost) OVER ()),2) AS CostContribution_Percent,
        ROUND((TotalProfit * 100.0 / SUM(TotalProfit) OVER ()),2) AS ProfitContribution_Percent
    FROM
        OccupationSummary
    ORDER BY
        TotalRevenue DESC;

    -- By Year of Birth
    WITH BirthYearSummary AS (
    SELECT
        EXTRACT(YEAR FROM birth_date) AS BirthYear,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit,
        ROUND(AVG(sales_after_discount), 2) AS AverageRevenue,
        ROUND(AVG(implied_cost_record_level), 2) AS AverageCost,
        ROUND(AVG(profit), 2) AS AverageProfit,
        ROUND(AVG(profit_margin_bdiscount), 2) AS AverageProfitMargin
    FROM
        `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1`
    WHERE
        EXTRACT(YEAR FROM order_date) IN (2020, 2021, 2022, 2023)
    GROUP BY
        BirthYear
    )
    SELECT
        *,
        ROUND(TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (),2) AS RevenueContribution_Percent,
        ROUND((TotalCost * 100.0 / SUM(TotalCost) OVER ()),2) AS CostContribution_Percent,
        ROUND((TotalProfit * 100.0 / SUM(TotalProfit) OVER ()),2) AS ProfitContribution_Percent
    FROM
        BirthYearSummary
    ORDER BY
        BirthYear;

    -- By Marital Status
    WITH MaritalStatusSummary AS (
    SELECT
        marital_status,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit,
        ROUND(AVG(sales_after_discount), 2) AS AverageRevenue,
        ROUND(AVG(implied_cost_record_level), 2) AS AverageCost,
        ROUND(AVG(profit), 2) AS AverageProfit,
        ROUND(AVG(profit_margin_bdiscount), 2) AS AverageProfitMargin
    FROM
        `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1`
    WHERE
        EXTRACT(YEAR FROM order_date) IN (2020, 2021, 2022, 2023)
    GROUP BY
        marital_status
    )
    SELECT
        *,
        ROUND(TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (),2) AS RevenueContribution_Percent,
        ROUND((TotalCost * 100.0 / SUM(TotalCost) OVER ()),2) AS CostContribution_Percent,
        ROUND((TotalProfit * 100.0 / SUM(TotalProfit) OVER ()),2) AS ProfitContribution_Percent
    FROM
        MaritalStatusSummary
    ORDER BY
        TotalRevenue DESC;

    -- By Gender
    WITH GenderSummary AS (
    SELECT
        CASE WHEN gender IS NOT NULL THEN gender ELSE 'Others' END AS gender,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit,
        ROUND(AVG(sales_after_discount), 2) AS AverageRevenue,
        ROUND(AVG(implied_cost_record_level), 2) AS AverageCost,
        ROUND(AVG(profit), 2) AS AverageProfit,
        ROUND(AVG(profit_margin_bdiscount), 2) AS AverageProfitMargin
    FROM
        `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1`
    WHERE
        EXTRACT(YEAR FROM order_date) IN (2020, 2021, 2022, 2023)
    GROUP BY
        1 -- Group by the first column (gender)
    )
    SELECT
        *,
        ROUND(TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (),2) AS RevenueContribution_Percent,
        ROUND((TotalCost * 100.0 / SUM(TotalCost) OVER ()),2) AS CostContribution_Percent,
        ROUND((TotalProfit * 100.0 / SUM(TotalProfit) OVER ()),2) AS ProfitContribution_Percent
    FROM
        GenderSummary
    ORDER BY
        TotalRevenue DESC;

    -- By Education level
    WITH EducationLevelSummary AS (
    SELECT
        CASE WHEN education_level IS NOT NULL THEN education_level ELSE 'Others' END AS education_level,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit,
        ROUND(AVG(sales_after_discount), 2) AS AverageRevenue,
        ROUND(AVG(implied_cost_record_level), 2) AS AverageCost,
        ROUND(AVG(profit), 2) AS AverageProfit,
        ROUND(AVG(profit_margin_bdiscount), 2) AS AverageProfitMargin
    FROM
        `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1`
    WHERE
        EXTRACT(YEAR FROM order_date) IN (2020, 2021, 2022, 2023)
    GROUP BY
        1 -- Group by the first column (education_level)
    )
    SELECT
        *,
        ROUND(TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (),2) AS RevenueContribution_Percent,
        ROUND((TotalCost * 100.0 / SUM(TotalCost) OVER ()),2) AS CostContribution_Percent,
        ROUND((TotalProfit * 100.0 / SUM(TotalProfit) OVER ()),2) AS ProfitContribution_Percent
    FROM
        EducationLevelSummary
    ORDER BY
        TotalRevenue DESC;

    -- By Homeonwer status
    WITH HomeownerSummary AS (
    SELECT
        home_owner,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit,
        ROUND(AVG(sales_after_discount), 2) AS AverageRevenue,
        ROUND(AVG(implied_cost_record_level), 2) AS AverageCost,
        ROUND(AVG(profit), 2) AS AverageProfit,
        ROUND(AVG(profit_margin_bdiscount), 2) AS AverageProfitMargin
    FROM
        `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1`
    WHERE
        EXTRACT(YEAR FROM order_date) IN (2020, 2021, 2022, 2023)
    GROUP BY
        1 -- Group by the first column (home_owner)
    )
    SELECT
        *,
        ROUND(TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (),2) AS RevenueContribution_Percent,
        ROUND((TotalCost * 100.0 / SUM(TotalCost) OVER ()),2) AS CostContribution_Percent,
        ROUND((TotalProfit * 100.0 / SUM(TotalProfit) OVER ()),2) AS ProfitContribution_Percent
    FROM
        HomeownerSummary
    ORDER BY
        TotalRevenue DESC;
    ```
    * **By Product**
    ```sql
    -- Purpose: Identify top-performing product categories and their percentage contribution to the grand totals.
    -- Step 1: CTE to aggregate sales, cost, and profit by product category.
    WITH CategoryTotals AS (
    SELECT
        CASE WHEN product_category IS NOT NULL THEN product_category
        ELSE 'Others' END AS product_category,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit,
        ROUND(AVG(sales_after_discount),2) AS AverageRevenue,
        ROUND(AVG(implied_cost_record_level),2) AS AverageCost,
        ROUND(AVG(profit),2) AS AverageProfit
    FROM
        `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1`
    WHERE EXTRACT (YEAR FROM order_date) IN (2020, 2021, 2022, 2023)
    GROUP BY
        1 -- Group by the first column (product_category)
    )
    -- Step 2: Calculate the percentage contribution using window functions on the aggregated data.
    SELECT
        product_category,
        TotalRevenue,
        TotalCost,
        TotalProfit,
        AverageRevenue,
        AverageCost,
        AverageProfit,
        -- The SUM() OVER () calculates the grand total of the respective column, which we use for our percentage calculation.
        ROUND((TotalRevenue * 100.0 / SUM(TotalRevenue) OVER ()),2) AS RevenueContribution_Percent,
        ROUND((TotalCost * 100.0 / SUM(TotalCost) OVER ()),2) AS CostContribution_Percent,
        ROUND((TotalProfit * 100.0 / SUM(TotalProfit) OVER ()),2) AS ProfitContribution_Percent
    FROM
        CategoryTotals
    ORDER BY
        TotalRevenue DESC;

    -- Purpose: Identify top-performing product subcategories and their percentage contribution to the grand totals.
    -- Step 1: CTE to aggregate sales, cost, and profit by both category and subcategory.
    WITH SubcategoryTotals AS (
    SELECT
        CASE WHEN product_category IS NOT NULL THEN product_category
        ELSE 'Others' END AS product_category,
        product_subcategory,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit,
        ROUND(AVG(sales_after_discount),2) AS AverageRevenue,
        ROUND(AVG(implied_cost_record_level),2) AS AverageCost,
        ROUND(AVG(profit),2) AS AverageProfit
    FROM
        `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1`
    WHERE EXTRACT (YEAR FROM order_date) IN (2020, 2021, 2022, 2023)
    GROUP BY
        1, 2 -- Group by the first and second columns (category and subcategory)
    )
    -- Step 2: Calculate the percentage contribution using window functions. The logic remains the same.
    SELECT
        product_subcategory,
        product_category,
        TotalRevenue,
        TotalCost,
        TotalProfit,
        AverageRevenue,
        AverageCost,
        AverageProfit,
        -- The SUM() OVER () window function still calculates the grand total across all rows in the CTE.
        ROUND((TotalRevenue * 100.0 / SUM(TotalRevenue) OVER ()),2) AS RevenueContribution_Percent,
        ROUND((TotalCost * 100.0 / SUM(TotalCost) OVER ()),2) AS CostContribution_Percent,
        ROUND((TotalProfit * 100.0 / SUM(TotalProfit) OVER ()),2) AS ProfitContribution_Percent
    FROM
        SubcategoryTotals
    ORDER BY
        TotalRevenue DESC;

    -- Purpose: Identify top-performing products and their percentage contribution to their respective category and subcategory totals.
    -- Step 1: CTE to aggregate sales, cost, and profit at the individual product level.
    WITH ProductLevelTotals AS (
    SELECT
        CASE WHEN product_category IS NOT NULL THEN product_category
        ELSE 'Others' END AS product_category,
        product_subcategory,
        product_name,
        MAX(unit_price_bdiscount) AS MaxOriginalPrice,
        MIN(unit_price_bdiscount) AS MinOriginalPrice,
        MAX(profit_margin_bdiscount) AS MaxProfitMargin,
        ROUND(AVG(profit_margin_bdiscount),2) AS AverageProfitMargin,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit,
        ROUND(AVG(sales_after_discount),2) AS AverageOrderRevenue,
        ROUND(AVG(implied_cost_record_level),2) AS AverageOrderCost,
        ROUND(AVG(profit),2) AS AverageOrderProfit
    FROM
        `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1`
    WHERE 
        EXTRACT(YEAR FROM order_date) IN (2020, 2021, 2022, 2023)
        AND product_name IS NOT NULL
    GROUP BY
        1, 2, 3 -- Group by category, subcategory, and product name
    )
    -- Step 2: Calculate the percentage contribution using partitioned window functions.
    SELECT
        product_name,
        product_subcategory,
        product_category,
        MaxOriginalPrice,
        MinOriginalPrice,
        MaxProfitMargin,
        AverageProfitMargin,
        TotalRevenue,
        TotalCost,
        TotalProfit,
        AverageOrderRevenue,
        AverageOrderCost,
        AverageOrderProfit,
        -- To avoid any situation where a similar subcat's name locates in different categories
        -- I uses both category and subcategory columns in PARTITION BY of WINDOW FUNCTIONS
        -- Revenue Contribution Calculations
        ROUND((TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (PARTITION BY product_category, product_subcategory)),2) AS PRevenue_To_Subcat,
        ROUND((TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (PARTITION BY product_category)),2) AS PRevenue_To_Category,
        
        -- Cost Contribution Calculations
        ROUND((TotalCost * 100.0 / SUM(TotalCost) OVER (PARTITION BY product_category, product_subcategory)),2) AS PCost_To_Subcat,
        ROUND((TotalCost * 100.0 / SUM(TotalCost) OVER (PARTITION BY product_category)),2) AS PCost_To_Category,
        
        -- Profit Contribution Calculations
        ROUND((TotalProfit * 100.0 / SUM(TotalProfit) OVER (PARTITION BY product_category, product_subcategory)),2) AS PProfit_To_Subcat,
        ROUND((TotalProfit * 100.0 / SUM(TotalProfit) OVER (PARTITION BY product_category)),2) AS PProfit_To_Category
    FROM
        ProductLevelTotals
    ORDER BY
        product_category, product_subcategory, TotalRevenue DESC;
    ```
    * **By Region**
    ```sql
    -- Purpose: Analyze financial metrics by market and calculate its contribution to the grand total.
    -- By Market level
    -- Step 1: CTE to aggregate metrics for each market.
    WITH MarketSummary AS (
    SELECT
        CASE WHEN market IS NOT NULL THEN market
        ELSE "Others"END AS market,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit,
        ROUND(AVG(sales_after_discount), 2) AS AverageRevenue,
        ROUND(AVG(implied_cost_record_level), 2) AS AverageCost,
        ROUND(AVG(profit), 2) AS AverageProfit,
        ROUND(AVG(profit_margin_bdiscount), 2) AS AverageProfitMargin
    FROM
        `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1`
    WHERE
        EXTRACT(YEAR FROM order_date) IN (2020, 2021, 2022, 2023)
    GROUP BY
        CASE WHEN market IS NOT NULL THEN market
        ELSE "Others"END
    )
    -- Step 2: Calculate contribution percentage against the grand total, rounded to 2 decimal places.
    SELECT
        *,
        ROUND((TotalRevenue * 100.0 / SUM(TotalRevenue) OVER ()), 2) AS RevenueContributionPercent,
        ROUND((TotalCost * 100.0 / SUM(TotalCost) OVER ()), 2) AS CostContributionPercent,
        ROUND((TotalProfit * 100.0 / SUM(TotalProfit) OVER ()), 2) AS ProfitContributionPercent
    FROM
        MarketSummary
    ORDER BY
        TotalRevenue DESC;

    -- By Region level
    -- Step 1: CTE to aggregate metrics for each region, keeping the market for partitioning.
    WITH RegionSummary AS (
    SELECT
        CASE WHEN region IS NOT NULL THEN region
        ELSE "Others"END AS region,
        CASE WHEN market IS NOT NULL THEN market
        ELSE "Others"END AS market,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit,
        ROUND(AVG(sales_after_discount), 2) AS AverageRevenue,
        ROUND(AVG(implied_cost_record_level), 2) AS AverageCost,
        ROUND(AVG(profit), 2) AS AverageProfit,
        ROUND(AVG(profit_margin_bdiscount), 2) AS AverageProfitMargin
    FROM
        `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1`
    WHERE
        EXTRACT(YEAR FROM order_date) IN (2020, 2021, 2022, 2023)
    GROUP BY
        CASE WHEN market IS NOT NULL THEN market
        ELSE "Others"END, 
        CASE WHEN region IS NOT NULL THEN region
        ELSE "Others"END
    )
    -- Step 2: Calculate contribution percentage against the parent market total, rounded to 2 decimal places.
    SELECT
        *,
        --Analyze financial metrics by region and calculate its contribution to its respective market.
        ROUND((TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (PARTITION BY market)), 2) AS RevenueContributionMarket,
        ROUND((TotalCost * 100.0 / SUM(TotalCost) OVER (PARTITION BY market)), 2) AS CostContributionMarket,
        ROUND((TotalProfit * 100.0 / SUM(TotalProfit) OVER (PARTITION BY market)), 2) AS ProfitContributionMarket
    FROM
        RegionSummary
    ORDER BY
        market, TotalRevenue DESC;

    -- By Country
    -- Purpose: Analyze financial metrics by country and calculate its contribution to both its region and its market.
    -- Step 1: CTE to aggregate metrics for each country, keeping parent columns for partitioning.
    WITH CountrySummary AS (
    SELECT
        CASE WHEN country IS NOT NULL THEN country
        ELSE "Others"END AS country,
        CASE WHEN region IS NOT NULL THEN region
        ELSE "Others"END AS region,
        CASE WHEN market IS NOT NULL THEN market
        ELSE "Others"END AS market,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit,
        ROUND(AVG(sales_after_discount), 2) AS AverageRevenue,
        ROUND(AVG(implied_cost_record_level), 2) AS AverageCost,
        ROUND(AVG(profit), 2) AS AverageProfit,
        ROUND(AVG(profit_margin_bdiscount), 2) AS AverageProfitMargin
    FROM
        `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1`
    WHERE
        EXTRACT(YEAR FROM order_date) IN (2020, 2021, 2022, 2023)
    GROUP BY
        CASE WHEN country IS NOT NULL THEN country
        ELSE "Others"END,
        CASE WHEN market IS NOT NULL THEN market
        ELSE "Others"END, 
        CASE WHEN region IS NOT NULL THEN region
        ELSE "Others"END
    )
    -- Step 2: Calculate two sets of contribution percentages, rounded to 2 decimal places.
    SELECT
        *,
        -- Contribution to the parent Region
        ROUND((TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (PARTITION BY market, region)), 2) AS RevenueToRegion,
        ROUND((TotalCost * 100.0 / SUM(TotalCost) OVER (PARTITION BY market, region)), 2) AS CostToRegion,
        ROUND((TotalProfit * 100.0 / SUM(TotalProfit) OVER (PARTITION BY market, region)), 2) AS ProfitToRegion,
        
        -- Contribution to the parent Market
        ROUND((TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (PARTITION BY market)), 2) AS RevenueToMarket,
        ROUND((TotalCost * 100.0 / SUM(TotalCost) OVER (PARTITION BY market)), 2) AS CostToMarket,
        ROUND((TotalProfit * 100.0 / SUM(TotalProfit) OVER (PARTITION BY market)), 2) AS ProfitToMarket
    FROM
        CountrySummary
    ORDER BY
        market, region, TotalRevenue DESC;

    -- By State
    -- Purpose: Analyze financial metrics by state and calculate its contribution to its respective country.
    -- Step 1: CTE to aggregate metrics for each state, keeping all parent columns for partitioning.
    WITH StateSummary AS (
    SELECT
        CASE WHEN state IS NOT NULL THEN state
        ELSE "Others"END AS state,
        CASE WHEN country IS NOT NULL THEN country
        ELSE "Others"END AS country,
        CASE WHEN market IS NOT NULL THEN market
        ELSE "Others"END AS market,
        SUM(sales_after_discount) AS TotalRevenue,
        SUM(implied_cost_record_level) AS TotalCost,
        SUM(profit) AS TotalProfit,
        ROUND(AVG(sales_after_discount), 2) AS AverageRevenue,
        ROUND(AVG(implied_cost_record_level), 2) AS AverageCost,
        ROUND(AVG(profit), 2) AS AverageProfit,
        ROUND(AVG(profit_margin_bdiscount), 2) AS AverageProfitMargin
    FROM
        `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1`
    WHERE
        EXTRACT(YEAR FROM order_date) IN (2020, 2021, 2022, 2023)
    GROUP BY
        CASE WHEN country IS NOT NULL THEN country
        ELSE "Others"END,
        CASE WHEN market IS NOT NULL THEN market
        ELSE "Others"END, 
        CASE WHEN state IS NOT NULL THEN state
        ELSE "Others"END
    )
    -- Step 2: Calculate contribution percentage against the parent country total, rounded to 2 decimal places.
    SELECT
        *,
        ROUND((TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (PARTITION BY market, country)), 2) AS RevenueToCountry,
        ROUND((TotalCost * 100.0 / SUM(TotalCost) OVER (PARTITION BY market, country)), 2) AS CostToCountry,
        ROUND((TotalProfit * 100.0 / SUM(TotalProfit) OVER (PARTITION BY market, country)), 2) AS ProfitToCountry
    FROM
        StateSummary
    ORDER BY
        market, country, TotalRevenue DESC;
    ```

---

#### Project Structure

The repository is organized as follows: (to be continuously updated in the upcoming time)

```text
data/                                                 # For the datasets
│   └── customer.csv
│   └── ecom_sales.csv
│   └── product.csv
│   └── region.csv   
├── docs/                                                  # For Data Availability, Data Modeling
│   └── Data Availability checking_Define Analytical Layers_AnalysisFlow_11.07.pdf
│   └── Data Availability checking_ERDDiagram_28.06.drawio
│   └── Data Availability checking_FoundationLogic-Testcases_DataExplorationFindings_11.07.pdf
│   └── Project Initialization_CreateProjectPlan_Status_11.07.pdf
│   └── SQL Layers - Warehousing and Modeling_DataDictionary_16.07.pdf
│   └── SQL Layers - Warehousing and Modeling_DataLineage_16.07.pdf
├── Img/                                               # For images demonstrating project steps
│   ├── Connection Setup_SetupCloudEnvironment_ManualSchemaPartitioning_01.07.png
│   ├── Connection Setup_SetupCloudEnvironment_Partitioningsettings_01.07.png
│   ├── Data Availability checking_Define Analytical Layers_AnalysisFlow_11.07.png
│   ├── Data Availability checking_ERDDiagram_28.06.png
│   ├── Data Availability checking_FoundationLogic-TestCases_Data Exploration Findings_11.07.png
│   └── SQL Layers - Warehousing and Modeling_DataLineage_16.07.png
├── Scripts/
|   ├──Bronze Layer
|   |   ├── BRONZE_Metadata_all 4 tables.sql
│   ├── Silver Layers - SQL Refining
│   │   ├── SILVER_EDA_e_commerce.customer.sql
│   │   ├── SILVER_Logic of Sales_Quantity_Discount_Cost
│   │   │   ├── TC1.1_productview_quantity_sales.sql
│   │   │   ├── TC1.2_productview_totalthroughtime.sql
│   │   │   ├── TC2_discountview.sql
│   │   │   ├── TC3_orderview_withcountry.sql
│   ├── Gold Layers - Warehousing and Modeling
│   │   ├── GOLD_vw_Master_Modeling_Data_v1_16.07.sql
│   │   ├── GOLD_SQL_Time_Analyze Cost and Revenue.sql
│   │   ├── GOLD_SQL_Time_Transaction-level Statistical and Profit analysis.sql
│   │   ├── GOLD_SQL_Region_Revenue Cost_TotalAverageContribution_RegionLevel.sql
│   │   ├── GOLD_SQL_Product_Cat Subcat and Product line_in Total and Contribution.sql
│   │   ├── GOLD_SQL_Customer_Revenue Cost_Total and Average_Demographic.sql
├── Tests/  
├── .gitignore                                            # Specifies intentionally untracked files
└── README.md                                             # This file!
