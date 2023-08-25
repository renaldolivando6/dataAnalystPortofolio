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