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
--While the methods above work perfectly, the most efficient way to filter a date range 
--is to avoid running functions on the column in the WHERE clause. 
--This allows the database to use an index on the order_date column if one exists. 
--The best practice is to define a date range.
