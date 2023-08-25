# Question 6: Is there any correlation between quantity sold of product and product price?
-- Using statistic calculation of correlation
select 	@ax := avg(quantity_ordered), 
		@ay := avg(price_each), 
		@div := (stddev_pop(quantity_ordered) * stddev_pop(price_each))
from merged_sales_data;

select sum( ( quantity_ordered - @ax ) * (price_each - @ay) ) / ((count(quantity_ordered) -1) * @div) 
from merged_sales_data;