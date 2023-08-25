# Question 2: Which city sold the most product?
-- Aggregate quantity_ordered by city
select 
city,
sum(quantity_ordered) as total_unit_sold,
round(sum(total_cost)) as city_total_sales
from merged_sales_data
group by city
order by total_unit_sold desc;