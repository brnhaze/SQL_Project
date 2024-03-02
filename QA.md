# Instructions

    Part 5: QA Your Data
    
    In the **QA.md** file, identify and describe your risk areas. Develop and execute a QA process to address them and validate the accuracy of your results. Provide the SQL queries used to execute the QA process.

---------------------------------------------------------------------------------------------------------------------------

# What are your risk areas? Identify and describe them.



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
- some have duplicate values (e.g., "9180751") so cannot remove letter sequences bc productsku can be associated to different orders


