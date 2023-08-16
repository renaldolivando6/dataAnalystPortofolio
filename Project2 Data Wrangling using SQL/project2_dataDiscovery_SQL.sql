-- Select our dataset head
select * from merged_sales_data
LIMIT 5;

-- Check total rows in our dataset
select count(*) from merged_sales_data;

-- Check empty values in our dataset by INT column
select count(*) from merged_sales_data WHERE order_id IS NULL OR order_id=0;

-- Check empty values in our dataset by string column
select count(*) from merged_sales_data WHERE product IS NULL OR product="";

-- Check order_id is unique key or not
select count(DISTINCT order_id), count(order_id) from merged_sales_data;
