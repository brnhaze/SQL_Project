CREATE TABLE analytics(visitnumber integer, visitid bigint, visitstarttime interval, date date, revenue numeric, unit_price numeric,
	id integer, userid integer, units_sold integer, pageviews integer, timeonsite interval, bounces integer, fullvisitorid character varying,
	socialengagementtype text, channelgrouping text);
	

-- DIVIDE unit_price and revenue by 1000000
	UPDATE analytics
	SET unit_price = unit_price/1000000, revenue = revenue/1000000
	
-- 	SELECT units_sold, unit_price, revenue FROM analytics WHERE units_sold IS NOT NULL -- verify
	
	-- ROUND Numeric
	UPDATE analytics
	SET unit_price = ROUND(unit_price, 2),
	revenue = ROUND(revenue, 2)
	
-- Change 0.00 values to NULL (as mentioned ealrier)
	UPDATE analytics
	SET unit_price = NULL
	WHERE unit_price = 0.00

-- Change "-89" to Positve
	UPDATE analytics
	SET units_sold = '89'
	WHERE units_sold = '-89'

-- Change from (Other) to Other to keep consistent
	UPDATE analytics
	SET channelgrouping = 'Other'
	WHERE channelgrouping = '(Other)'

-- change datatype to TIME/INTRVAL
	ALTER TABLE analytics
	ALTER COLUMN visitstarttime TYPE INTERVAL
	USING visitstarttime::INTERVAL
	
-- remove : from value
	UPDATE analytics
	SET visitid = REPLACE(visitid::TEXT, ':', '')
	
-- change datatype to INTEGER -- value out of reach for INTEGER , changed to BIGINT
	ALTER TABLE analytics
	ALTER COLUMN visitid TYPE BIGINT
	USING visitid::BIGINT
	
-- change datatype to INTEGER
		-- INTEGER and BIGINT out of range error
	ALTER TABLE analytics
	ALTER COLUMN fullvisitorid TYPE BIGINT
	USING fullvisitorid::BIGINT
	
