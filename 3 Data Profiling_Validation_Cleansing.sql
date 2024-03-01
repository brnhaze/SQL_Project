
----------------------------

-- Identify Schema of ecommerce dB and its tables
SELECT *
FROM information_schema.tables
WHERE table_schema = 'public'
-- 5 tables

----------------------------------------------------------------------------------------------------------

SELECT * FROM all_sessions

-- Identify data type and null values

	SELECT column_name, data_type, is_nullable
	FROM information_schema.columns
	WHERE table_name = 'all_sessions'
	-- all columns have Null values exlcuding created "id" PRIMARY KEY

-- timeonsite column
	-- datatype is INTERVAL
	
	SELECT timeonsite FROM all_sessions WHERE timeonsite IS NULL -- OR (timeonsite != '^\d{2}:\d{2}:\d{2}$')
	-- Could not check the format of the Interval (atempted NOT, !=, LIKE, SIMILAR, etc...)

	-- Set timeonsite NULL values to 00:00:00
	-- UPDATE all_sessions
	-- SET timeonsite = COALESCE(timeonsite, '00:00:00')

	SELECT timeonsite FROM all_sessions WHERE timeonsite IS NULL -- no more null values showing
	
	-- Changed timeonsite from 00:00:00 BACK TO NULL
		-- Decided to change back to NULL, so values can be inserted/corrected by users
	UPDATE all_sessions
	SET timeonsite = NULL
	WHERE timeonsite = '00:00:00'::INTERVAL
	
	
	SELECT timeonsite FROM all_sessions
	SELECT timeonsite FROM all_sessions WHERE timeonsite IS NULL -- 3300
	SELECT timeonsite FROM all_sessions WHERE timeonsite IS NOT NULL -- 11834
	
	-- Unique Values
	SELECT DISTINCT timeonsite, COUNT(*) FROM all_sessions GROUP BY timeonsite
	SELECT DISTINCT timeonsite, COUNT(*) FROM all_sessions WHERE timeonsite IS NOT NULL GROUP BY timeonsite -- 
	SELECT MIN(timeonsite), MAX(timeonsite) FROM all_sessions WHERE timeonsite IS NOT NULL -- MIN "00:00:01" and MAX "01:17:41"

-- pageviews column
		-- pageviews is INTEGER
		
	SELECT pageviews FROM all_sessions WHERE pageviews IS NULL -- shows NO NULL; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT pageviews FROM all_sessions WHERE pageviews IS NOT NULL -- 15134
	SELECT pageviews FROM all_sessions WHERE pageviews <> integer -- <> NOT EQUAL TO -- did not work
	SELECT pageviews FROM all_sessions WHERE pageviews != '\d+' -- did not work
	
	-- Unique Values
	SELECT DISTINCT pageviews, COUNT(*) FROM all_sessions GROUP BY pageviews
	SELECT DISTINCT pageviews, COUNT(*) FROM all_sessions WHERE pageviews IS NOT NULL GROUP BY pageviews -- 
	SELECT DISTINCT pageviews, COUNT(*) FROM all_sessions WHERE pageviews = '0' GROUP BY pageviews -- NONE
	SELECT DISTINCT pageviews, COUNT(*) FROM all_sessions WHERE pageviews < '1' GROUP BY pageviews -- none
	SELECT MIN(pageviews), MAX(pageviews) FROM all_sessions WHERE pageviews IS NOT NULL -- Min 1	MAX 30

-- sessionqualitydim: some quality dimension or metric associated with sessions in a web analytics context.
	-- data type is Integer
	SELECT fullvisitorid, time, sessionqualitydim, timeonsite, visitid  FROM all_sessions
	SELECT sessionqualitydim FROM all_sessions WHERE sessionqualitydim IS NULL -- many NULL values
	SELECT sessionqualitydim FROM all_sessions WHERE sessionqualitydim IS NOT NULL
	SELECT sessionqualitydim FROM all_sessions WHERE sessionqualitydim <> 'integer' -- not work
	SELECT sessionqualitydim FROM all_sessions WHERE sessionqualitydim != '\D' -- did not work
	SELECT sessionqualitydim FROM all_sessions WHERE sessionqualitydim != '1' -- many other values than '1'

	-- change NULL values to '0' DID NOT CHANGE bc did not know what column means, null means does not exist so kept it
	
	-- Unique Values
	SELECT DISTINCT sessionqualitydim, COUNT(*) FROM all_sessions GROUP BY sessionqualitydim -- 
	SELECT DISTINCT sessionqualitydim, COUNT(*) FROM all_sessions WHERE sessionqualitydim = '0' GROUP BY sessionqualitydim -- 
	SELECT DISTINCT sessionqualitydim, COUNT(*) FROM all_sessions WHERE sessionqualitydim < '1' GROUP BY sessionqualitydim -- none
	SELECT MIN(sessionqualitydim), MAX(sessionqualitydim) FROM all_sessions WHERE sessionqualitydim IS NOT NULL -- 

-- date
	-- datatype is date
	SELECT date FROM all_sessions WHERE date IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT date FROM all_sessions WHERE date != '^\d{4}-\d{2}-\d{2}$'	-- did not work
	
	-- Unique Values
	SELECT DISTINCT date, COUNT(*) FROM all_sessions GROUP BY date -- N/A
	SELECT date, COUNT(*) as occurrence_count FROM all_sessions WHERE NOT date != '^\d{4}-\d{2}-\d{2}$' GROUP BY date ORDER BY date -- did not work
		-- attempted IS NOT, NOT, !=, <>, LIKE, SIMILAR, etc...
	SELECT MIN(date), MAX(date) FROM all_sessions WHERE date IS NOT NULL -- MIN "2016-08-01"	MAX "2017-08-01" date range 1 year

-- visitid
	-- datatype: integer
	SELECT visitid FROM all_sessions WHERE visitid IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT visitid, floor(log(visitid) + 1) AS digit_count FROM all_sessions -- floor rounds down, log calculates algarithm = 10 digits, could not use LENGTH() bc interval
	SELECT visitid, floor(log(visitid) + 1) AS digit_count FROM all_sessions WHERE floor(log(visitid) + 1) > 10
	SELECT visitid, floor(log(visitid) + 1) AS digit_count FROM all_sessions WHERE floor(log(visitid) + 1) < 10

	-- Unique Values
	SELECT MAX(visitid), MIN(visitID) FROM all_sessions -- max: 1501657186 min: 1470037277
	SELECT DISTINCT visitid FROM all_sessions -- 14566 count
	-- SELECT DISTINCT visitid FROM all_sessions GROUP BY visitid HAVING COUNT(visitid) > 1
	SELECT visitid, COUNT(*) AS duplicate FROM all_sessions WHERE visitid IS NOT NULL GROUP BY visitid HAVING COUNT(*) > 1 -- duplicate values
	SELECT COUNT(DISTINCT(visitid)) FROM all_sessions -- 14566 count
	SELECT COUNT(visitid) FROM all_sessions -- 15134 count -- duplicate counts
	SELECT DISTINCT visitid, COUNT(*) FROM all_sessions GROUP BY visitid -- 
	SELECT DISTINCT visitid, COUNT(*) FROM all_sessions WHERE visitid < '1' GROUP BY visitid -- 
	SELECT LENGTH(visitid::TEXT) FROM all_sessions
	SELECT LENGTH(visitid::TEXT) FROM all_sessions WHERE LENGTH(visitid::TEXT) > '10' -- 10 seems to be the max LENGTH
	SELECT LENGTH(MAX(visitid::TEXT)), LENGTH(MIN(visitid::TEXT)) FROM all_sessions -- verified MIN and MAX Length
	 

-- productrefundamount
	-- datatype is numeric
	SELECT productrefundamount FROM all_sessions WHERE productrefundamount IS NOT NULL -- all NULL values
	
	-- imnportant (see other related columns)
	SELECT * FROM all_sessions
	SELECT productrefundamount, productquantity, productprice, productrevenue FROM all_sessions
	
	-- Unique Values
		-- all null values

-- productquantity
	-- data type if integer
	SELECT productquantity FROM all_sessions WHERE productquantity IS NULL -- 15134
	SELECT productquantity FROM all_sessions WHERE productquantity IS NOT NULL -- 53
	
	-- Unique Values
	SELECT DISTINCT productquantity, COUNT(*) FROM all_sessions GROUP BY productquantity --
	SELECT COUNT(DISTINCT(productquantity)) FROM all_sessions --		
	SELECT DISTINCT productquantity, COUNT(*) FROM all_sessions WHERE productquantity < '0' GROUP BY productquantity -- none less than 0
	SELECT MIN(productquantity), MAX(productquantity) FROM all_sessions WHERE productquantity IS NOT NULL -- Min 1	MAX 65
	
	-- NULL could be changed to 0 quantity, but product might be discontinued, etc...
	
