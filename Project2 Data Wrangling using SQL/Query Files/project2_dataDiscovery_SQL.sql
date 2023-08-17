-- Make sure our local_infile is ON
show global variables like 'local_infile';
set global local_infile=true;

-- Load data with local_infile
LOAD DATA LOCAL INFILE "C:/Users/renal/Documents/Renaldo's File/Data Analyst Portofolio -Renaldo Livando/Project2 Data Wrangling using SQL/out/merged_electronic_sales_data.csv"
INTO TABLE merged_sales_data
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(order_id,product ,quantity_ordered,price_each,@order_date ,purchase_address )
set order_date = STR_TO_DATE(@order_date,'%m/%d/%y %H:%i');

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
