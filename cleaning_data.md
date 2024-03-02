#What issues will you address by cleaning the data?

##Potential data issues encounted

1. Importing files

I used the GUI pgAdmin to import csv files. This was a lengthy process and caused some issues.

1. A. I opened and viewed the csv files column names and data. I then created the tables and their columns. I had to     repeatedly make changes to my column datatypes. Example, one column displaying text had an ':' requring me to use INTERVAL datatype when I wanted INTEGER.

1. B., Using the import function meant when using SELECT statement. I had to write the column name within quoations. I found an option under table properties to change this, but decided to manually change each column by command instead.

Example: See csv file "0 remove quote indent.sql" for more examples.
  ALTER TABLE all_sessions
  RENAME COLUMN "fullVisitorId" TO fullVisitorId

2. Identified schema of ecommerce database and its tables.
2. a. Commmands and details can be found in 3 Data Profiling_Validation_Cleansing.sql

Some Examples:

  SELECT *
  FROM information_schema.tables
  WHERE table_schema = 'public'

  SELECT column_name, data_type, is_nullable
	FROM information_schema.columns
	WHERE table_name = 'all_sessions'

2. b. Identifying problems with the schema and observing duplicate and unique values helped decide on PRIMARY and FOREIGN KEYS. 

- PRIMARY and FOREIGN KEYS:
 - all_sessions
	- PRIMARY KEY:
	- FOREIGN KEY:
 - analytics
  	- PRIMARY KEY:
   	- FOREIGN KEY:
 - intermediate_table
  	- PRIMARY KEY:
   	- FOREIGN KEY:
 - products
  	- PRIMARY KEY:
   	- FOREIGN KEY:
 - sales_by_sku
  	- PRIMARY KEY:
   	- FOREIGN KEY:
 - sales_report
  	- PRIMARY KEY:
   	- FOREIGN KEY:
- I created Intermediate Tables (IT)
	- IT_1
 		- ass_id (FOREIGN KEY) to all_session PRIMARY KEY id column
   		- an_id (FOREIGN KEY) to analytics PRIMARY KEY id column
	- IT_2
 		- an_id (FOREIGN KEY) to analytics PRIMARY KEY id column
   		- prod_id (FOREIGN KEY) to products PRIMARY KEY id column
	- IT_3
 		- prod_id (FOREIGN KEY) to products PRIMARY KEY id column
   		- sbs_id (FOREIGN KEY) to sales_by_sku PRIMARY KEY id column
	- IT_4
 		- sbs_id (FOREIGN KEY) to sales_by_sku PRIMARY KEY id column
   		- sr_id (FOREIGN KEY) to sales_report PRIMARY KEY id column

## Data Profiling, Validating, and Cleaning of Queries and Problems:
  (Below, provide the SQL queries you used to clean your data.)

### Used Columns
1. Identifying schemas of tables and their datatypes and Null values showed errors

	E.g., SELECT column_name, data_type, is_nullable
		FROM information_schema.columns
		WHERE table_name = 'all_sessions'
  
 	 The schema stated either NO or YES to null values but when checking these columns using SELECT statement showed the  opposite at times.

2. all_sessions

	2. a. city
		
  		UPDATE all_sessions
		SET city = NULL
		WHERE city = 'not available in demo dataset'

		UPDATE all_sessions
		SET city = NULL
		WHERE city = '(not set)'
	
 	2. b. country

		UPDATE all_sessions
		SET country = NULL
		WHERE country = '(not set)'

  	2. c. transactionrevenue

		UPDATE all_sessions
		SET transactionrevenue = transactionrevenue/1000000

		UPDATE all_sessions
		SET transactionrevenue = ROUND(transactionrevenue, 2)

  	2. d. fullvisitorid
		
		UPDATE all_sessions
		SET fullvisitorid = LEFT(fullvisitorid::TEXT, LENGTH(fullvisitorid::TEXT) - 12)::NUMERIC
		WHERE fullvisitorid IS NOT NULL

		ALTER TABLE all_sessions
		ALTER COLUMN fullvisitorid SET DATA TYPE INTEGER USING fullvisitorid::INTEGER

   	2. e. v2productcategory

		UPDATE all_sessions
		SET v2productcategory = NULL
		WHERE v2productcategory IS NOT NULL AND v2productcategory = '(not set)'

   	2. f. productprice

     		UPDATE all_sessions
		SET productprice = productprice/1000000

		UPDATE all_sessions
		SET productprice = ROUND(productprice, 2)

		UPDATE all_sessions
		SET productprice = NULL
		WHERE productprice = '0.00'

3. sales_report

	3. a. productsku

		SELECT productsku,
		LEFT(productsku, 3) = 'GGO' AS three,
		LEFT(productsku, 4) = 'GGOE' AS four
		FROM sales_by_sku WHERE productsku IS NOT NULL

  	3. c. name

		UPDATE sales_report
		SET name = LTRIM(name)
		WHERE name IS NOT NULL

### Other Columns
See uploaded csv file: 3 Data Profiling_Validation_Cleansing.sql