-- productprice
	-- datatype is numeric
	SELECT productprice FROM all_sessions WHERE productprice IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT productprice FROM all_sessions WHERE productprice IS NOT NULL -- 15134 count
	SELECT MIN(productprice), MAX(productprice) FROM all_sessions WHERE productprice IS NOT NULL -- MIN 0 MAX 298000000
	SELECT productprice FROM all_sessions WHERE productprice = 0 -- 376 count
	SELECT productprice FROM all_sessions WHERE pg_typeof(productprice) <> 'numeric' -- not work
	
	SELECT v2productname, productprice FROM all_sessions WHERE productprice = '0.79' -- checking if price matches item
	
	-- divide productprice by 1,000,000
	UPDATE all_sessions
	SET productprice = productprice/1000000

	SELECT productprice FROM all_sessions WHERE productprice IS NOT NULL -- verify

	-- permanantly update/change to display only rounded values
	UPDATE all_sessions
	SET productprice = ROUND(productprice, 2)

	SELECT productprice FROM all_sessions WHERE productprice IS NOT NULL -- verify
	
	-- Unique Values
	SELECT DISTINCT productprice, COUNT(*) FROM all_sessions GROUP BY productprice -- 0.00 values seen, should be NULL
		
		SELECT v2productname, productprice
		FROM all_Sessions WHERE productprice = '0.00'
		GROUP BY v2productname, productprice
		HAVING COUNT(*) > 1 -- prices should be updated
		
		SELECT v2productname FROM all_Sessions WHERE v2productname > '1' -- can find duplicate productnames and set prices
		
		SELECT v2productname, productprice FROM all_Sessions WHERE v2productname = 'Google Women''s Lightweight Microfleece Jacket' -- random test
		
	SELECT COUNT(DISTINCT(productprice)) FROM all_sessions --		
	SELECT DISTINCT productprice, COUNT(*) FROM all_sessions WHERE productprice = '0.00' GROUP BY productprice -- 376 0.00 values, why is it $0.00
		-- out of inventory, non-existent, etc...
	SELECT MIN(productprice), MAX(productprice) FROM all_sessions WHERE productprice IS NOT NULL -- Min 0	MAX 298
	
	-- change price from 0.00 to NULL values
	UPDATE all_sessions
	SET productprice = NULL
	WHERE productprice = '0.00'
	
	SELECT DISTINCT productprice, COUNT(*) FROM all_sessions GROUP BY productprice -- verify

-- productrevenue
	-- datatype is numeric
	SELECT productrevenue FROM all_sessions WHERE productrevenue IS NULL
	SELECT productrevenue FROM all_sessions WHERE productrevenue IS NOT NULL
	
	SELECT * FROM all_sessions
	SELECT v2productname, productrefundamount, productquantity, productprice, productrevenue FROM all_sessions WHERE productrevenue IS NOT NULL
	
	SELECT 50*3.50 = 175.00
	
	SELECT 
    	v2productname, productrefundamount, productquantity, productprice, productrevenue, productrevenue / 1000000::NUMERIC AS new_price
	FROM  all_sessions
	WHERE  productrevenue IS NOT NULL
	
	-- change productrevenue and display rounded values
	
	UPDATE all_sessions
	SET productrevenue = productrevenue/1000000
	
	UPDATE all_sessions
	SET productrevenue = ROUND(productrevenue, 2)
	
	SELECT v2productname, productrefundamount, productquantity, productprice, productrevenue FROM all_sessions WHERE productrevenue IS NOT NULL -- verify
	
	-- difference in amount, went up (taxes)?
	
	SELECT  v2productname, productrefundamount, productquantity, productprice, (productquantity*productprice) AS qty_x_pr, productrevenue, productrevenue - (productquantity*productprice) AS diff
	FROM  all_sessions WHERE  productrevenue IS NOT NULL
	
	-- Unique Values
	SELECT * FROM all_sessions
	SELECT  productSKU, v2productname, v2productcategory, productrefundamount, productquantity, productprice, productrevenue FROM all_sessions
	SELECT DISTINCT productrevenue, COUNT(*) FROM all_sessions GROUP BY productrevenue --	
	SELECT MIN(productrevenue), MAX(productrevenue) FROM all_sessions WHERE productrevenue IS NOT NULL -- MIN 58.66 MAX 176.40

-- itemquantity
	-- datatype integer
	SELECT itemquantity FROM all_sessions WHERE itemquantity IS NOT NULL --  all NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT COUNT(*) As null_count FROM all_sessions WHERE itemquantity IS NULL -- 15134 null count
	SELECT itemquantity FROM all_sessions -- 15134 count
	
	-- Unique Values
	SELECT DISTINCT itemquantity, COUNT(*) FROM all_sessions GROUP BY itemquantity -- all NULL values		 

-- itemrevenue
	-- NUMERIC
	SELECT itemrevenue FROM all_sessions WHERE itemrevenue IS NULL -- 15134 null values
	SELECT itemrevenue FROM all_sessions WHERE itemrevenue IS NOT NULL -- all null values
	
	-- Unique Values
	SELECT DISTINCT itemrevenue, COUNT(*) FROM all_sessions GROUP BY itemrevenue -- all null values

-- transactionrevenue
	-- numeric
	SELECT transactionrevenue FROM all_sessions WHERE transactionrevenue IS NULL -- 15130 count
	SELECT transactionrevenue FROM all_sessions WHERE transactionrevenue IS NOT NULL
	SELECT * FROM all_sessions
	SELECT itemquantity, transactionrevenue, transactions, totaltransactionrevenue, transactionid FROM all_sessions WHERE transactionrevenue IS NOT NULL
	-- Unknown if transactionrevenue and totaltransactionrevenue needs to by divided by 1000000, rounded, and displaying decimal .xx
		-- no transactionquantity column exists to decifer but itemquantity exists (unsure if related)
		
	-- should this be divided by 1000000?
	SELECT * FROM all_sessions
	SELECT transactionrevenue, transactions, transactionid FROM all_sessions WHERE transactionrevenue IS NOT NULL
	-- SELECT 200000000/1000000 = 200
	UPDATE all_sessions
	SET transactionrevenue = transactionrevenue/1000000
	
	SELECT transactionrevenue, transactions, transactionid FROM all_sessions WHERE transactionrevenue IS NOT NULL -- verified
	
	-- round results to .xx decimal places
	UPDATE all_sessions
	SET transactionrevenue = ROUND(transactionrevenue, 2)
	
	-- Unique Values
	SELECT DISTINCT transactionrevenue, COUNT(*) FROM all_sessions GROUP BY transactionrevenue --	
	SELECT MIN(transactionrevenue), MAX(transactionrevenue) FROM all_sessions WHERE transactionrevenue IS NOT NULL -- MIN 169970000 MAX 1015480000
	SELECT LENGTH(transactionrevenue::TEXT) FROM all_sessions WHERE transactionrevenue IS NOT NULL
	SELECT LENGTH(MAX(transactionrevenue::TEXT)), LENGTH(MIN(transactionrevenue::TEXT)) FROM all_sessions -- 


-- ecommerceaction_type
	-- datatype: integer
	SELECT ecommerceaction_type FROM all_sessions WHERE ecommerceaction_type IS NULL -- 
	SELECT ecommerceaction_type FROM all_sessions WHERE ecommerceaction_type IS NOT NULL OR ecommerceaction_type != 0 -- NOT NULL worked but not the != 0
	SELECT COUNT(ecommerceaction_type) FROM all_sessions WHERE ecommerceaction_type != 0 -- 349 values
	
	-- Unique Values
	SELECT DISTINCT ecommerceaction_type, COUNT(*) FROM all_sessions GROUP BY ecommerceaction_type --
	SELECT COUNT(DISTINCT(ecommerceaction_type)) FROM all_sessions --		
	SELECT DISTINCT ecommerceaction_type, COUNT(*) FROM all_sessions WHERE ecommerceaction_type = '0' GROUP BY ecommerceaction_type -- 
	SELECT MIN(ecommerceaction_type), MAX(ecommerceaction_type) FROM all_sessions WHERE ecommerceaction_type IS NOT NULL -- MIN 0 MAX 6

-- ecommerceaction_step
	-- datatype is Integer
	SELECT ecommerceaction_step FROM all_sessions WHERE ecommerceaction_step IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT ecommerceaction_step FROM all_sessions WHERE ecommerceaction_step IS NOT NULL OR ecommerceaction_step != 1 -- NOT NULL worked but not the != 0
	SELECT ecommerceaction_step FROM all_sessions WHERE ecommerceaction_step != 1 -- 18 values
	
	-- Unique Values
	SELECT DISTINCT ecommerceaction_step, COUNT(*) FROM all_sessions GROUP BY ecommerceaction_step --
	SELECT COUNT(DISTINCT(ecommerceaction_step)) FROM all_sessions --		
	SELECT MIN(ecommerceaction_step), MAX(ecommerceaction_step) FROM all_sessions WHERE ecommerceaction_step IS NOT NULL --


