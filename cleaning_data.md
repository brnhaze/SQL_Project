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
   		- id (created)
	- FOREIGN KEY:
		- country to country in country_currency
  		- date to date in analytics  
 - country_currency
 	- PRIMARY KEY:
   	- FOREIGN KEY: 
 - analytics
  	- PRIMARY KEY:
   		- id (created)
   	- FOREIGN KEY:
   		- visitnumber to visitnumber in intermediate_table
 - intermediate_table
  	- PRIMARY KEY:
   	- FOREIGN KEY:
   		- visitnumber to visitnumber in analytics
   	 	  visitnumber to visitnumer in products 
 - products
  	- PRIMARY KEY:
   		- sku
   	- FOREIGN KEY:
   		-  sku to productsku in sales_by_sku
 - sales_by_sku
  	- PRIMARY KEY:
   		- productsku
   	- FOREIGN KEY:
   		- productsku to productsku in sales_report
 - sales_report
  	- PRIMARY KEY:
   		- productsku
   	- FOREIGN KEY:


## Data Profiling, Validating, and Cleaning of Queries and Problems:
  (Below, provide the SQL queries you used to clean your data.)

1. Identifying schemas of tables and their datatypes and Null values showed errors

E.g., SELECT column_name, data_type, is_nullable
	FROM information_schema.columns
	WHERE table_name = 'all_sessions'
  
  The schema stated either NO or YES to null values but when checking these columns using SELECT statement showed the  opposite at times.

2. timeonsite FROM all_sessions
- I decided to keep NULL vales over changing to 00:00:00 format.
- The users can input the data at a later time and I do not want values 00:00:00 being counted as an INPUT.
- There were 3300 count for NULL values

3. pageviews FROM all_sessions
- Contained no NULL values but table schema stated null value syntax stated "YES"

4. sessionqualitydim FROM all_sessions
- NULL values counted for 13906
- unknown understanding what sessionqualitydim was nor could identify when viewing other columns
	- session quality dimension could be an estimate of a session so associated to columns time and timeonsite
 - Chose values to by datatype integer because I did not see any numeric, ratio, etc...
 - large difference in DISTINCT values
	- sessionqualitydim 1 showed high disproportion of 988 to value 2 of 109
 - column name can be shortened, e.g., sess_dim
 
 5. date FROM all_sessions
- Contained no NULL values but table schema stated null value syntax stated "YES"

6. visitid FROM all_sessions
- Contained no NULL values but table schema stated null value syntax stated "YES"
- visitid digit count was 10
	- I could not eliminate any numbers from sequence (begginning, middle, or end) to shorten it.
 - duplicate values contained so cannot use as PRIMARY KEY

7. productrefundamount FROM all_sessions
- All NULL values
- Other columns such as productquantity, productprice, and productrevenue did not give values indicating productrefundamount was important.
- Can delete column however users may add values.

8. productquantity FROM all_sessions
- 15081 NULL values out of total and 53 NOT NULL, assuming NULL means out of stock
	- There were no 0 quantity
   	- If, NULL means out of stock, then should change to 0 ... need clarification before changing
   	- product could be out of stock or discontinued, etc...

9. productprice FROM all_sessions
- Contained no NULL values but table schema stated null value syntax stated "YES"
- datatype NUMERIC values were all divided by 1000000.00 to make sense associated to v2productname
	- ROUNDED function used
 - productprice 0.00 for 14758 count found. Changed to NULL values.
	- prices should be inputted by user
   	- some v2productnames could be duplicates, one may have different prices.

10. productrevenue FROM all_sessions
