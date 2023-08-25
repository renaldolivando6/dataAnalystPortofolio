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