-- fullvisitorid
	-- datatype is numeric but should be BIGINT (cannot change)
	SELECT fullvisitorid FROM all_sessions WHERE fullvisitorid IS NULL -- -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT fullvisitorid FROM all_sessions WHERE fullvisitorid IS NOT NULL -- 15134 values
	SELECT MIN(fullvisitorid), MAX(fullvisitorid) FROM all_sessions WHERE fullvisitorid IS NOT NULL -- MIN 122544416887869 MAX 9999679083512798585
	
	-- update/alter datatype from numeric to integer: DID NOT WORK
	ALTER TABLE all_sessions
	ALTER COLUMN fullvisitorid SET DATA TYPE BIGINT -- out of range; issue importing csv file so had to use NUMERIC
	
	SELECT LENGTH(fullvisitorid) FROM all_sessions WHERE fullvisitorid IS NOT NULL -- cannot cound LENGTH of NUMERIC ???
	SELECT MIN(LENGTH(fullvisitorid::TEXT)) AS min, MAX(LENGTH(fullvisitorid::TEXT)) AS max FROM all_sessions WHERE fullvisitorid IS NOT NULL -- MIN 15 MAX 19
	SELECT COUNT(fullvisitorid) FROM all_sessions WHERE fullvisitorid IS NOT NULL -- 15134
	SELECT COUNT(DISTINCT fullvisitorid) FROM all_sessions WHERE fullvisitorid IS NOT NULL -- 14223
	
	-- trailing 0's
	SELECT fullvisitorid,
		LENGTH(fullvisitorid::TEXT) - LENGTH(TRIM(TRAILING '0' FROM fullvisitorid::TEXT)) AS trailing_zeros_count
		FROM all_sessions WHERE fullvisitorid IS NOT NULL
	SELECT fullvisitorid,
    	MIN(LENGTH(fullvisitorid::TEXT) - LENGTH(TRIM(TRAILING '0' FROM fullvisitorid::TEXT))) AS min_trailing_zeros_count,
    	MAX(LENGTH(fullvisitorid::TEXT) - LENGTH(TRIM(TRAILING '0' FROM fullvisitorid::TEXT))) AS max_trailing_zeros_count
		FROM all_sessions WHERE fullvisitorid IS NOT NULL GROUP BY fullvisitorid
	SELECT fullvisitorid,
    	MIN(LENGTH(fullvisitorid::TEXT) - LENGTH(TRIM(TRAILING '0' FROM fullvisitorid::TEXT))) AS min_trailing_zeros_count,
    	MAX(LENGTH(fullvisitorid::TEXT) - LENGTH(TRIM(TRAILING '0' FROM fullvisitorid::TEXT))) AS max_trailing_zeros_count
		FROM all_sessions WHERE fullvisitorid IS NOT NULL GROUP BY fullvisitorid ORDER BY min_trailing_zeros_count LIMIT 1 -- minimum trailing zero's is 12
	
	-- remove last 12 trailing 0's from the end
	SELECT fullvisitorid,
    	LEFT(fullvisitorid::TEXT, LENGTH(fullvisitorid::TEXT) - 12) AS modified_fullvisitorid
		FROM all_sessions WHERE fullvisitorid IS NOT NULL
		
	UPDATE all_sessions
	SET fullvisitorid = LEFT(fullvisitorid::TEXT, LENGTH(fullvisitorid::TEXT) - 12)::NUMERIC
	WHERE fullvisitorid IS NOT NULL
	
	-- verify
	SELECT fullvisitorid FROM all_sessions WHERE fullvisitorid IS NOT NULL
	
	-- update/alter datatype from numeric to integer: did not work
	ALTER TABLE all_sessions
	ALTER COLUMN fullvisitorid SET DATA TYPE INTEGER -- 
	
	ALTER TABLE all_sessions
	ALTER COLUMN fullvisitorid SET DATA TYPE INTEGER USING fullvisitorid::INTEGER;

	
	-- verify 
	SELECT fullvisitorid FROM all_sessions WHERE fullvisitorid IS NOT NULL
	
	-- Unique Values
	SELECT DISTINCT fullvisitorid, COUNT(*) FROM all_sessions GROUP BY fullvisitorid --
	SELECT COUNT(DISTINCT(fullvisitorid)) FROM all_sessions --		
	SELECT MIN(fullvisitorid), MAX(fullvisitorid) FROM all_sessions WHERE fullvisitorid IS NOT NULL -- MIN 122544416887869 MAX 9999679083512798585
	SELECT LENGTH(fullvisitorid::TEXT) FROM all_sessions
	SELECT LENGTH(fullvisitorid::TEXT) FROM all_sessions WHERE LENGTH(fullvisitorid::TEXT) < '19' -- 
	SELECT LENGTH(MAX(fullvisitorid::TEXT)) AS max, LENGTH(MIN(fullvisitorid::TEXT)) AS min FROM all_sessions -- MAX 19 MIN 18
	
	-- LENGTH digits are 17, 18, or 19: cannot eliminate any

-- time
	-- datatype INTERVAL
	SELECT time FROM all_sessions WHERE time IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT time FROM all_sessions WHERE time IS NOT NULL -- 15134 values
	SELECT time FROM all_sessions WHERE time = '00:00:00' -- 5098 values
	SELECT timeonsite, time FROM all_sessions
	
	-- change from interval to TIME
	SELECT time, (time::TIME) FROM all_sessions
	
	ALTER TABLE all_sessions
	ALTER COLUMN time
	TYPE TIME
	
	SELECT time  FROM all_sessions -- verified
	
	-- Unique Values
	SELECT DISTINCT time, COUNT(*) FROM all_sessions GROUP BY time --
	SELECT COUNT(DISTINCT(time)) FROM all_sessions --		
	SELECT DISTINCT time, COUNT(*) FROM all_sessions WHERE time = '00:00:00' GROUP BY time -- 
	
	-- could CHANGE 00:00:00 to NULL values, dependant on dB and usage, BUT all values are 00:00:00
		-- not sure where time or time on site is coming from, data needs to be inputted
	SELECT * FROM all_sessions
	SELECT time, timeonsite  FROM all_sessions WHERE time IS NOT NULL
	
	
	SELECT MIN(time), MAX(time) FROM all_sessions WHERE time IS NOT NULL --
	SELECT LENGTH(time::TEXT) FROM all_sessions
	SELECT LENGTH(time::TEXT) FROM all_sessions WHERE LENGTH(time::TEXT) > '10' -- 
	SELECT LENGTH(MAX(time::TEXT)), LENGTH(MIN(time::TEXT)) FROM all_sessions -- 
	
-- totaltransactionrevenue
	--datatype numeric
	SELECT totaltransactionrevenue FROM all_sessions WHERE totaltransactionrevenue IS NULL -- 15053 values
	SELECT totaltransactionrevenue FROM all_sessions WHERE totaltransactionrevenue IS NOT NULL -- 81 values
	
	SELECT itemquantity, transactionrevenue, transactions, totaltransactionrevenue, transactionid FROM all_sessions WHERE totaltransactionrevenue IS NOT NULL
	
	-- should this be divided by 1000000 ?
	SELECT itemquantity, transactionrevenue, transactions, totaltransactionrevenue, transactionid FROM all_sessions WHERE totaltransactionrevenue IS NOT NULL
	
	UPDATE all_sessions
	SET totaltransactionrevenue = totaltransactionrevenue/1000000
	
	-- ROUND 
	UPDATE all_sessions
	SET totaltransactionrevenue = ROUND(totaltransactionrevenue, 2)
	
	SELECT itemquantity, transactionrevenue, transactions, totaltransactionrevenue, transactionid FROM all_sessions WHERE totaltransactionrevenue IS NOT NULL -- verify
	
	-- Unique Values
	SELECT DISTINCT totaltransactionrevenue, COUNT(*) FROM all_sessions GROUP BY totaltransactionrevenue --
	SELECT COUNT(DISTINCT(totaltransactionrevenue)) FROM all_sessions --		
	SELECT MIN(totaltransactionrevenue), MAX(totaltransactionrevenue) FROM all_sessions WHERE totaltransactionrevenue IS NOT NULL -- MIN 7500000 MAX 1015480000
	SELECT LENGTH(MIN(totaltransactionrevenue::TEXT)), LENGTH(MAX(totaltransactionrevenue::TEXT)) FROM all_sessions -- 7 to 10 length characters

-- channelgrouping
	-- datatype TEXT
	SELECT channelgrouping FROM all_sessions WHERE channelgrouping IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT channelgrouping FROM all_sessions WHERE channelgrouping IS NOT NULL
	
	SELECT channelgrouping, ARRAY_LENGTH(STRING_TO_ARRAY(channelgrouping, ' '), 1) AS word_count FROM all_sessions WHERE channelgrouping IS NOT NULL -- word count
	-- ARRAY_LENGTH: Returns the length of the requested array dimension
	-- STRING_TO_ARRAY: Converts each array element to its text representation, and concatenates those separated by the delimiter string
	
	-- Can remove (other) to NULL but dbut decided to leave it as it could be like a miscelaneous item
	
	-- Unique Values
	SELECT DISTINCT channelgrouping, COUNT(*) FROM all_sessions GROUP BY channelgrouping --
	SELECT COUNT(DISTINCT(channelgrouping)) FROM all_sessions --		
	
