# Instructions

    Part 5: QA Your Data
    
    In the **QA.md** file, identify and describe your risk areas. Develop and execute a QA process to address them and validate the accuracy of your results. Provide the SQL queries used to execute the QA process.

---------------------------------------------------------------------------------------------------------------------------

# What are your risk areas? Identify and describe them.
- Too many examples to choose from, please see 3 Data Profiling_Validation_Cleansing.sql

1. Completness: failed
   - missing values (NULL), (not set), and '0', '00:00:00' TIME, YYYY-MM-DD Date values.
   	- e.g., timeonsite, all_sessions
   		- SELECT timeonsite FROM all_sessions WHERE timeonsite IS NULL -- 3300 values
   	 	- SELECT timeonsite FROM all_sessions WHERE timeonsite IS NULL -- 3300 values
   	- city, all_sessions contained 'not available in demo dataset' as value
3. Validity (confirmity): failed
   - Missing confirmity and many data values
   - e.g.,
   	- productSKU, some values missing 4 to 6 first sequence of Letters
   - e.g.,
   	- date, all_sessions
   	- SELECT date, COUNT(*) as occurrence_count FROM all_sessions WHERE NOT date::TEXT != '^\d{4}-\d{2}-\d{2}$' GROUP 		BY date ORDER BY date -- 
4. Accuracy: failed
   - values did not represent real-world values
5. Timeliness: failed
   - data values dates were out-of-date
   - analytics table took some to query results
9. Consistency: failed
	- some values non-english
		- e.g., pagetitle, all_sessions
	- date, all_sessions
		- SELECT MIN(date), MAX(date) FROM all_sessions WHERE date IS NOT NULL
		- MIN "2016-08-01" and MAX "2017-08-01" Range is 365 days many years ago
10. Uniqueness: failed
    - Not unique
    - many duplicate records in dataset


# QA Process:
- Describe your QA process and include the SQL queries used to execute it.
 - Please see 3 Data Profiling_validation_Cleansing.sql for details of more queries and notes used for QA Process
 
## Example: productsku
     - Attempting to find sequence of varying characters

     SELECT
      		COUNT(*) AS total_rows,
      		COUNT(*) FILTER (WHERE LEFT(productsku, 4) = 'GGOE') AS starts_with_ggoe_rows,
      		COUNT(*) FILTER (WHERE LEFT(productsku, 4) <> 'GGOE' OR productsku IS NULL) AS non_starts_with_ggoe_rows,
    		COUNT(*) FILTER (WHERE LEFT(productsku, 5) = 'GGOEW' OR productsku IS NULL) AS starts_with_ggoeW_rows,
    		COUNT(*) FILTER (WHERE LEFT(productsku, 5) <> 'GGOEW' OR productsku IS NULL) AS non_starts_with_ggoeW_rows,
    		COUNT(*) FILTER (WHERE LEFT(productsku, 5) = 'GGOEY' OR productsku IS NULL) AS starts_with_ggoeY_rows,
    		COUNT(*) FILTER (WHERE LEFT(productsku, 5) <> 'GGOEY' OR productsku IS NULL) AS non_starts_with_ggoeY_rows
    	FROM all_sessions -- 15134 total values when ggoe, ggoew, ggoey
	
    SELECT productsku, SUBSTRING(productsku FROM 5 FOR 1) AS fifth_character FROM all_sessions WHERE productsku IS NOT NULL
    -- Fifth character is either W, Y, G, N Y, A -- too many results
    
    SELECT productsku, SUBSTRING(productsku FROM 5 FOR 1) AS fifth_character FROM all_sessions
        WHERE productsku IS NOT NULL AND SUBSTRING(productsku FROM 5 FOR 1) NOT IN ('W', 'Y', 'G', 'N', 'Y', 'A')
    
    SELECT productsku, REGEXP_SUBSTR(productsku, '[^a-zA-Z]', 5, 1) AS fifth_non_alpha_character FROM all_sessions
        WHERE productsku IS NOT NULL -- retrieve the 5th character if NOT alpha a-z or A-Z
        GROUP BY productsku
    
    SELECT DISTINCT(productsku), SUBSTRING(productsku FROM 5 FOR 1) AS fifth_character FROM all_sessions
        WHERE productsku IS NOT NULL
        AND (SUBSTRING(productsku FROM 5 FOR 1) NOT IN ('W', 'Y', 'G', 'N', 'Y', 'A')
             OR NOT SUBSTRING(productsku FROM 5 FOR 1) ~ '^\d$')
        GROUP BY productsku

### Unique Values
    SELECT DISTINCT productsku, COUNT(*) FROM all_sessions GROUP BY productsku --


### Aggregate Functions
    SELECT MIN(productsku), MAX(productsku) FROM all_sessions WHERE productsku IS NOT NULL --
	SELECT LENGTH(MAX(productsku::TEXT)), LENGTH(MIN(productsku::TEXT)) FROM all_sessions -- 
     SELECT DISTINCT productsku, v2productname, v2productcategory, COUNT(*), LENGTH(MAX(productsku::TEXT)) AS max_, LENGTH(MIN(productsku::TEXT)) AS min_
    		FROM all_sessions GROUP BY productsku, v2productname, v2productcategory --

### Conclusion:
- Fifth character must be a either GGOE('W', 'Y', 'G', 'N', 'Y', 'A') or a without GGOE
- unsure what to format the 5th character to, remove 5th letter/digit, remove all letters, change entire format and assign new?

## Example: Comparing all products using two different methods
- some have duplicate values (e.g., "9180751") so cannot remove letter sequences bc productsku can be associated to different orders

### Query 1

	SELECT ass.productsku, ass.v2productname, p.name, p.sku, sbs.productsku, sr.name, sr.productsku
	FROM all_sessions AS ass
	JOIN products AS p USING(id)
	JOIN sales_by_sku AS sbs USING(id)
	JOIN sales_report AS sr USING(id)
	
### Query 2	

 	SELECT ass.productsku, ass.v2productname
	FROM all_sessions AS ass
	UNION ALL
	SELECT p.name, p.sku
	FROM products AS p
	UNION ALL
	SELECT sbs.productsku, NULL
	FROM sales_by_sku AS sbs
	UNION ALL
	SELECT sr.name, sr.productsku
	FROM sales_report AS sr;

### Query 2 Option
#### COUNT, Duplicate, and NULL Values and Validation Query
- COUNT and Identify Duplicate Values
	- list of duplicates based on the productsku and productnames from all databases
 	-  Occurences: how many times each duplicate appeared

	WITH cte AS (
	SELECT ass.productsku, ass.v2productname AS productname
	FROM all_sessions AS ass
	UNION ALL
	SELECT p.name, p.sku AS productsku
	FROM products AS p
	UNION ALL
	SELECT sbs.productsku, NULL AS productname
	FROM sales_by_sku AS sbs
	UNION ALL
	SELECT sr.name, sr.productsku AS productsku
	FROM sales_report AS sr
	)
	SELECT productname, productsku, COUNT(*) AS occurences FROM cte
	WHERE productname IS NOT NULL
		AND productsku IS NOT NULL
	GROUP BY productname, productsku
	HAVING COUNT(*) > 1
	ORDER BY occurences DESC, productsku, productname

 - See image QA_1
 - Citation: "occurences" idea taken from (https://chat.openai.com/)
