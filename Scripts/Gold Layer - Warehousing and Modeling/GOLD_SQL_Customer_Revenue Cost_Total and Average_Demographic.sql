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