# Question 1: What was the best time for sales?
-- Check date in our data
select 
distinct YEAR(order_date)
from merged_sales_data;

-- Check the last date in our data
select
max(order_date)
from merged_sales_data;

-- Aggregate total_cost to find monthly sales
select 
month,
round(sum(total_cost)) as monthly_total
from merged_sales_data
where order_date  BETWEEN '2019-01-01' AND '2020-01-01'
group by month
order by monthly_total desc;

-- Aggregate total_cost to find quarterly sales
select 
quarter(order_date),
round(sum(total_cost)) as quarterly_total
from merged_sales_data
where order_date  BETWEEN '2019-01-01' AND '2020-01-01'
group by quarter(order_date)
order by quarterly_total desc;

# Question 2: Which city sold the most product?
-- Aggregate quantity_ordered by city
select 
city,
sum(quantity_ordered) as total_unit_sold,
round(sum(total_cost)) as city_total_sales
from merged_sales_data
group by city
order by total_unit_sold desc;

# Question 3: What time should we display advertisements to maximize likelihood of customer's buying product?
-- Check count in hour level
select
hour(order_date) as order_hour,
count(*) as order_count
from
merged_sales_data
group by order_hour
order by order_count desc ;

-- Another count with interval 3 hours
select
CASE WHEN hour(order_date)>=0 and hour(order_date)<=2 THEN '12 AM - 3 AM' 
		WHEN hour(order_date)>=3 and hour(order_date)<=5 THEN '3 AM - 6 AM' 
        WHEN hour(order_date)>=6 and hour(order_date)<=8 THEN '6 AM - 9 AM' 
        WHEN hour(order_date)>=9 and hour(order_date)<=11 THEN '9 AM - 12 PM' 
        WHEN hour(order_date)>=12 and hour(order_date)<=14 THEN '12 PM - 3 PM' 
        WHEN hour(order_date)>=15 and hour(order_date)<=17 THEN '3 PM - 6 PM'
        WHEN hour(order_date)>=18 and hour(order_date)<=20 THEN '6 PM - 8 PM' 
        WHEN hour(order_date)>=21 and hour(order_date)<=23 THEN '9 PM - 12 AM' 
    END as hour_interval,
count(*) as order_count
FROM
merged_sales_data
group by hour_interval
order by order_count DESC;

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

# Question 5: What product sold the most?
SELECT
product,
SUM(quantity_ordered)
FROM
merged_sales_data
GROUP BY product
ORDER BY SUM(quantity_ordered) DESC;

# Question 6: Is there any correlation between quantity sold of product and product price?
-- Using statistic calculation of correlation
select 	@ax := avg(quantity_ordered), 
		@ay := avg(price_each), 
		@div := (stddev_pop(quantity_ordered) * stddev_pop(price_each))
from merged_sales_data;

select sum( ( quantity_ordered - @ax ) * (price_each - @ay) ) / ((count(quantity_ordered) -1) * @div) 
from merged_sales_data;