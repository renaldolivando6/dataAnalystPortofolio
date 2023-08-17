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