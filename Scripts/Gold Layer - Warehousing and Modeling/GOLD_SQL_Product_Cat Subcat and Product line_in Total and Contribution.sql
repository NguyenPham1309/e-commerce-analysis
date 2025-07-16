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