-- pagetitle
	-- character varying
	SELECT pagetitle FROM all_sessions WHERE pagetitle IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT pagetitle FROM all_sessions WHERE pagetitle IS NOT NULL
	SELECT pagetitle FROM all_sessions WHERE pagetitle IS NOT NULL  AND pagetitle ~ '[0-9]' -- NULL and contains numbers (Citation ChapGPT for ~)
	
	-- Unique Values
	SELECT DISTINCT pagetitle, COUNT(*) FROM all_sessions GROUP BY pagetitle --
	SELECT COUNT(DISTINCT(pagetitle)) FROM all_sessions --		
	SELECT LENGTH(MAX(pagetitle::TEXT)), LENGTH(MIN(pagetitle::TEXT)) FROM all_sessions -- 
	SELECT MIN(pagetitle), MAX(pagetitle) FROM all_sessions WHERE pagetitle IS NOT NULL --
	
	-- pagetitle NOT in english ,  no access to psql (password issue) to install google trasnlation
	SELECT MIN(pagetitle), MAX(pagetitle) FROM all_sessions WHERE pagetitle IS NOT NULL --
	SELECT datname, encoding, datcollate FROM pg_database WHERE datname = 'ecommerce' -- check dB character set & collation
	SELECT table_name, column_name, character_set_name, collation_name FROM information_schema.columns WHERE table_name = 'all_sessions' AND column_name = 'pagetitle'
		-- check table character set & collation

	-- remove empty characters/spaces on the RIGHT
	-- UPDATE all_sessions
	-- SET pagetitle = RTRIM(pagetitle)
	
	SELECT DISTINCT pagetitle, COUNT(*) FROM all_sessions GROUP BY pagetitle -- verify: did not work (likely not an issue)
	
--  country
	-- text
	SELECT country FROM all_sessions WHERE  country IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT country FROM all_sessions WHERE  country IS NOT NULL -- 15134 values
	
	-- Unique Values
	SELECT DISTINCT country, COUNT(*) FROM all_sessions GROUP BY country -- (not set) values, change to NULL
	SELECT COUNT(DISTINCT(country)) FROM all_sessions --		
	
	-- change (not set) to NULL values
	UPDATE all_sessions
	SET country = NULL
	WHERE country = '(not set)'
	
	SELECT DISTINCT country, COUNT(*) FROM all_sessions GROUP BY country -- verify

--  city
	-- text
	SELECT city FROM all_sessions WHERE  city IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT city FROM all_sessions WHERE  city IS NOT NULL AND city = 'not available in demo dataset' -- 8302
	
	-- update/alter value from 'not available in demo dataset' to NULL
		-- bc NULL will show value is missing/unknown/NA
		-- NULL values may not be calculated in AGGregate functions
			-- 'not available in demo dataset' could have been miscalculated as an actual VALUE
		-- NULL value seems as a consistent value
	UPDATE all_sessions
	SET city = NULL
	WHERE city = 'not available in demo dataset'
	
	SELECT city FROM all_sessions WHERE  city IS NOT NULL AND city = 'not available in demo dataset' -- verify
	SELECT city FROM all_sessions WHERE  city IS NULL -- verified 8302 values
	
	-- Unique Values
	SELECT DISTINCT city, COUNT(*) FROM all_sessions GROUP BY city -- 
	SELECT COUNT(DISTINCT(city)) FROM all_sessions -- 265
	
	-- change (not set) to NULL values
	UPDATE all_sessions
	SET city = NULL
	WHERE city = '(not set)'
	
	SELECT DISTINCT city, COUNT(*) FROM all_sessions GROUP BY city -- verify

-- productsku
	-- datatype character varying
	SELECT productsku FROM all_sessions WHERE productsku IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT productsku FROM all_sessions WHERE productsku IS NOT NULL
	
	SELECT productsku,
		LEFT(productsku, 3) = 'GGO' AS three,
		LEFT(productsku, 4) = 'GGOE' AS four
	FROM all_sessions WHERE productsku IS NOT NULL
	
	SELECT
  		COUNT(*) AS total_rows,
  		COUNT(*) FILTER (WHERE LEFT(productsku, 4) = 'GGOE') AS starts_with_ggoe_rows,
  		COUNT(*) FILTER (WHERE LEFT(productsku, 4) <> 'GGOE' OR productsku IS NULL) AS non_starts_with_ggoe_rows,
		COUNT(*) FILTER (WHERE LEFT(productsku, 5) = 'GGOEW' OR productsku IS NULL) AS starts_with_ggoeW_rows,
		COUNT(*) FILTER (WHERE LEFT(productsku, 5) <> 'GGOEW' OR productsku IS NULL) AS non_starts_with_ggoeW_rows,
		COUNT(*) FILTER (WHERE LEFT(productsku, 5) = 'GGOEY' OR productsku IS NULL) AS starts_with_ggoeY_rows,
		COUNT(*) FILTER (WHERE LEFT(productsku, 5) <> 'GGOEY' OR productsku IS NULL) AS non_starts_with_ggoeY_rows
	FROM all_sessions -- 15134 total values when ggoe, ggoew, ggoey
	
	SELECT productsku FROM all_sessions-- 15134 values
	
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
	
	-- Fifth character must be a either GGOE('W', 'Y', 'G', 'N', 'Y', 'A') or a without GGOE
	-- unsure what to format the 5th character to, remove 5th letter/digit, remove all letters, change entire format and assign new?

-- Unique Values
	SELECT DISTINCT productsku, COUNT(*) FROM all_sessions GROUP BY productsku --
	SELECT MIN(productsku), MAX(productsku) FROM all_sessions WHERE productsku IS NOT NULL --
	SELECT LENGTH(MAX(productsku::TEXT)), LENGTH(MIN(productsku::TEXT)) FROM all_sessions -- 
	
	SELECT DISTINCT productsku, v2productname, v2productcategory, COUNT(*), LENGTH(MAX(productsku::TEXT)) AS max_, LENGTH(MIN(productsku::TEXT)) AS min_
		FROM all_sessions GROUP BY productsku, v2productname, v2productcategory --
	-- some have duplicate values (e.g., "9180751") so cannot remove letter sequences bc productsku can be associated to different orders

-- transactions
	-- datatype character varying: changed to INTEGER
	SELECT transactions FROM all_sessions WHERE transactions IS NULL -- 15053
	SELECT transactions FROM all_sessions WHERE transactions IS NOT NULL -- 81
	SELECT transactions FROM all_sessions WHERE transactions IS NOT NULL AND transactions != '1' OR transactions > '1' -- no results
	SELECT transactions, itemquantity, transactionrevenue, totaltransactionrevenue, transactionid FROM all_sessions WHERE transactions IS NOT NULL
	
	-- KEEP NULL VALUES ?
	
	-- change datatype to INTEGER -- not working
		-- ERROR:  column "transactions" cannot be cast automatically to type integer
		-- HINT:  You might need to specify "USING transactions::integer". 
	ALTER TABLE all_sessions
	ALTER COLUMN transactions TYPE INTEGER
	
	SELECT * FROM all_sessions WHERE transactions ~ '\D' -- check for incompatible values (contains NULL and no alpha or non-numeric)
	
	UPDATE all_sessions SET transactions = NULL WHERE transactions ~ '\D' -- pdate incompatible values
	
	ALTER TABLE all_sessions -- did not work
	ALTER COLUMN transactions TYPE INTEGER
	
	ALTER TABLE all_sessions
	ALTER COLUMN transactions TYPE INTEGER
	USING transactions::integer
	
	SELECT transactions FROM all_sessions WHERE transactions IS NULL -- 15053
	SELECT transactions FROM all_sessions WHERE transactions IS NOT NULL -- 81
	
	-- all values are '1' should I change nulls to 1 and delete column?
	
	-- Unique Values
	SELECT DISTINCT transactions, COUNT(*) FROM all_sessions GROUP BY transactions --
	SELECT MIN(transactions), MAX(transactions) FROM all_sessions WHERE transactions IS NOT NULL --

-- v2productname
	-- datatype character varying
	SELECT v2productname FROM all_sessions WHERE v2productname IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT v2productname FROM all_sessions WHERE v2productname IS NOT NULL -- 15134
	
	-- Unique Values
	SELECT DISTINCT v2productname, COUNT(*) FROM all_sessions GROUP BY v2productname --
	SELECT DISTINCT v2productname, COUNT(*) FROM all_sessions GROUP BY v2productname HAVING COUNT(*) = '1' -- 30 products have 1 count
	SELECT DISTINCT v2productname, COUNT(*) FROM all_sessions GROUP BY v2productname HAVING COUNT(*) > '1' -- 30 products have 1 count

-- v2productcategory
	-- character varying
	SELECT v2productcategory FROM all_sessions WHERE v2productname IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT v2productcategory FROM all_sessions WHERE v2productname IS NOT NULL -- 15134
	
	-- remove (not set) & change to NULL value
	UPDATE all_sessions
	SET v2productcategory = NULL
	WHERE v2productcategory IS NOT NULL AND v2productcategory = '(not set)'
	
	SELECT v2productcategory FROM all_sessions WHERE v2productcategory = '(not set)' -- verify
	
	-- Unique Values
	SELECT DISTINCT v2productcategory, COUNT(*) FROM all_sessions GROUP BY v2productcategory -- ${escCatTitle} result of 19 ???
		SELECT v2productname, v2productcategory FROM all_sessions WHERE v2productcategory = '${escCatTitle}'
		-- CHANGE TO NULL bc incorrect
		UPDATE all_sessions
		SET v2productcategory = NULL
		WHERE v2productcategory = '${escCatTitle}'
	SELECT DISTINCT v2productcategory, COUNT(*) FROM all_sessions GROUP BY v2productcategory --Nest-USA		unsure of result, let it stay/kept
	
	-- some were not categorized with text / text /		left it alone because unsure of the categories of this dB
	
