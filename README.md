# Project: e-commerce-analysis

**Author:** NGUYEN PHAM
**Date:** July 01, 2025
**Contact:** nguyen.pham961309@gmail.com | [https://www.linkedin.com/in/khoinguyenpham/]
---

## 📌 Table of Contents

This document outlines the structure of the e-commerce analysis project. **Click the links below to jump directly to the corresponding section in the main notebook.**

1.  [**Introduction & Objectives**](#1-introduction--objectives)
2.  [**Data Modeling**](#2-data-modeling)
    -   [2.1 Analytical layers](#21--analytical-layers)
    -   [2.2 Data Lineage](#22--data-lineage)
    -   [2.3 Entity Relationship Diagram](#23--entity-relationship-diagram)
    -   [2.4 Data Dictionary](#24--data-dictionary)
3.  [**Tools & Technologies Used**](#3-tools--technologies-used)
4.  [**Task Solutions**](#4-task-solutions)
    -   [4.1 ETL the source files with Google BigQuery](#41-etl-the-source-files-with-google-bigquery)
    	-   [Bronze Layer](#411-bronze-layer)
    	-   [Silver Layer](#412-silver-layer)
    	-   [Gold Layer](#413-gold-layer)
    -   [4.2 Analysis with Google Colab](#42-eda-with-google-colab-using-python-and-related-libraries-pandas-numpy-matplotlib-seaborn))
      	-   [To connect with Big Query](#421-to-connect-with-bigquery)
       	-   [To transform and load the database from BigQuery to Google Colab](#422-to-transform-and-load-the-database-from-bigquery-to-google-colab)
        -   [General exploration of the Master view](#423-general-exploration-of-the-master-view)
        -   [Univariate analysis](#424-univariate-analysis)
        	- [Box plot - Gross sales](#4241-gross-sales-with-logged-scale-plot)
        	- [Box plot - Profit margin](#4242-profit-with-specific-symmetric-logged-scale-plot)
        	- [Density plot and Histograms](#4243-density-plot-and-histograms-for-specific-columns)
        	- [Density plot - Gross sales](#4244-density-plot---gross-sales)
        	- [Density plot - Profit](#4245-density-plot---profit)
        	- [Density plot - Annual income](#4246-density-plot---annual-income)
    		- [Density plot - Questions for further exploration](#4247-questions-for-further-investigations)
        	- [Density plot - Discounts](4248-density-plot---discounts)

---
## 📝 Project Planning & Management (Notion)

The entire project lifecycle, from initial brainstorming to task tracking and final documentation, was managed using Notion. You can view the public project planning board and related documents at the link below.

- **[View the Full Project Plan on Notion](https://www.notion.so/E_commerce-project_SQL-22087cc4273f8034ac63dec17e820406?source=copy_link)**

---

## 🚀 Full Analysis Notebook

The complete code, visualizations, and detailed findings can be found in the main project notebook:

- **[e-commerce-analysis.ipynb](https://colab.research.google.com/drive/1SAVQj1F1GnejoYx-lYqwfF6wpi5Zf9cc?authuser=2#scrollTo=CPm6mjMtc1wr)**

---
## ⚙️ How to Run This Project

1.  Clone the repository: `git clone <https://github.com/NguyenPham1309/e-commerce-analysis>'
2.  Ensure you have the necessary libraries installed: `pandas`, `numpy`, `seaborn`, `matplotlib`, `google-cloud-bigquery`.
3.  Open and run the `e-commerce-analysis.ipynb` notebook in a Jupyter or Google Colab environment.

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

### 2.1 🏁 **Analytical layers**
![Define Analytical Layers - Analysis Flow](https://github.com/user-attachments/assets/5e90a8cb-d102-402f-ad44-bef0a9616884)

### 2.2 💡 **Data Lineage**
![Warehousing and Modeling_Data Lineage](https://github.com/user-attachments/assets/3a8fa59d-3e01-4d7b-a4b3-9ccf705fed4b)

### 2.3 ⛯ **Entity Relationship Diagram**
<img width="1040" height="753" alt="Data Availability checking_ERDDiagram_28 06" src="https://github.com/user-attachments/assets/d50f0557-c71e-4ff5-bab1-95c7db7671e9" />

⛯ **Setting partitioning column in the fact table**
* **Using the column order_date as the partitioning column for better performance and cost-saving while querying on BigQuery**

<img width="641" height="357" alt="Connection Setup_SetupCloudEnvironment_Partitioningsettings_01 07" src="https://github.com/user-attachments/assets/ce7be7f1-7bf1-4d3e-84a3-2d4a3bcb1d13" />

### 2.4 📜 **Data Dictionary**
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
### 4.1 ETL the source files with Google BigQuery
#### 4.1.1 Bronze Layer
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

#### 4.1.2 Silver Layer
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

#### 4.1.3 Gold Layer
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
### 4.2 EDA with Google Colab using Python and related libraries (Pandas, Numpy, Matplotlib, Seaborn)
#### 4.2.1 To connect with BigQuery

```python
# ==============================================================================
# STEP 1: AUTHENTICATE YOUR COLAB NOTEBOOK
# This is the standard way to authenticate in Google Colab.
# It will trigger a pop-up window to ask for the permission.
# ==============================================================================
from google.colab import auth
auth.authenticate_user()
print('Authenticated successfully.')

# Set the project ID to the Google Cloud Project.
# This tells all subsequent gcloud commands which project to use by default.
!gcloud config set project e-commerce-sql-project-464611

# ==============================================================================
# STEP 2: INITIALIZE THE BIGQUERY CLIENT
# This sets up the connection object that will send our queries.
# ==============================================================================
from google.cloud import bigquery
import pandas as pd
```
#### 4.2.2 To transform and load the database from BigQuery to Google Colab

* **Sampling method**
```python
# ==============================================================================
# 1. USING THE SAMPLING IDEA TO TEST THE DATA
# ==============================================================================
#Using triple quotes. It is more clean, readable and manageable
#First, I load the master view to randomly check the data
#I use xx% to get around 10K-50K rows for sample EDA

# ==============================================================================
# INTERACTIVE SCRIPT TO GET SAMPLE FRACTION FROM USER
# ==============================================================================

# ===================================================================
# PART 1: DEFINE THE HELPER FUNCTION
# This function's only job is to get a valid input from the user.
# ===================================================================
def get_sample_fraction():
  while True:
    #User input of sample fraction:
    input_sfr = input("Enter the desired sample fraction: ")

    #Using try-except to handle the input value
    try:
      sample_fraction = float(input_sfr)
      #Check to see if the sample fraction in the valid range
      if 0 < sample_fraction < 2:
        print(f"Valid fraction, going to use the fraction of {sample_fraction} to take the sample from the Master view")
        return sample_fraction
      else:
        #Demonstrates an error: the fraction is out of range and cannot be used as an input:
        print("Eror: The fraction is out of value range, please type again: ")
    except ValueError:
      print("The input fraction is invalid. Please enter a decimal type of value (e.g., 0.001)")

# ===================================================================
# PART 2: THE MAIN SCRIPT LOGIC
# This is the main "engine" of your program. It uses the helper
# function to do its work.
# ===================================================================
print("Starting the sampling process")
while True:
  #1. Call our function above to get the sample_fraction from user
  sample_fraction = get_sample_fraction()

  #2 Building the SQL query based on the input sample_fraction above
  sql_query = f"""
  SELECT
    *
  FROM
  `e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1`
  WHERE RAND() < {sample_fraction}
    AND EXTRACT (YEAR FROM order_date) in (2020, 2021, 2022, 2023)
  """

  #3 Execute the query and load it into a dataframe
  print(f"Executing the query to sample approximately of {sample_fraction * 100:.3f}% from the Master view...")
  df_view = client.query(sql_query).to_dataframe()

  #4 Check the number of the columns to see if it is enough data (even sampling or full population)
  num_rows = df_view.shape[0]
  if 10000 < num_rows < 50000:
    print(f"The sample includes {num_rows}, ready to use. ")
    break
  elif num_rows <= 10000:
    print(f"The {num_rows} is not enough, you need to increase the sample_fraction")
  else:
    print(f"The {num_rows} is bigger than expected, you want to reduce the sample fraction to get better loading performance")

# When the break situation (the proper and correct value input), the statement announces that the exploration can be continued:
print("Data sampling complete. Proceeding with analysis")
```

* **Full loading of data (possible in this case of under 150K rows)**
```python
# ==============================================================================
# 2. OR USING THE WHOLE DATASET IF THE NUMBER OF ROWS ARE DECENT ENOUGH
# ==============================================================================

#1 Building the SQL query based on the input sample_fraction above
sql_query = f"""
SELECT
  *
FROM
`e-commerce-sql-project-464611.my_server_data.vw_Master_Modeling_Data_v1`
WHERE EXTRACT (YEAR FROM order_date) in (2020, 2021, 2022, 2023)
"""

#3 Execute the query and load it into a dataframe
print(f"Executing the query to load full data from the Master view")
df_view = client.query(sql_query).to_dataframe()
print("Data sampling complete. Proceeding with analysis")
```
* **Import the necessary libraries**
```python
# Import the necessary libraries
import seaborn as sns
import matplotlib.pyplot as plt
import math
import numpy as np
```
#### 4.2.3 General exploration of the Master view
```python
Display the first few rows to confirm it loaded correctly
print(df_view.head(5))

Get a summary of the data types and null values
df_view.info()

Get description statistics for the numerical columns
df_view.describe()
```
```python
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 51290 entries, 0 to 51289
Data columns (total 30 columns):
```python

| # | Column | Non-Null Count | Dtype  
|:---:|  :----------------------  | :------------: | :----- |                
| 0   |  row_id                   | 51290 non-null | Int64  | 
| 1   |  order_id                 | 51290 non-null | object | 
| 2   | order_date                | 51290 non-null | dbdate | 
| 3   |  gross_sales              | 51290 non-null | object | 
| 4   | discount                  | 51290 non-null | object | 
| 5   |  quantity                 | 51290 non-null | Int64  | 
| 6   |  profit                   | 51290 non-null | object | 
| 7   |  sales_after_discount     | 51290 non-null | object | 
| 8   |  unit_price_bdiscount     | 51290 non-null | object | 
| 9   |  profit_margin_bdiscount  | 51290 non-null | object | 
| 10  | implied_cost_record_level | 51290 non-null | object | 
| 11  | implied_unit_cost         | 51290 non-null | object | 
| 12  | customer_id               | 51290 non-null | object | 
| 13  | birth_date                | 51290 non-null | dbdate | 
| 14  | marital_status            | 51290 non-null | object | 
| 15  | gender                    | 50928 non-null | object | 
| 16  | annual_income             | 51290 non-null | Int64  | 
| 17  | education_level           | 51290 non-null | object | 
| 18  | occupation                | 51290 non-null | object | 
| 19  | home_owner                | 51290 non-null | boolean|
| 20  | product_code              | 51288 non-null | object |
| 21  | product_name              | 51288 non-null | object |
| 22  | product_category          | 51288 non-null | object |
| 23  | product_subcategory       | 51288 non-null | object |
| 24  | region_code               | 51288 non-null | object |
| 25  | market                    | 51288 non-null | object |
| 26  | region                    | 51288 non-null | object |
| 27  | country                   | 51288 non-null | object |
| 28  | state                     | 51288 non-null | object |
| 29  | city                      | 51288 non-null | object |

```python
dtypes: Int64(3), boolean(1), dbdate(2), object(24)
memory usage: 11.6+ MB
```
* **Change numeric columns into truly numeric type of int64 or float 64**
```python
# Not every numeric columns are truly recognized as int64 or float64.
# Therefore, I need to convert them into the logically correct numeric type

# List of columns that should be numeric but are currently 'object' type
columns_to_convert = [
    'gross_sales',
    'discount',
    'profit',
    'sales_after_discount',
    'unit_price_bdiscount',
    'profit_margin_bdiscount',
    'implied_cost_record_level',
    'implied_unit_cost'
]
print("Converting columns to numeric type...")

# Converting by looping through each column in the list
for col in columns_to_convert:
  df_view[col] = pd.to_numeric(df_view[col], errors = 'coerce')
  print(f"Convert the column {col} successfully")

print("\nConversion completed!")

#Review to see how many converted value above
print("\nChecking for NaN (Not a number) during the conversion")
print(df_view[columns_to_convert].isnull().sum())
```python
```python
New DataFrame info:
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 51290 entries, 0 to 51289
Data columns (total 30 columns):
```
![Transforming numeric columns](https://github.com/NguyenPham1309/e-commerce-analysis/blob/main/Img/Numeric%20columns_EDA_05.08.png)

* **Handling null values in the gender column**
```python
# Handling null values in the gender column
df_view.isnull().sum()

# Counting the number of each value in gender column
print(df_view['gender'].value_counts(dropna=False))

# Fill all NaN values with the string 'Other'
df_view['gender'] = df_view['gender'].fillna('Other')

#Checking after state of edition
print(df_view['gender'].value_counts())
gender
M       25735
F       25193
None      362
Name: count, dtype: int64
```

* **First exploration from the stats of numeric column**
```python
#===============================================================================
# GROSS SALES AND RELATED DERIVED COLUMNS
#===============================================================================
# The mean gross sales are double than its median. It means the gross sales are also skewed right
# Gross sales and profit are two independently original columns, which means there are rooms to look at their gap (cost)
# At the 75th percentile and max value, the gap is much bigger than the rest of the gross sales: Most orders are small, but few in the final quarter pulled up the mean
# The same status can be seen in sales related columns (sales after discount, unit price before discount)

#===============================================================================
# DISCOUNT
#===============================================================================
# Most of the transaction do not have discount (the 50th percentile still 0 discount
# Discounts apply max at 85%. There are very unique transactions and products with particular discount treatment

#===============================================================================
# PROFIT
#===============================================================================
# Profit is highly skewed right. Mean is larger than median (20.77 > 7.2)
# Min profit is smaller than 0, which means there are lost in several transactions or products
# The standard deviation is too much larger than the mean. It is the signal that the profit is quite volatile and unstable among the transaction record

#===============================================================================
# ANNUAL INCOME
#===============================================================================
# Centered around the area of 50K - 60K 
# Right skewed with several high salary goes up to 170K
```
#### 4.2.4 Univariate analysis

```python
#===============================================================================
# UNIVARIATE ANALYSIS
# Mainly using boxplot, density plot and histograms
# Correlation analysis to find the relationship between variables
#===============================================================================

#===============================================================================
# BOX PLOT DISTRIBUTION
#===============================================================================

# List of numeric columns
numeric_cols = df_view.select_dtypes(include=['float64', 'int64']).columns

# Calculate the grid size needed for the subplots
n_cols = 3
n_rows = math.ceil(len(numeric_cols) / n_cols)

# Create a figure and a grid of subplots
fig, axes = plt.subplots(n_rows, n_cols, figsize=(15, n_rows * 4))

# To turn the 2D plot above of axes into one long list
axes = axes.flatten()

# Loop through each numeric column and create a boxplot on a separate subplot
for i, col in enumerate(numeric_cols):
    sns.boxplot(data=df_view, y=col, ax=axes[i])
    axes[i].set_title(f'Distribution of {col}')
    axes[i].set_ylabel('') # Clear the y-label for cleaner look

# Hide any unused subplots
for i in range(len(numeric_cols), len(axes)):
    fig.delaxes(axes[i])

# Adjust the layout to prevent titles from overlapping
plt.tight_layout()
plt.show()

#===============================================================================
# HANDLING SQUASHED BOX PLOT
#===============================================================================

# This includes gross sales column, and the derived columns from it
# This is because there are many high-value outliers that squeeze the box into an invisible box. The values must be scaled to an extent where we can clearly see the box demonstration
```
![Box plot Analysis](https://github.com/NguyenPham1309/e-commerce-analysis/blob/main/Img/Boxplot%20Analysis_UnivariateAnalysis_EDA_05.08.png)

:heavy_exclamation_mark: Beacuse there are two specific different sets of box plots: one set of quite "normal" looking box plot, for example, Row ID (because of unique values characteristic), annual income (with slightly right skewed), and profit margin (Centered around 0.2), one set of box plot related to Gross sales and its derivied KPI. Therefore, the next step should be to focus on how we can further explore those squashed box plots.

:interrobang: However, different metrics contain different characteristics that may affect how we can handle the squashed box (contains negative values, only positive values, discrete values, or practical continuous values). A single solution for all of these box plots is not effective - we must adapt to its uniqueness - even they are in the same section of numeric data types

##### 4.2.4.1 Gross Sales (with Logged Scale plot)
```python
#===============================================================================
# GROSS SALES box plot original and logging scale
#===============================================================================

# Create the plot area
# fig is the whole big frame, axes is individual subplots when having multiple plots
fig, axes = plt.subplots(1,2, figsize =(12,6)) #1 row, 2 columns, figsize 12 inches wide 6 inches tall

'''
fig (The entire canvas, 12x6 inches)
+------------------------------------------------------+
|                                                      |
|      axes[0] (The first subplot)      axes[1] (The second subplot) |
|   +-------------------------+    +-------------------------+   |
|   |                         |    |                         |   |
|   |                         |    |                         |   |
|   |                         |    |                         |   |
|   |     (Plotting Area 1)   |    |     (Plotting Area 2)   |   |
|   |                         |    |                         |   |
|   |                         |    |                         |   |
|   |                         |    |                         |   |
|   +-------------------------+    +-------------------------+   |
|                                                      |
+------------------------------------------------------+
'''
# Make bot plox of gross sales
# First the box plot for the original column of gross sales
df_view['gross_sales'].plot.box(ax=axes[0])
axes[0].set_title('Original Plot (Squashed)')
axes[0].set_ylabel('Gross Sales $')

# Then the box plot for the logging scale column of gross sales
df_view['gross_sales'].plot.box(ax=axes[1], logy = True)
axes[1].set_title('Logged scale Plot')
axes[1].set_ylabel('Gross Sales $ - Log Scale')
```
![Box plot Analysis](https://github.com/NguyenPham1309/e-commerce-analysis/blob/main/Img/Boxplot%20Analysis_Gross%20sales_EDA_12.08.png)

* **Analysis of Gross Sales**
1. Original box plot: Gross sales contains extremely high value by transaction (by product)
2. New logged scale plot:
```python
IQR: $22 - $150 = $128 (50% of transaction)
Median: $53
Whiskers: $1 - $280
Outliers: from over $280 to $thousands
The analysis of the logged scale box plot reveals that the median gross sale is approximately $53.
The central 50% of all sales fall between $22 (Q1) and $150 (Q3).
The data ranges from a minimum of $1 up to a maximum 'normal' value of $280,
with a significant number of outliers beyond that point, reaching into the thousands of dollars.
```

:ballot_box_with_check: **Insight** Most of the orders are in the standardized and reasonable sales of an e-commerce platform. However, the long tail of outliers may reveal more insights about how they grow their business.

:question: **Question** Are those outliers from a few whale customers or from specific products?

##### 4.2.4.2 Profit (with specific symmetric logged scale plot)
The box plot for profits must be treated with caution because of potential negative values. This can be handled either by using a flag column (partitioned column also) while modeling the data, or by treating them with caution while doing the EDA step. In this case, I will use the symmetric logging scale to handle the negative values of profit

```python
# Create the plot area
# fig is the whole big frame, axes is individual subplots when having multiple plots
fig, axes = plt.subplots(1,3, figsize =(18,6)) #1 row, 3 columns , figsize 18 inches wide 6 inches tall

# Make bot plox of gross sales
# First the box plot for the original column of profit
df_view['profit'].plot.box(ax=axes[0])
axes[0].set_title('Original Plot (Squashed)')
axes[0].set_ylabel('Profit $')

# Then the box plot for the symlogging scale column of profit
df_view['profit'].plot.box(ax=axes[1])
axes[1].set_yscale('symlog', linthresh=10)
axes[1].set_title('Symlogged scale Plot')
axes[1].set_ylabel('Profit $ - Symlogged Scale')

# Looking the profit margin to see there are % margin centered around 0.2, and there are negative profit margin
df_view['profit_margin_bdiscount'].plot.box(ax=axes[2])
axes[0].set_title('Original Plot')
axes[0].set_ylabel('Profit margin %')
```
![Box plot analysis](https://github.com/NguyenPham1309/e-commerce-analysis/blob/main/Img/Boxplot%20Analysis_Profit_EDA_12.08.png)

* **Analysis of Profit**
**Symlogged scale plot analysis**
```python
# New symlogged scale plot:
# 1. IQR: $0 - $20 = $20 (50% of transaction)
# 2. Median: $8
# 3. Whiskers: -50$ - $70
# 4. Outliers: Negative side from over -$50 to $thousands.
Positive side:from over $70 to thousands
```
:ballot_box_with_check: **Insight** Our analysis shows that a typical transaction is slightly profitable, with a median profit of about $8. The core 50% of our business generates profits between $0 and $20. However, the overall picture is one of high variability. While the range for normal transactions is between a $50 loss and a $70 profit, we have a significant number of extreme outliers on both ends, with some transactions generating thousands in profit and others thousands in losses.
This suggests we should investigate what drives these extreme outcomes.

:exclamation:Furthermore, the IQR starts at $0 means at least 25% of the recorded transactions are not profitable. It matches the profit margin plot. The profit margin bdiscount confirmed this issue. There are outliers with the negative profit margin of up to 80%

❓ **Questions**
1. Is this a data quality issue? - Maybe the problem is how the source data feeds into my calculation.
2. Is this an intentional loss to buy more profitable products?
3. High discounts vs. negative profits?

### **Data Validation and Assumptions**
🌠 **Finding**: The Exploratory Data Analysis revealed a significant number of transactions with extreme negative profit margins, some exceeding -80%. These outliers have a substantial impact on summary statistics.

:o: **Limitation**: As this is a public dataset for portfolio use, it is not possible to perform root cause analysis by tracing these transactions back to the source e-commerce and financial systems.

:closed_book: **Working assumption**: Hence, for the purpose of this analysis, the provided sales, profit, and discount figures are treated as accurate as-is.

:bulb:**Recommendation in a Business Context**: If this were a live business project, my immediate recommendation would be to flag the order_ids and row_ids for these specific outlier transactions. A follow-up investigation with the Operations or Finance team would be necessary to validate whether these data points represent:
1. Data entry errors (e.g., incorrect cost-of-goods-sold).
2. System processing errors (e.g., product returns being incorrectly categorized as sales).
3. Legitimate but extreme business events (e.g., clearance of expired stock, promotional bundles) that need to be understood.

##### 4.2.4.3 Density plot and Histograms for Specific columns
1. There are five different variables that need to be further explored by using density plots. Density plots are helpful to understand the nature of the data distribution, and can partially explain our initial observation from the Boxplot analysis above. These five variables are:
```python
# Gross sales: the fundamental measures of revenue
# Profit: The fundamental measures of profitability. It is independently given from each transaction.
# Annual income: A key independent demographic feature, discrete value type
# Discount: A density plot to reveal discounting strategy
# Quantity: A histogram to reveal a typical basket type
```
2. Other columns contain a linear relationship with the gross sales (they are calculated based on gross sales, profit, quantity, and discount). Thus, they have similar distributions of gross sales.
3. Similar to boxplot usage, different metrics contain different characteristics that may affect how we can handle each one while using density plot. We will have a look at each of the variable to see the difference

##### 4.2.4.4 Density plot - Gross sales
```python
fig, axes = plt.subplots(1,2, figsize =(16,6))

# Density plot for gross sales
# Combines the histogram and KDE in one function
ax1 = sns.histplot(
    data = df_view,
    x='gross_sales',
    kde=True, #to add the histogram into the density plot below
    #log_scale=True
    ax=axes[0]
)
ax1.set_title('Distribution of Gross Sales (Original)', fontsize=16)
ax1.set_xlabel('Gross Sales (Original)')
ax1.set_ylabel('Frequency')

# Logging scale of combine graphs
ax2 = sns.histplot(
    data = df_view,
    x='gross_sales',
    kde=True, #to add the histogram into the density plot below
    log_scale=True,
    ax=axes[1]
)
ax2.set_title('Distribution of Gross Sales (Log Scale)', fontsize=16)
ax2.set_xlabel('Gross Sales (Log Scale)')
ax2.set_ylabel('Frequency')
```
![Density plot analysis](https://github.com/NguyenPham1309/e-commerce-analysis/blob/main/Img/Density%20analysis_Gross%20sales_EDA_!2.08.png)
* **Density plot analysis**
1. Original Plot:
```python
# A classic skewed right of the original plot
# The majority of sales are small, and a very small number of sales are extremely large
```
2. Logged scale plot:
```python
# The peak: Around $30, with nearly 2000 transactions
# Gross sales of each transaction centered around $30 - $60
# The right tail has the distribution stretching over $1000
# The KDE curve shows a clear bump; it is very likely a meaningful signal. Therefore, considering any humps excluding the median point, or the center area
# There are some high-value transactions contributing to the total revenue
# As the original plot stated, we should not use the average value for typical gross sales by transactions; the median is better
```
💡**Insight**: While the average sale is high ($127) due to a few large transactions, our most representative sale is closer to the median value of $56, which is confirmed by the peak of the log-transformed distribution

❓ **Questions**
1. A secondary hump around $15 may indicate a point of interest of a 2nd type of transaction
 - What is happening at the $15 price point that is different from what's happening at the $50 price point of the median?
 - We can explore the point further with other categorical values.
2. The data shows that transactions below $10 are infrequent.
 - Activity then accelerates rapidly from $10 up to the first major peak around $15-$20.
 - So there is a soft floor when coming under $10 - rarely a transaction comes under this price

##### 4.2.4.5 Density plot - Profit
❗ Because the profit can be negative, we need 2 different pairs of density plots. One is used for the profitable side (>0), and one is for the negative profit. This would make the further analysis easier in terms of understanding what drives the profit and what hinders the profitability

```python
fig, axes = plt.subplots(2,2, figsize =(16,12))

# Flatten the 2D array of axes into a 1D array.
# Now I can access them with axes[0], axes[1], axes[2], axes[3].
axes = axes.flatten()

# Because the proft can be negative, we need to have 2 different pairs of plots
# One for profitable and one for negative profit
# Density plot for profit
# Combines the histogram and KDE in one function
ax1 = sns.histplot(
    data = df_view[df_view['profit'] > 0],
    x='profit',
    kde=True, #to add the histogram into the density plot below
    ax=axes[0],
    color='seagreen'
)
ax1.set_title('Distribution of Profit (Original)', fontsize=16)
ax1.set_xlabel('Profit (Original)')
ax1.set_ylabel('Frequency')

# Logging scale of combine graphs
ax2 = sns.histplot(
    data = df_view[df_view['profit'] > 0],
    x='profit',
    kde=True, #to add the histogram into the density plot below
    log_scale=True,
    ax=axes[1],
    color='seagreen'
)
ax2.set_title('Distribution of Profit (Log Scale)', fontsize=16)
ax2.set_xlabel('Profit (Log Scale)')
ax2.set_ylabel('Frequency')
#-------------------------------------------------------------------------------
# For negative profit
ax3 = sns.histplot(
    data = df_view[df_view['profit'] < 0],
    x='profit',
    kde=True, #to add the histogram into the density plot below
    ax=axes[2],
    color='crimson'
)
ax3.set_title('Distribution of Negative Profit (Original)', fontsize=16)
ax3.set_xlabel('Profit (Original)')
ax3.set_ylabel('Frequency')

# Logging scale of combine graphs
ax4 = sns.histplot(
    x = df_view[df_view['profit'] < 0]['profit'].abs(), #This abs is to positive all the values, preparing for the logging scale below
    kde=True, #to add the histogram into the density plot below
    log_scale=True,
    ax=axes[3],
    color='crimson'
)
ax4.set_title('Distribution of Negative Profit (Log Scale)', fontsize=16)
ax4.set_xlabel('Profit (Log Scale)')
ax4.set_ylabel('Frequency')

# Adjust layout to prevent titles/labels from overlapping
plt.tight_layout()
plt.show()
```
![Density plot](https://github.com/NguyenPham1309/e-commerce-analysis/blob/main/Img/Density%20analysis_Profit_EDA_12.08.png)

🌠 **Insights and Questions**
1. Extreme losses with the long right tail of the negative profit log scale
* Goes over $1000 of negative profit
* What are the products that makes those extremely negative profit?
* From which customers or which region?
* Is there any pattern of discounts?

2. Similar analysis for the profitable side
* Outliers of transactions where the business recognizes over $1000 profit each transactions
* What are their characteristics?

3. The highest density of both negative and positive profit around $10-$15
* Both sides are log-normal distribution
* What drives those thousands of transactions?
* Which products, countries or customers mainly contribute to that?


##### 4.2.4.6 Density plot - Annual income
❗The annual income, despite its logic of a possible continuous value, is a discrete integer value in this specific context. This characteristic affect the smoothiness of the KDE and the allocation of histogram columns. Therefore, to use the combination of KDE and histogram for this specific variable, we need to modify the bandwidth (instead of the default one from seaborn)

```python
fig, axes = plt.subplots(2,2, figsize =(24,12))

# Flatten the 2D array of axes into a 1D array.
# Now I can access them with axes[0], axes[1], axes[2], axes[3].
axes = axes.flatten()

# Annual income will be discrete type - integer value
# Combines the histogram and KDE in one function
ax1 = sns.histplot(
    data = df_view,
    x='annual_income',
    kde=True, #to add the histogram into the density plot below
    bins=25,
    ax=axes[0],
)
ax1.set_title('Distribution of Annual income (Original)', fontsize=16)
ax1.set_xlabel('Annual Income (Original)')
ax1.set_ylabel('Frequency')

# transform the data of annual income into log data type
log_annual_income = np.log(df_view['annual_income'])

ax2 = sns.histplot(
    x=log_annual_income,
    kde=True, #to add the histogram into the density plot below
    bins=25,
    ax=axes[1]
)
ax2.set_title('Distribution of Annual income (Log)', fontsize=16)
ax2.set_xlabel('Annual Income (Logged)')
ax2.set_ylabel('Frequency')

# log with modified bandwidth
log_annual_income = np.log(df_view['annual_income'])

ax3 = sns.histplot(
    x=log_annual_income,
    kde=True, #to add the histogram into the density plot below
    bins=25,
    ax=axes[2],
    kde_kws={'bw_adjust': 1.5} #Adjust the bandwidth of KDE, with bw_adjust > 1 makes it smoother

)
ax3.set_title('Distribution of Annual income (Modified Log)', fontsize=16)
ax3.set_xlabel('Annual Income (Modified log)')
ax3.set_ylabel('Frequency')

# boxplot only
sns.boxplot(
    data=df_view,
    x='annual_income',
    ax=axes[3]
    )
plt.title('Distribution of Annual Income - Boxplot', fontsize=16)
plt.xlabel('Annual Income')
plt.show()
```
![Density plot](https://github.com/NguyenPham1309/e-commerce-analysis/blob/main/Img/Density%20analysis_Annual%20income_EDA_12.08.png)

:microscope:**Analysis** 
* Based on the logged kde and histogram plot, with the adjustment to the bandwidth, we can see there are two main peak:
1. a strong primary mode at a log-income of 11
2. a distinct secondary mode around 10.5,
3. another tertiary mode, or shoulder, is visible around 9.8
*For the efficiency, we may look as a bimodal shape of distribution

```python
# Change the log value back into the normal income number
# The 2 peaks are from the analysis above
print(f'The value of 1st peak {np.expm1(11)}')
print(f'The value of 2nd peak {np.expm1(10.5)}')
print(f'The value of the shoulder {np.expm1(9.8)}')

# For segmenting the customer income later
print(f'The value of 1st valley {np.expm1(10.7)}')
print(f'The value of 2nd valley {np.expm1(10.1)}')

The value of 1st peak 59873.14171519782
The value of 2nd peak 36314.502674246636
The value of the shoulder 18032.744927828524
The value of 1st valley 44354.85513029784
The value of 2nd valley 24342.00942
```
* **Density plot of annual income - initial observation**
```python
# Combine the information of the distribution chart (kde+histogram) modified log of annual income, and the boxplot:
#1. The first distnct group centers around $60,000 (also the median)
#2. The mean around $56500 reaffirms the density of this area of $60000
#3. The 2nd group, which are based on the IQR of the data (from around $30000 to over $70000)
# and the 2nd peak of the kde+histogram plot ($36000)centers around ~$30000-$40000. This is also
#a group of density needed to be discussed further
# 4. The distribution is rightly skewed, with the normal max of income is ~$130000, and several outliers up to $160000
Does this one relate to several transactions that have extremely high gross sales, and extremely high profit?
```

:hourglass:**Recommendation**
* Based on the meaningful benchmark of income, we can
1. Thinking of labeling groups of income,
	- Low (<$25000)
	- Mid ($25000 - $45000)
	- High (>$45000)
2. The customer base was segmented into three groups based on the natural divisions observed in the income distribution.
* The boundaries were set at the local minima of the Kernel Density Estimate, ensuring an objective and reproducible segmentation

### Final story of annual income
* The income distribution is characterized by three modes of decreasing importance. We can validate their significance by mapping their locations to the data's quartiles using a boxplot:
1. The primary mode at ~$60,000 is confirmed as the most significant, as it aligns with the dataset's median.
2. A secondary mode at ~$36,000 is also highly significant, as it falls within the Interquartile Range (IQR), representing the central bulk of our data.
3. A tertiary mode, or shoulder, exists around ~$18,000. While it represents a true cluster, its location in the lower whisker of the boxplot confirms it represents a smaller, less central group within the bottom 25% of earners.

* **For the sake of creating a simplified business model, we can focus on the two primary modes within the IQR, treating the distribution as broadly bimodal.**

#### 4.2.4.7 Questions for further investigations:

**1. Profitability and Margin Analysis**
*:pushpin: **The core of the hypothesis**: Do different income groups generate fundamentally different levels of profit?
  ❓1. How does the distribution of Profit change across the Low, Mid, and High-Income Groups?
* :thought_balloon: This is the most direct test of the theory. We expect to see the "low-profit" peak dominated by the Low/Mid-Income groups and the "high-profit" peak dominated by the High-Income group.
* :thought_balloon: A stacked histogram or a violin plot grouped by income level would be perfect here.
  ❓2. What is the average profit per transaction for each income group? Is the High-Income group significantly more profitable on a per-purchase basis?
  ❓3. Which income group is most associated with negative-profit transactions? Is it the Low-Income group buying heavily discounted items, or is it the High-Income group on the receiving end of specific discounts?

**2. Sales Behavior and Customer Value**
*:pushpin: **The core of the hypothesis**: Does income dictate purchasing power and frequency?
  ❓1. Is the "long tail" of extremely high Gross Sales transactions driven exclusively by the High-Income group?
* :thought_balloon: Filter the dataset for the top 5% of sales transactions and then check the income group distribution of those customers.
* :thought_balloon: We expect the High-Income group to be overwhelmingly represented.
  ❓2. What is the difference in Average Transaction Value (ATV) versus Purchase Frequency between the income groups?
* This helps us understand customer value more deeply.
* Do High-Income customers buy expensive things infrequently, while Low-Income customers buy cheap things often? This has major implications for marketing and loyalty programs.

**3. Discount Sensitivity and Strategy**
*:pushpin: **The core of the hypothesis**Who are our discounts really for, and are they working as intended?
  ❓1. Which income group utilizes discounts most often?
* :thought_balloon: Do the Low/Mid-Income customers account for the majority of transactions using the "Standard" discount tiers (10%, 20%, 40%, etc.)?
  ❓2. Are we "wasting" margin on the High-Income group? What percentage of their purchases are made with a discount?
* :thought_balloon: If high-income customers are frequently using discounts, it could mean they wouldn't have bought the item otherwise (good), or it could mean we are giving away profit unnecessarily to customers who would have paid full price (bad).
  ❓3. Is there a link between income group and the usage of the unprofitable "Non-Standard" discounts?

**4. Product Preference and Category Alignment**
*:pushpin: **The core of the hypothesis**Do different income groups buy different types of products?
  ❓1. Are there specific Product Categories that are disproportionately purchased by each income group?
* :thought_balloon: For example, does the High-Income group buy more "Technology," while the Low-Income group buys more "Office Supplies"?
* :thought_balloon: This can inform inventory management, store layouts, and targeted advertising.
  ❓2. What are the top 5 most profitable products for each income group?
* :thought_balloon: Are we successfully marketing our high-margin products to our high-income customers?

##### 4.2.4.8 Density plot - Discounts

## Project Structure

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
|   ├──EDA process
│   │   ├── To connect, transform, and load the SQL database into Google Colab
├── Tests/  
├── .gitignore                                            # Specifies intentionally untracked files
└── README.md                                             # This file!
