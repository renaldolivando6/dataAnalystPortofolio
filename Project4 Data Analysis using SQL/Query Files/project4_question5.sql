# Question 5: What product sold the most?
SELECT
product,
SUM(quantity_ordered)
FROM
merged_sales_data
GROUP BY product
ORDER BY SUM(quantity_ordered) DESC;