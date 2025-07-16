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

