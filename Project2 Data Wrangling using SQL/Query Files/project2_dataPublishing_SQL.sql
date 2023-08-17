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