-- v2productname & v2productcategory
	SELECT * FROM all_sessions
	SELECT productSKU, v2productname, v2productcategory, productvariant, pagetitle FROM all_sessions
		GROUP BY v2productname, v2productcategory, productSKU, productvariant, pagetitle ORDER BY v2productname
	-- found many v2productcategory MISTAKES
	
	-- Did not bother changing v2productcategory per products because no idea what the category should be

-- productvariant
	-- datatype character varying
	SELECT productvariant FROM all_sessions WHERE productvariant IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT productvariant FROM all_sessions WHERE productvariant IS NOT NULL -- 15134
	SELECT productvariant FROM all_sessions WHERE productvariant IS NOT NULL AND productvariant != '(not set)' -- 40 Values
	
	-- Change Value from (not set) to NULL
	UPDATE all_sessions
	SET productvariant = NULL
	WHERE productvariant = '(not set)'
	
	SELECT productvariant FROM all_sessions WHERE productvariant IS NOT NULL AND productvariant = '(not set)' -- verify
	
	-- remove left empty space characters
	UPDATE all_sessions
	SET productvariant = LTRIM(productvariant)
	
	-- Unique Values
	SELECT DISTINCT productvariant, COUNT(*) FROM all_sessions GROUP BY productvariant --

-- currencycode
	-- TEXT
	SELECT currencycode FROM all_sessions -- 15134
	SELECT currencycode FROM all_sessions WHERE currencycode IS NULL -- 272
	SELECT currencycode FROM all_sessions WHERE currencycode IS NOT NULL -- 14862
	SELECT currencycode FROM all_sessions WHERE currencycode IS NOT NULL AND currencycode != 'USD' -- none
	-- SELECT 14862 + 272 = 15134
	
	-- Unique Values
	SELECT DISTINCT currencycode, COUNT(*) FROM all_sessions GROUP BY currencycode --
	SELECT COUNT(DISTINCT(currencycode)) FROM all_sessions -- Only USD
	SELECT currencycode FROM all_sessions WHERE currencycode != 'USD' -- confirmed only USD available
	
	-- set currencycode using country and city columns
	SELECT DISTINCT(country), city, currencycode FROM all_sessions WHERE currencycode IS NOT NULL ORDER BY country
	-- 4. SEE script country_currency_code_script
	
	SELECT country, city, currencycode FROM all_sessions -- verify
	
-- searchkeyword -- DELETE column, all NULL
	-- data type character varying
	SELECT searchkeyword FROM all_sessions -- 15134
	SELECT searchkeyword FROM all_sessions WHERE searchkeyword IS NULL -- 15134
	SELECT searchkeyword FROM all_sessions WHERE searchkeyword IS NOT NULL -- none
	
	-- Unique Values
	SELECT DISTINCT searchkeyword, COUNT(*) FROM all_sessions GROUP BY searchkeyword -- 15134 null values, all

-- type
	-- datatype TEXT
	SELECT type FROM all_sessions WHERE type IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT type FROM all_sessions WHERE type IS NOT NULL -- 15134
	SELECT type FROM all_sessions WHERE type IS NOT NULL AND type != 'PAGE' AND type != 'EVENT' -- NONE, only either 'PAGE' OR 'EVENT'
	
	-- Unique Values
	SELECT DISTINCT type, COUNT(*) FROM all_sessions GROUP BY type -- EVENT 192, PAGE 14942
	
-- pagepathlevel1
	-- datatype character varying
	SELECT pagepathlevel1 FROM all_sessions WHERE pagepathlevel1 IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT pagepathlevel1 FROM all_sessions WHERE pagepathlevel1 IS NOT NULL -- 15134
	SELECT pagepathlevel1 FROM all_sessions WHERE pagepathlevel1 IS NOT NULL AND NOT pagepathlevel1 LIKE '/%' -- all start with "/"
	
	-- Unique Values
	SELECT DISTINCT pagepathlevel1, COUNT(*) FROM all_sessions GROUP BY pagepathlevel1 --

-- ecommerceaction_option
	-- datatype character varying
	SELECT ecommerceaction_option FROM all_sessions WHERE ecommerceaction_option IS NULL -- 15103
	SELECT ecommerceaction_option FROM all_sessions WHERE ecommerceaction_option IS NOT NULL -- 31
	-- SELECT 15103+31 = 15134
	
	-- Change datatype to TEXT
	ALTER TABLE all_sessions
	ALTER COLUMN ecommerceaction_option TYPE TEXT
	
	SELECT ecommerceaction_option FROM all_sessions -- verify
	
	-- Unique Values
	SELECT DISTINCT ecommerceaction_option, COUNT(*) FROM all_sessions GROUP BY ecommerceaction_option --

-- transactionid
	-- datatype charccter varying
	SELECT transactionid FROM all_sessions WHERE transactionid IS NULL -- 15125
	SELECT transactionid FROM all_sessions WHERE transactionid IS NOT NULL -- 9
	
	-- COULD remove first letters "ORD" but decided not too, might help seeing it for visual purposes
	
	-- Unique Values
	SELECT DISTINCT transactionid, COUNT(*) FROM all_sessions GROUP BY transactionid -- can remove the "ORD"; but, Looks visually better with it
	SELECT MIN(transactionid), MAX(transactionid) FROM all_sessions WHERE transactionid IS NOT NULL -- all 15 characters in length
	SELECT LENGTH(transactionid::TEXT) FROM all_sessions WHERE LENGTH(transactionid::TEXT) > '10' -- 
	SELECT LENGTH(MAX(transactionid::TEXT)), LENGTH(MIN(transactionid::TEXT)) FROM all_sessions -- 
	
----------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM analytics

-- Identify data type and null values

	SELECT column_name, data_type, is_nullable
	FROM information_schema.columns
	WHERE table_name = 'analytics'
	-- all columns have Null values exlcuding created "id" PRIMARY KEY

-- date
	-- datetype date YYYY-MM-DD
	SELECT date FROM analytics WHERE date IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT date FROM analytics WHERE date IS NOT NULL --  4301122
	SELECT date FROM analytics WHERE date IS NOT NULL AND date != '^\d{4}-\d{2}-\d{2}$' -- no results
	SELECT date FROM analytics WHERE date IS NOT NULL AND NOT date ~ '^\d{4}-\d{2}-\d{2}$' -- citation: ChatGPT -- no results
	SELECT date FROM analytics WHERE date != '^\d{4}-\d{2}-\d{2}$' -- no results
	
	-- Unique Values
	SELECT DISTINCT date FROM analytics
	SELECT COUNT(DISTINCT(date)) FROM analytics --		
	SELECT MIN(date), MAX(date) FROM analytics WHERE date IS NOT NULL -- MIN "2017-05-01" MAX "2017-08-01"
	SELECT LENGTH(MAX(date::TEXT)), LENGTH(MIN(date::TEXT)) FROM analytics -- 

-- userid -- Had duplicates so I created "id" column as PK, can delete this
	-- datatype INTEGER
	SELECT userid FROM analytics WHERE userid IS NULL -- 4301122
	SELECT userid FROM analytics WHERE userid IS NOT NULL -- none, no userid assigned -- can delete
	
	-- Unique Values
	SELECT DISTINCT userid, COUNT(*) FROM analytics GROUP BY userid --

-- timeonsite
	-- datatype: INTERVAL
	SELECT timeonsite FROM analytics WHERE timeonsite IS NULL -- 477465
	SELECT timeonsite FROM analytics WHERE timeonsite IS NOT NULL -- 3823657
	
	-- change NULL TO 00:00:00: Decided to leave as NULL, so values can be inserted/corrected by users
		-- also all_sessions column timesonsite reverted back to NULL values from 00:00:00
	
	-- Unique Values
	SELECT DISTINCT timeonsite, COUNT(*) FROM analytics GROUP BY timeonsite --
	SELECT MIN(timeonsite), MAX(timeonsite) FROM analytics WHERE timeonsite IS NOT NULL --
	SELECT LENGTH(MAX(timeonsite::TEXT)), LENGTH(MIN(timeonsite::TEXT)) FROM analytics -- 

-- bounces
	-- datatype INTEGER
	SELECT bounces FROM analytics WHERE bounces IS NULL -- 3826283
	SELECT bounces FROM analytics WHERE bounces IS NOT NULL -- 474839
	SELECT bounces FROM analytics WHERE bounces IS NOT NULL AND bounces != '1' -- NONE
	SELECT bounces FROM analytics WHERE bounces IS NOT NULL AND bounces > '1' -- NONE
	SELECT bounces FROM analytics WHERE bounces  IS NOT NULL AND bounces != '^\d+$' -- did not work but assuming only character is INTEGER = '1'
	
	-- Unique Values
	SELECT DISTINCT bounces, COUNT(*) FROM analytics GROUP BY bounces -- Should they all be '1' value
	SELECT MIN(bounces), MAX(bounces) FROM analytics WHERE bounces IS NOT NULL --
	
