# Question 4: What products are most often sold together?

## 2 products combination
-- using INNER JOIN
SELECT a.product AS original_SKU, b.product AS bought_with, count(a.order_id) as times_bought_together
FROM merged_sales_data AS a
INNER JOIN merged_sales_data AS b ON a.order_id = b.order_id
AND a.product < b.product
GROUP BY a.product,b.product
order by times_bought_together DESC;

## 3 products combination 
-- Find order ID with 3 different products
select
order_id from(
select
*,
row_number() over(partition by order_id order by order_id) as row_num
from merged_sales_data) as t1
where row_num =3;

-- Select all column with order id that contained 3 products
SELECT * FROM merged_sales_data
WHERE order_id IN (select order_id from( select *,
				row_number() over(partition by order_id order by order_id) as row_num
					from merged_sales_data) as t1
					where row_num =3);
                    
-- Combine 3 products listed into 1 rows using GROUP_CONCAT 
-- from dataset we created above (all columns only contain order id with 3 products)
select
3Product_combination, count(3Product_combination)
from (select order_id, group_concat(product separator ",") as 3Product_combination
		from (
				SELECT * FROM merged_sales_data
				WHERE order_id IN (
									select order_id from(
                                    select *, row_number() over(partition by order_id order by order_id, product) as row_num
			-- Make sure row_number() order by order_id & product
            -- so we won't meet value like ABC, ACB, BCA in seperate rows
									from merged_sales_data) as t1
					where row_num =3)) t2 
        group by order_id) as t3
group by 3Product_combination
order by count(3Product_combination) desc;