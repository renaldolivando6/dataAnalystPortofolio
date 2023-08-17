-- Enrich dataset with season column
alter table merged_sales_data add season VARCHAR(10);
update merged_sales_data set season= CASE 	WHEN month='January' or month='February' or month='December' THEN 'Winter'
											WHEN month='March' or month='April' or month='May' THEN 'Spring'
											WHEN month='June' or month='July' or month='August' THEN 'Summer'
											ELSE 'Fall'
										END;