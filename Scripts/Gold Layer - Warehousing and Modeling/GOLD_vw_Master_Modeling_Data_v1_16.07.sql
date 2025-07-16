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