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