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