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