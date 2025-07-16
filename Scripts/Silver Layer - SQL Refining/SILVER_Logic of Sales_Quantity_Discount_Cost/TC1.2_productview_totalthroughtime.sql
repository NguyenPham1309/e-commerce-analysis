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