-- revenue, unit_price, units_sold
	SELECT revenue, unit_price, units_sold FROM analytics
	
	SELECT units_sold, unit_price, revenue FROM analytics WHERE units_sold IS NOT NULL
	-- SELECT 240000000/2 = 120000000
	
	-- DIVIDE unit_price and revenue by 1000000
	UPDATE analytics
	SET unit_price = unit_price/1000000, revenue = revenue/1000000
	
	SELECT units_sold, unit_price, revenue FROM analytics WHERE units_sold IS NOT NULL -- verify
	
	-- ROUND Numeric
	UPDATE analytics
	SET unit_price = ROUND(unit_price, 2),
	revenue = ROUND(revenue, 2)
	
	SELECT units_sold, unit_price, revenue FROM analytics WHERE units_sold IS NOT NULL -- verify
	
	-- TAXES ?

-- revenue
	-- datatype is NUMERIC
	SELECT revenue FROM analytics WHERE revenue IS NULL -- 4285767
	SELECT revenue FROM analytics WHERE revenue IS NOT NULL -- 15355
	
	-- Unique Values
	SELECT DISTINCT revenue, COUNT(*) FROM analytics GROUP BY revenue --
	SELECT COUNT(DISTINCT(revenue)) FROM analytics --		
	SELECT MIN(revenue), MAX(revenue) FROM analytics WHERE revenue IS NOT NULL --
	SELECT LENGTH(MAX(revenue::TEXT)), LENGTH(MIN(revenue::TEXT)) FROM analytics -- 
	
-- unit_price
	-- NUMERIC
	SELECT unit_price FROM analytics WHERE unit_price IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT unit_price FROM analytics WHERE unit_price IS NOT NULL -- 4301122
	
	-- Change 0.00 values to NULL (as mentioned ealrier)
	UPDATE analytics
	SET unit_price = NULL
	WHERE unit_price = 0.00
	
	SELECT unit_price FROM analytics WHERE unit_price IS NULL 
	SELECT unit_price FROM analytics WHERE unit_price IS NOT NULL
	SELECT unit_price FROM analytics WHERE unit_price IS NOT NULL AND unit_price = 0.00 -- verified
	
	-- Unique Values
	SELECT DISTINCT unit_price, COUNT(*) FROM analytics GROUP BY unit_price --
	SELECT MIN(unit_price), MAX(unit_price) FROM analytics WHERE unit_price IS NOT NULL --
	SELECT LENGTH(unit_price::TEXT) FROM analytics
	SELECT LENGTH(MAX(unit_price::TEXT)), LENGTH(MIN(unit_price::TEXT)) FROM analytics -- 

-- visitnumber
	-- INTEGER
	SELECT visitnumber FROM analytics WHERE visitnumber IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT visitnumber FROM analytics WHERE visitnumber IS NOT NULL -- 4301122
	
	-- Unique Values
	SELECT DISTINCT visitnumber, COUNT(*) FROM analytics GROUP BY visitnumber --
	SELECT COUNT(DISTINCT(visitnumber)) FROM analytics --		
	SELECT MIN(visitnumber), MAX(visitnumber) FROM analytics WHERE visitnumber IS NOT NULL --
	SELECT LENGTH(visitnumber::TEXT) FROM analytics
	
-- units_sold
	-- INTEGER
	SELECT units_sold FROM analytics WHERE units_sold IS NULL -- 4205975
	SELECT units_sold FROM analytics WHERE units_sold IS NOT NULL -- 95147
	SELECT COUNT(units_sold), units_sold FROM analytics WHERE units_sold IS NOT NULL AND units_sold != 1 GROUP BY units_sold
	
	-- Unique Values
	SELECT DISTINCT units_sold, COUNT(*) FROM analytics GROUP BY units_sold -- 1 count of "-89" units sold ? -- make into positive
	SELECT COUNT(DISTINCT(units_sold)) FROM analytics --		
	SELECT MIN(units_sold), MAX(units_sold) FROM analytics WHERE units_sold IS NOT NULL --
	
	-- Change "-89" to Positve
	SELECT units_sold FROM analytics WHERE units_sold = '-89'
	
	UPDATE analytics
	SET units_sold = '89'
	WHERE units_sold = '-89'
	
	SELECT units_sold FROM analytics WHERE units_sold = '-89' -- verify
	SELECT DISTINCT units_sold, COUNT(*) FROM analytics GROUP BY units_sold -- verify (1 x count of 89 shown)
	
-- pageviews
	-- INTEGER
	SELECT pageviews FROM analytics WHERE pageviews IS NULL -- 72
	SELECT pageviews FROM analytics WHERE pageviews IS NOT NULL -- 4301050
	
	-- Unique Values
	SELECT DISTINCT pageviews, COUNT(*) FROM analytics GROUP BY pageviews --
	SELECT COUNT(DISTINCT(pageviews)) FROM analytics --		
	SELECT DISTINCT pageviews, COUNT(*) FROM analytics WHERE pageviews < '0' GROUP BY pageviews -- none
	SELECT MIN(pageviews), MAX(pageviews) FROM analytics WHERE pageviews IS NOT NULL --

-- channelgrouping
	-- Text
	SELECT channelgrouping FROM analytics WHERE channelgrouping IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT channelgrouping, COUNT(channelgrouping) FROM analytics WHERE channelgrouping IS NOT NULL GROUP BY channelgrouping -- 4301122 
	
	-- VALUE: (Other) count of 63: could remove brackets
	
	-- Unique Values
	SELECT DISTINCT channelgrouping, COUNT(*) FROM analytics GROUP BY channelgrouping -- value: (other)
	SELECT * FROM analytics
	SELECT channelgrouping FROM analytics WHERE channelgrouping = '(Other)'
	
	-- Change from (Other) to Other to keep consistent
	UPDATE analytics
	SET channelgrouping = 'Other'
	WHERE channelgrouping = '(Other)'
	
	SELECT DISTINCT channelgrouping, COUNT(*) FROM analytics GROUP BY channelgrouping -- verify
	SELECT channelgrouping FROM analytics WHERE channelgrouping = '(Other)' -- verify
	
	SELECT COUNT(DISTINCT(channelgrouping)) FROM analytics --		
	SELECT LENGTH(MAX(channelgrouping::TEXT)), LENGTH(MIN(channelgrouping::TEXT)) FROM analytics -- 

-- socialengagementtype
	-- TEXT
	SELECT socialengagementtype FROM analytics WHERE socialengagementtype IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT socialengagementtype FROM analytics WHERE socialengagementtype IS NOT NULL -- 4301122
	SELECT socialengagementtype, COUNT(socialengagementtype) FROM analytics WHERE socialengagementtype IS NOT NULL GROUP BY socialengagementtype -- all have same values
		-- no need for column named socialengagementtype
	
	-- DELETE column: waiting
	
	-- Unique Values
	SELECT DISTINCT socialengagementtype, COUNT(*) FROM analytics GROUP BY socialengagementtype --
	SELECT COUNT(DISTINCT(socialengagementtype)) FROM analytics --		

-- visitstarttime
	-- Character Varying
	SELECT visitstarttime FROM analytics WHERE visitstarttime IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT visitstarttime FROM analytics WHERE visitstarttime IS NOT NULL --  4301122
	SELECT MIN(visitstarttime), MAX(visitstarttime) FROM analytics WHERE visitstarttime IS NOT NULL -- MIN "1493622000" MAX "1501657190"
	
	-- change datatype to TIME/INTRVAL
	ALTER TABLE analytics
	ALTER COLUMN visitstarttime TYPE INTERVAL
	USING visitstarttime::INTERVAL
	
	-- Unique Values
	SELECT DISTINCT visitstarttime, COUNT(*) FROM analytics GROUP BY visitstarttime --
	SELECT COUNT(DISTINCT(visitstarttime)) FROM analytics --		
	SELECT MIN(visitstarttime), MAX(visitstarttime) FROM analytics WHERE visitstarttime IS NOT NULL --
	
	-- All values are identical: "00:00:01" -- Delete column?
	SELECT * FROM analytics
	SELECT visitstarttime, date, timeonsite FROM analytics

-- visitid
	-- character varying to TEXT, to BIGINT
	SELECT visitid FROM analytics WHERE visitid IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT visitid FROM analytics WHERE visitid IS NOT NULL -- 4301122
	
	-- remove : from value
	UPDATE analytics
	SET visitid = REPLACE(visitid::TEXT, ':', '')
	
	-- change datatype to INTEGER -- value out of reach for INTEGER , changed to BIGINT
	ALTER TABLE analytics
	ALTER COLUMN visitid TYPE BIGINT
	USING visitid::BIGINT
	
	SELECT visitid FROM analytics WHERE visitid IS NOT NULL -- verified
	
