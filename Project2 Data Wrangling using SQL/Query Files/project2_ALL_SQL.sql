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

-- Remove missing values
delete from merged_sales_data 
WHERE order_id IS NULL OR order_id=0;

-- Check duplicate values accross all columns
select count(*) from (
	SELECT 
		*,
		ROW_NUMBER() OVER (
			PARTITION BY order_id, product, quantity_ordered, 
							price_each, order_date, purchase_address
			ORDER BY order_id) AS row_num
	FROM 
		merged_sales_data
	) as b
        where row_num>1;
        
-- Remove duplicate values
DELIMITER $$
CREATE TABLE `merged_sales_data_copy` (
  `order_id` int DEFAULT NULL,
  `product` varchar(50) DEFAULT NULL,
  `quantity_ordered` int DEFAULT NULL,
  `price_each` float DEFAULT NULL,
  `order_date` datetime DEFAULT NULL,
  `purchase_address` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO merged_sales_data_copy
select * from merged_sales_data
group by order_id, product, quantity_ordered, price_each, order_date, purchase_address;

DROP TABLE merged_sales_data;
ALTER TABLE merged_sales_data_copy RENAME TO merged_sales_data;
SELECT COUNT(*) FROM merged_sales_data;
$$ 

-- Trim and remove double space from string column
update merged_sales_data
set product = trim(REPLACE(
						REPLACE(
							REPLACE(product,
							' ','<>'),
						'><',''),
					'<>',' '));
                    
update merged_sales_data
set purchase_address = trim(REPLACE(
						REPLACE(
							REPLACE(purchase_address,
							' ','<>'),
						'><',''),
					'<>',' '));

-- Create new column Month that contain name of month from order_date
alter table merged_sales_data add month varchar(10);
UPDATE merged_sales_data set month=MONTHNAME(order_date);

-- Create new column total_cost that contain calculaton from existing column
alter table merged_sales_data add total_cost float;
UPDATE merged_sales_data set total_cost=quantity_ordered * price_each;

-- Perform generalization on purchase_address column
DELIMITER $$
alter table merged_sales_data add street VARCHAR(30);
update merged_sales_data set street= SUBSTRING_INDEX(purchase_address, ',', 1);
alter table merged_sales_data add city VARCHAR(30);
update merged_sales_data set city= SUBSTRING_INDEX(SUBSTRING_INDEX(purchase_address, ',', 2),',',-1);
alter table merged_sales_data add state VARCHAR(2);
update merged_sales_data set state= LEFT(TRIM(SUBSTRING_INDEX(purchase_address, ',', -1)),2);
alter table merged_sales_data add postal_code VARCHAR(5);
update merged_sales_data set postal_code=RIGHT(TRIM(SUBSTRING_INDEX(purchase_address, ',', -1)),5);
select * from merged_sales_data;
$$

-- Re-arrange table
ALTER TABLE `kaggle`.`merged_sales_data` 
CHANGE COLUMN `order_date` `order_date` DATETIME NULL DEFAULT NULL AFTER `order_id`,
CHANGE COLUMN `month` `month` VARCHAR(10) NULL DEFAULT NULL AFTER `order_date`,
CHANGE COLUMN `total_cost` `total_cost` FLOAT NULL DEFAULT NULL AFTER `price_each`;    

-- Enrich dataset with season column
alter table merged_sales_data add season VARCHAR(10);
update merged_sales_data set season= CASE 	WHEN month='January' or month='February' or month='December' THEN 'Winter'
											WHEN month='March' or month='April' or month='May' THEN 'Spring'
											WHEN month='June' or month='July' or month='August' THEN 'Summer'
											ELSE 'Fall'
										END;

-- List our column name
SELECT group_concat(CONCAT("'",COLUMN_NAME,"'") ORDER BY ORDINAL_POSITION SEPARATOR ',') 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'merged_sales_data'
AND TABLE_SCHEMA = 'kaggle';

-- Union and export our table to csv file
SELECT 'order_id','order_date','month','product','quantity_ordered','price_each','total_cost','purchase_address','street','city','state','postal_code','season'
UNION ALL
SELECT * FROM merged_sales_data
INTO OUTFILE "C:/Users/renal/Documents/Renaldo's File/Data Analyst Portofolio -Renaldo Livando/Project2 Data Wrangling using SQL/out/cleaned_electronic_sales_data.csv"
FIELDS ENCLOSED BY '"'
TERMINATED BY ','
LINES TERMINATED BY '\r\n';