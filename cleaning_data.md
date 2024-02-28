#What issues will you address by cleaning the data?

##Potential data issues encounted

1. Importing files

I used the GUI pgAdmin to import csv files. This was a lengthy process and caused some issues.

First, I opened and viewed the csv files column names and data. I then created the tables and their columns. I had to     repeatedly make changes to my column datatypes. Example, one column displaying text had an ':' requring me to use INTERVAL datatype when I wanted INTEGER.

Second, Using the import function meant when using SELECT statement. I had to write the column name within quoations. I found an option under table properties to change this, but decided to manually change each column by command instead.

Example: See csv file "0 remove quote indent.sql" for more examples.
  ALTER TABLE all_sessions
  RENAME COLUMN "fullVisitorId" TO fullVisitorId

2. Identified schema of ecommerce database and its tables.
- Identifying problems with the schema and observing duplicate and unique values helped decide on PRIMARY and FOREIGN KEYS. 

Commmands and details can be found in 3 Data Profiling_Validation_Cleansing.sql

Some Examples:

  SELECT *
  FROM information_schema.tables
  WHERE table_schema = 'public'

  SELECT column_name, data_type, is_nullable
	FROM information_schema.columns
	WHERE table_name = 'all_sessions'

 all_sessions
 - Created column "id" because fullvisitorid and visitorid contained duplicate values

 analytics
 - Created column "id" because fullvisitorid, visitnumber, userid, and visitid contained null values or duplicate values.

 products
 - sku was chosen as the primary key

 sales_by_sku
 - productssku was chosen as the primary key
 - FOREIGN KEY productsku referencing sales_report productsku

 sales_report
 - productsku was chosen as a primary key
 - FOREIGN KEY productsku referencing sales_report productsku

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
- 