-- fullvisitorid
	-- character varying
	SELECT fullvisitorid FROM analytics WHERE fullvisitorid IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT fullvisitorid FROM analytics WHERE fullvisitorid IS NOT NULL -- 4301122
	
	-- change datatype to INTEGER
		-- INTEGER and BIGINT out of range error
	ALTER TABLE analytics
	ALTER COLUMN fullvisitorid TYPE BIGINT
	USING fullvisitorid::BIGINT
	
	-- did not wantt change to TEXT nor NUMERIC rounded so kept as character varying
	
	-- Unique Values
	SELECT DISTINCT fullvisitorid, COUNT(*) FROM analytics GROUP BY fullvisitorid --
	SELECT MIN(fullvisitorid), MAX(fullvisitorid) FROM analytics WHERE fullvisitorid IS NOT NULL --
	SELECT LENGTH(MAX(fullvisitorid::TEXT)), LENGTH(MIN(fullvisitorid::TEXT)) FROM analytics -- 

----------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM products

-- Identify data type and null values

	SELECT column_name, data_type, is_nullable
	FROM information_schema.columns
	WHERE table_name = 'products'
	-- all columns have Null values exlcuding created "id" PRIMARY KEY
	
	SELECT * FROM products

-- stocklevel
	-- datatype INTEGER
	SELECT stocklevel FROM products WHERE stocklevel IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT stocklevel FROM products WHERE stocklevel IS NOT NULL -- 1092
	SELECT stocklevel FROM products WHERE stocklevel IS NOT NULL AND stocklevel != '^\d+$' -- did not work
	SELECT MIN(stocklevel), MAX(stocklevel) FROM products WHERE stocklevel IS NOT NULL
	
	-- Unique Values
	SELECT DISTINCT stocklevel, COUNT(*) FROM products GROUP BY stocklevel --
	SELECT COUNT(DISTINCT(stocklevel)) FROM products --		
	SELECT DISTINCT stocklevel, COUNT(*) FROM products WHERE stocklevel = '0' GROUP BY stocklevel -- 
	SELECT MIN(stocklevel), MAX(stocklevel) FROM products WHERE stocklevel IS NOT NULL --
	
-- sentimentmagnitude
	-- NUMERIC
	SELECT sentimentmagnitude FROM products WHERE sentimentmagnitude IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT sentimentmagnitude FROM products WHERE sentimentmagnitude IS NOT NULL -- 1091
	
	-- Unique Values
	SELECT DISTINCT sentimentmagnitude, COUNT(*) FROM products GROUP BY sentimentmagnitude -- only one null value
	SELECT COUNT(DISTINCT(sentimentmagnitude)) FROM products --		
	SELECT MIN(sentimentmagnitude), MAX(sentimentmagnitude) FROM products WHERE sentimentmagnitude IS NOT NULL --
	SELECT LENGTH(MAX(sentimentmagnitude::TEXT)), LENGTH(MIN(sentimentmagnitude::TEXT)) FROM products -- 

-- restockingleadtime
	-- INTEGER
	SELECT restockingleadtime FROM products WHERE restockingleadtime IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT restockingleadtime FROM products WHERE restockingleadtime IS NOT NULL -- 1092
	SELECT MIN(restockingleadtime), MAX(restockingleadtime) FROM products WHERE restockingleadtime IS NOT NULL
	
	-- Unique Values
	SELECT DISTINCT restockingleadtime, COUNT(*) FROM products GROUP BY restockingleadtime --
	SELECT COUNT(DISTINCT(restockingleadtime)) FROM products --		
	SELECT MIN(restockingleadtime), MAX(restockingleadtime) FROM products WHERE restockingleadtime IS NOT NULL --

-- orderedquantity
	--INETGER
	SELECT orderedquantity FROM products WHERE orderedquantity IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT orderedquantity FROM products WHERE orderedquantity IS NOT NULL -- 1092
	SELECT MIN(orderedquantity), MAX(orderedquantity) FROM products WHERE orderedquantity IS NOT NULL
	
	-- Unique Values
	SELECT DISTINCT orderedquantity, COUNT(*) FROM products GROUP BY orderedquantity ORDER BY orderedquantity -- 191 count of 0 orderedquantity, seems normal
		
	SELECT DISTINCT orderedquantity, COUNT(*) FROM products WHERE orderedquantity = '0' GROUP BY orderedquantity -- 
	SELECT MIN(orderedquantity), MAX(orderedquantity) FROM products WHERE orderedquantity IS NOT NULL --
	SELECT LENGTH(MAX(orderedquantity::TEXT)), LENGTH(MIN(orderedquantity::TEXT)) FROM products -- 
	
-- sentimentscore
	-- NUMERIC
	SELECT sentimentscore FROM products WHERE sentimentscore IS NULL -- 1
	SELECT sentimentscore FROM products WHERE sentimentscore IS NOT NULL -- 1091
	SELECT MIN(sentimentscore), MAX(sentimentscore) FROM products WHERE sentimentscore IS NOT NULL -- MIN -0.6 MAX 1.0 (negative scores allowed?) decided YES
	
	-- Unique Values
	SELECT DISTINCT sentimentscore, COUNT(*) FROM products GROUP BY sentimentscore --
	SELECT COUNT(DISTINCT(sentimentscore)) FROM products --		
	SELECT DISTINCT sentimentscore, COUNT(*) FROM products WHERE sentimentscore = '0' GROUP BY sentimentscore -- there are scoers of 0

-- name
	-- character varying
	SELECT name FROM products WHERE name IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT name FROM products WHERE name IS NOT NULL -- 1092
	
	-- Unique Values
	SELECT DISTINCT name, COUNT(*) FROM products GROUP BY name --
	SELECT COUNT(DISTINCT(name)) FROM products --
	
	-- remove white spaces from left
	UPDATE products
	SET name = LTRIM(name)
	WHERE name IS NOT NULL

----------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM sales_by_sku

-- Identify data type and null values

	SELECT column_name, data_type, is_nullable
	FROM information_schema.columns
	WHERE table_name = 'sales_by_sku'
	-- all columns have Null values exlcuding created "id" PRIMARY KEY
	
-- productsku
	-- Character varying
	SELECT productsku FROM sales_by_sku
	SELECT productsku FROM sales_by_sku WHERE productsku IS NULL -- None
	SELECT productsku FROM sales_by_sku WHERE productsku IS NOT NULL -- 462
	
	SELECT productsku,
		LEFT(productsku, 3) = 'GGO' AS three,
		LEFT(productsku, 4) = 'GGOE' AS four
	FROM sales_by_sku WHERE productsku IS NOT NULL
	
	SELECT
  		COUNT(*) AS total_rows,
  		COUNT(*) FILTER (WHERE LEFT(productsku, 4) = 'GGOE') AS starts_with_ggoe_rows,
  		COUNT(*) FILTER (WHERE LEFT(productsku, 4) <> 'GGOE' OR productsku IS NULL) AS non_starts_with_ggoe_rows,
		COUNT(*) FILTER (WHERE LEFT(productsku, 5) = 'GGOEW' OR productsku IS NULL) AS starts_with_ggoeW_rows,
		COUNT(*) FILTER (WHERE LEFT(productsku, 5) <> 'GGOEW' OR productsku IS NULL) AS non_starts_with_ggoeW_rows,
		COUNT(*) FILTER (WHERE LEFT(productsku, 5) = 'GGOEY' OR productsku IS NULL) AS starts_with_ggoeY_rows,
		COUNT(*) FILTER (WHERE LEFT(productsku, 5) <> 'GGOEY' OR productsku IS NULL) AS non_starts_with_ggoeY_rows
	FROM sales_by_sku -- 462 total values when ggoe, ggoew, ggoey	-- SELECT 384+78	SELECT 11+451	SELECT 15+447
	
	SELECT productsku FROM sales_by_sku -- 462 values
	
	SELECT productsku, SUBSTRING(productsku FROM 5 FOR 1) AS fifth_character FROM sales_by_sku WHERE productsku IS NOT NULL
	-- Fifth character is either W, Y, G, N Y, A -- too many results
	
	SELECT productsku, SUBSTRING(productsku FROM 5 FOR 1) AS fifth_character FROM sales_by_sku
		WHERE productsku IS NOT NULL AND SUBSTRING(productsku FROM 5 FOR 1) NOT IN ('W', 'Y', 'G', 'N', 'Y', 'A') -- 78 w/out
	
	SELECT productsku, REGEXP_SUBSTR(productsku, '[^a-zA-Z]', 5, 1) AS fifth_non_alpha_character FROM sales_by_sku
		WHERE productsku IS NOT NULL -- retrieve the 5th character if NOT alpha a-z or A-Z
		GROUP BY productsku
	
	SELECT DISTINCT(productsku), SUBSTRING(productsku FROM 5 FOR 1) AS fifth_character FROM sales_by_sku
		WHERE productsku IS NOT NULL
		AND (SUBSTRING(productsku FROM 5 FOR 1) NOT IN ('W', 'Y', 'G', 'N', 'Y', 'A')
			 OR NOT SUBSTRING(productsku FROM 5 FOR 1) ~ '^\d$')
		GROUP BY productsku
	
	-- Fifth character must be a either GGOE('W', 'Y', 'G', 'N', 'Y', 'A') or a without GGOE
	-- unsure what to format the 5th character to, remove 5th letter/digit, remove all letters, change entire format and assign new?
	
	-- Unique Values
	SELECT DISTINCT productsku, COUNT(*) FROM sales_by_sku GROUP BY productsku --
	SELECT COUNT(DISTINCT(productsku)) FROM sales_by_sku --		
	SELECT MIN(productsku), MAX(productsku) FROM sales_by_sku WHERE productsku IS NOT NULL --
	SELECT LENGTH(MAX(productsku::TEXT)), LENGTH(MIN(productsku::TEXT)) FROM sales_by_sku -- 

