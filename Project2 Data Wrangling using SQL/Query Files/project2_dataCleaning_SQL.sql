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
                    