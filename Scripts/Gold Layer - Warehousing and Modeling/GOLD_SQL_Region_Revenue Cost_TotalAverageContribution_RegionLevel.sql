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