-- total_ordered
	-- INTEGER
	SELECT total_ordered FROM sales_by_sku WHERE total_ordered IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT total_ordered FROM sales_by_sku WHERE total_ordered IS NOT NULL -- 462
	SELECT MIN(total_ordered), MAX(total_ordered) FROM sales_by_sku WHERE total_ordered IS NOT NULL -- 
	
	-- Unique Values
	SELECT DISTINCT total_ordered, COUNT(*) FROM sales_by_sku GROUP BY total_ordered --
	SELECT COUNT(DISTINCT(total_ordered)) FROM sales_by_sku --		
	SELECT DISTINCT total_ordered, COUNT(*) FROM sales_by_sku WHERE total_ordered = '0' GROUP BY total_ordered -- count 156 of 0 total_ordered, should be NULL?
	SELECT MIN(total_ordered), MAX(total_ordered) FROM sales_by_sku WHERE total_ordered IS NOT NULL --
	
----------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM sales_report

-- Identify data type and null values

	SELECT column_name, data_type, is_nullable
	FROM information_schema.columns
	WHERE table_name = 'sales_report'
	-- all columns have Null values exlcuding created "id" PRIMARY KEY

-- productsku
	-- Character Varying
	SELECT productsku FROM sales_report WHERE productsku IS NULL -- no NULL values
	SELECT productsku FROM sales_report WHERE productsku IS NOT NULL -- 454
	
	-- See other productSKU issues with naming convention
	
	-- Unique Values
	SELECT DISTINCT productsku, COUNT(*) FROM sales_report GROUP BY productsku --
	SELECT COUNT(DISTINCT(productsku)) FROM sales_report --		
	SELECT MIN(productsku), MAX(productsku) FROM sales_report WHERE productsku IS NOT NULL --
	SELECT LENGTH(MAX(productsku::TEXT)), LENGTH(MIN(productsku::TEXT)) FROM sales_report -- 

-- restockingleadtime
	--INTEGER
	SELECT restockingleadtime FROM sales_report WHERE restockingleadtime IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT restockingleadtime FROM sales_report WHERE restockingleadtime IS NOT NULL -- 454
	SELECT MIN(restockingleadtime), MAX(restockingleadtime) FROM sales_report WHERE restockingleadtime IS NOT NULL -- 2 - 42
	
	-- Unique Values
	SELECT DISTINCT restockingleadtime, COUNT(*) FROM sales_report GROUP BY restockingleadtime --
	SELECT COUNT(DISTINCT(restockingleadtime)) FROM sales_report --		
	SELECT MIN(restockingleadtime), MAX(restockingleadtime) FROM sales_report WHERE restockingleadtime IS NOT NULL --
	SELECT restockingleadtime FROM sales_report WHERE restockingleadtime IS NOT NULL AND restockingleadtime = '0'

-- total_ordered
	--INTEGER
	SELECT total_ordered FROM sales_report WHERE total_ordered IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT total_ordered FROM sales_report WHERE total_ordered IS NOT NULL -- 454
	SELECT MIN(total_ordered), MAX(total_ordered) FROM sales_report WHERE total_ordered IS NOT NULL -- 0 - 456
	
	-- Unique Values
	SELECT DISTINCT total_ordered, COUNT(*) FROM sales_report GROUP BY total_ordered ORDER BY COUNT(*)
	SELECT COUNT(DISTINCT(total_ordered)) FROM sales_report --		
	SELECT DISTINCT total_ordered, COUNT(*) FROM sales_report WHERE total_ordered = '0' GROUP BY total_ordered -- 
	SELECT MIN(total_ordered), MAX(total_ordered) FROM sales_report WHERE total_ordered IS NOT NULL --

-- sentimentmagnitude
	-- NUMERIC
	SELECT sentimentmagnitude FROM sales_report WHERE sentimentmagnitude IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT sentimentmagnitude FROM sales_report WHERE sentimentmagnitude IS NOT NULL -- 454
	SELECT MIN(sentimentmagnitude), MAX(sentimentmagnitude) FROM sales_report WHERE sentimentmagnitude IS NOT NULL -- .1 2.0
	
	-- Unique Values
	SELECT DISTINCT total_ordered, COUNT(*) FROM sales_report GROUP BY total_ordered --
	SELECT COUNT(DISTINCT(total_ordered)) FROM sales_report --		
	SELECT DISTINCT total_ordered, COUNT(*) FROM sales_report WHERE total_ordered < '0' GROUP BY total_ordered -- 
	SELECT DISTINCT total_ordered, COUNT(*) FROM sales_report WHERE total_ordered = '0' GROUP BY total_ordered -- 
	SELECT MIN(total_ordered), MAX(total_ordered) FROM sales_report WHERE total_ordered IS NOT NULL --
	
-- ratio
	-- Numeric
	SELECT ratio FROM sales_report WHERE ratio IS NULL -- 78
	SELECT ratio FROM sales_report WHERE ratio IS NOT NULL -- 376
	SELECT MIN(ratio), MAX(ratio) FROM sales_report WHERE ratio IS NOT NULL -- 0.0	3.5
	
	-- Change to only return .xx decimal places as NUMERIC vs FLOAT
	UPDATE sales_report
	SET ratio = ROUND(ratio::numeric, 2)
	
	SELECT ratio FROM sales_report WHERE ratio IS NOT NULL -- verify
	
	-- Unique Values
	SELECT DISTINCT ratio, COUNT(*) FROM sales_report GROUP BY ratio --
	SELECT COUNT(DISTINCT(ratio)) FROM sales_report --		
	SELECT DISTINCT ratio, COUNT(*) FROM sales_report WHERE ratio = '0.00' GROUP BY ratio -- 
	SELECT MIN(ratio), MAX(ratio) FROM sales_report WHERE ratio IS NOT NULL --
	SELECT LENGTH(MAX(ratio::TEXT)), LENGTH(MIN(ratio::TEXT)) FROM sales_report -- 

-- stocklevel
	-- NUMERIC
	SELECT stocklevel FROM sales_report WHERE stocklevel IS NULL -- no NULL values indicated; however Identify data type and null values syntax showed NULLS as "yes"
	SELECT stocklevel FROM sales_report WHERE stocklevel IS NOT NULL -- 454
	SELECT MIN(stocklevel), MAX(stocklevel) FROM sales_report WHERE stocklevel IS NOT NULL -- 
	
	-- Unique Values
	SELECT DISTINCT stocklevel, COUNT(*) FROM sales_report GROUP BY stocklevel --
	SELECT COUNT(DISTINCT(stocklevel)) FROM sales_report --		
	SELECT DISTINCT stocklevel, COUNT(*) FROM sales_report WHERE stocklevel = '0' GROUP BY stocklevel -- 
	SELECT MIN(stocklevel), MAX(stocklevel) FROM sales_report WHERE stocklevel IS NOT NULL --
	SELECT LENGTH(stocklevel::TEXT) FROM sales_report WHERE LENGTH(stocklevel::TEXT) < '0' -- 
	
-- sentimentscore
	-- NUMERIC
	SELECT sentimentscore FROM sales_report WHERE sentimentscore IS NULL -- no NULL values
	SELECT sentimentscore FROM sales_report WHERE sentimentscore IS NOT NULL -- 454
	SELECT MIN(sentimentscore), MAX(sentimentscore) FROM sales_report WHERE sentimentscore IS NOT NULL -- -0.6 to 0.9, (negative allowed?) decided YES
	
	-- Unique Values
	SELECT DISTINCT sentimentscore, COUNT(*) FROM sales_report GROUP BY sentimentscore --
	SELECT COUNT(DISTINCT(sentimentscore)) FROM sales_report --		
	SELECT DISTINCT sentimentscore, COUNT(*) FROM sales_report WHERE sentimentscore = '0' GROUP BY sentimentscore --  
	SELECT DISTINCT sentimentscore, COUNT(*) FROM sales_report WHERE sentimentscore < '0' GROUP BY sentimentscore
	
-- name
	-- character varying
	SELECT name FROM sales_report WHERE name IS NULL -- no NULL values
	SELECT name FROM sales_report WHERE name IS NOT NULL -- 454
	
	-- remove whites spaces LEFT of column
	UPDATE sales_report
	SET name = LTRIM(name)
	WHERE name IS NOT NULL
	
	SELECT * FROM sales_report
	
	-- Unique Values
	SELECT DISTINCT name, COUNT(*) FROM sales_report GROUP BY name --
	SELECT MIN(name), MAX(name) FROM sales_report WHERE name IS NOT NULL --
	
----------------------------------------------------------------------------------------------------------------------------------------