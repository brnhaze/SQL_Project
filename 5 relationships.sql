-- finding duplicate values

SELECT * FROM all_sessions -- 
SELECT * FROM analytics -- 
	
SELECT * FROM products -- 
	SELECT sku, COUNT(*) FROM products GROUP BY sku HAVING COUNT(*) > 1; -- PRIMARY KEY ? 1092 records

SELECT * FROM sales_by_sku -- 
	SELECT productsku, COUNT(*) FROM sales_by_sku GROUP BY productsku HAVING COUNT(*) > 1; -- PRIMARY KEY ? 462 records

SELECT * FROM sales_report -- 
	SELECT productsku, COUNT(*) FROM sales_report GROUP BY productsku HAVING COUNT(*) > 1; -- PRIMARY KEY ? 454 records
-------------------------------------------------------

-- IT_1
-- - ass_id (all_sessions) id INTEGER
-- - an_id (analytics) id INTEGER

-- IT_2
-- - an_id (analytics) id INTEGER
-- - prod_id (products) id INTEGER

-- IT_3
-- - prod_id (products) id INTEGER
-- - sbs_id (sales_by_sku) id INTEGER

-- IT_4
-- - sbs_id (sales_by_sku) id INTEGER
-- - sr_id (sales_report) id INTEGER

---------------

-- testing: works
SELECT ass.fullvisitorid, an.visitid, p.sku, ass.currencycode
FROM all_sessions AS ass
JOIN analytics AS an USING(id)
JOIN products AS p USING(id)

---

SELECT * FROM IT_1

ALTER TABLE IT_1
ADD COLUMN id SERIAL PRIMARY KEY

-- INSERT INTO IT_1 (ass_id)
-- SELECT id
-- FROM all_sessions;

INSERT INTO IT_1 (an_id)
SELECT id
FROM analytics;

---

SELECT * FROM IT_2

ALTER TABLE IT_2
ADD COLUMN id SERIAL PRIMARY KEY

-- INSERT INTO IT_2 (an_id)
-- SELECT id
-- FROM analytics;

INSERT INTO IT_2 (prod_id)
SELECT id
FROM products;

---

SELECT * FROM IT_3

ALTER TABLE IT_3
ADD COLUMN id SERIAL PRIMARY KEY

-- INSERT INTO IT_3 (prod_id)
-- SELECT id
-- FROM products;

INSERT INTO IT_3 (sbs_id)
SELECT id
FROM sales_by_sku;

--- 

SELECT * FROM IT_4

ALTER TABLE IT_4
ADD COLUMN id SERIAL PRIMARY KEY

-- INSERT INTO IT_4 (sbs_id)
-- SELECT id
-- FROM sales_by_sku;

INSERT INTO IT_4 (sr_id)
SELECT id
FROM sales_report;

----------------------------------------------------------------

ALTER TABLE all_sessions
ADD COLUMN id SERIAL PRIMARY KEY
-- test SELECT id FROM all_sessions -- 15134

ALTER TABLE analytics
ADD COLUMN id SERIAL PRIMARY KEY
-- test SELECT id FROM analytics -- 4301122

ALTER TABLE products
ADD COLUMN id SERIAL PRIMARY KEY
-- test SELECT id FROM products -- 1092

ALTER TABLE sales_by_sku
ADD COLUMN id SERIAL PRIMARY KEY
-- test SELECT id FROM sales_by_sku -- 462

ALTER TABLE sales_report
ADD COLUMN id SERIAL PRIMARY KEY
-- test SELECT id FROM sales_report -- 454

------------------------------------------------------------------------
-- SELECT * FROM all_sessions

SELECT fullvisitorid, COUNT(*) FROM all_sessions GROUP BY fullvisitorid HAVING COUNT(*) > 1;
SELECT channelgrouping, COUNT(*) FROM all_sessions GROUP BY channelgrouping HAVING COUNT(*) > 1;
SELECT time, COUNT(*) FROM all_sessions GROUP BY time HAVING COUNT(*) > 1;
SELECT country, COUNT(*) FROM all_sessions GROUP BY country HAVING COUNT(*) > 1;
SELECT city, COUNT(*) FROM all_sessions GROUP BY city HAVING COUNT(*) > 1;
SELECT totaltransactionrevenue, COUNT(*) FROM all_sessions GROUP BY totaltransactionrevenue HAVING COUNT(*) > 1;
SELECT transactions, COUNT(*) FROM all_sessions GROUP BY transactions HAVING COUNT(*) > 1;
SELECT timeonsite, COUNT(*) FROM all_sessions GROUP BY timeonsite HAVING COUNT(*) > 1;
SELECT pageviews, COUNT(*) FROM all_sessions GROUP BY pageviews HAVING COUNT(*) > 1;
SELECT sessionqualitydim, COUNT(*) FROM all_sessions GROUP BY sessionqualitydim HAVING COUNT(*) > 1;
SELECT date, COUNT(*) FROM all_sessions GROUP BY date HAVING COUNT(*) > 1;
SELECT visitid, COUNT(*) FROM all_sessions GROUP BY visitid HAVING COUNT(*) > 1;
SELECT type, COUNT(*) FROM all_sessions GROUP BY type HAVING COUNT(*) > 1;
SELECT productrefundamount, COUNT(*) FROM all_sessions GROUP BY productrefundamount HAVING COUNT(*) > 1;
SELECT productquantity, COUNT(*) FROM all_sessions GROUP BY productquantity HAVING COUNT(*) > 1;
SELECT productprice, COUNT(*) FROM all_sessions GROUP BY productprice HAVING COUNT(*) > 1;
SELECT productrevenue, COUNT(*) FROM all_sessions GROUP BY productrevenue HAVING COUNT(*) > 1;
SELECT productsku, COUNT(*) FROM all_sessions GROUP BY productsku HAVING COUNT(*) > 1;
SELECT v2productname, COUNT(*) FROM all_sessions GROUP BY v2productname HAVING COUNT(*) > 1;
SELECT v2productcategory, COUNT(*) FROM all_sessions GROUP BY v2productcategory HAVING COUNT(*) > 1;
SELECT productvariant, COUNT(*) FROM all_sessions GROUP BY productvariant HAVING COUNT(*) > 1;
SELECT currencycode, COUNT(*) FROM all_sessions GROUP BY currencycode HAVING COUNT(*) > 1;
SELECT itemquantity, COUNT(*) FROM all_sessions GROUP BY itemquantity HAVING COUNT(*) > 1;
SELECT itemrevenue, COUNT(*) FROM all_sessions GROUP BY itemrevenue HAVING COUNT(*) > 1;
SELECT transactionid, COUNT(*) FROM all_sessions GROUP BY transactionid HAVING COUNT(*) > 1;
SELECT pagetitle, COUNT(*) FROM all_sessions GROUP BY pagetitle HAVING COUNT(*) > 1;
SELECT searchkeyword, COUNT(*) FROM all_sessions GROUP BY searchkeyword HAVING COUNT(*) > 1;
SELECT pagepathlevel1, COUNT(*) FROM all_sessions GROUP BY pagepathlevel1 HAVING COUNT(*) > 1;
SELECT ecommercereaction_type, COUNT(*) FROM all_sessions GROUP BY ecommercereaction_type HAVING COUNT(*) > 1;
SELECT ecommercereaction_step, COUNT(*) FROM all_sessions GROUP BY ecommercereaction_step HAVING COUNT(*) > 1;
SELECT ecommercereaction_option, COUNT(*) FROM all_sessions GROUP BY ecommercereaction_option HAVING COUNT(*) > 1;
SELECT id, COUNT(*) FROM all_sessions GROUP BY id HAVING COUNT(*) > 1;

-- SELECT * FROM analytics

SELECT visitnumber, COUNT(*) FROM analytics GROUP BY visitnumber HAVING COUNT(*) > 1;
SELECT date, COUNT(*) FROM analytics GROUP BY date HAVING COUNT(*) > 1;
SELECT userid, COUNT(*) FROM analytics GROUP BY userid HAVING COUNT(*) > 1;
SELECT channelgrouping, COUNT(*) FROM analytics GROUP BY channelgrouping HAVING COUNT(*) > 1;
SELECT socialengagementtype, COUNT(*) FROM analytics GROUP BY socialengagementtype HAVING COUNT(*) > 1;
SELECT units_sold, COUNT(*) FROM analytics GROUP BY units_sold HAVING COUNT(*) > 1;
SELECT pageviews, COUNT(*) FROM analytics GROUP BY pageviews HAVING COUNT(*) > 1;
SELECT timeonsite, COUNT(*) FROM analytics GROUP BY timeonsite HAVING COUNT(*) > 1;
SELECT bounces, COUNT(*) FROM analytics GROUP BY bounces HAVING COUNT(*) > 1;
SELECT revenue, COUNT(*) FROM analytics GROUP BY revenue HAVING COUNT(*) > 1;
SELECT unit_price, COUNT(*) FROM analytics GROUP BY unit_price HAVING COUNT(*) > 1;
SELECT visitstartime, COUNT(*) FROM analytics GROUP BY visitstartime HAVING COUNT(*) > 1;
SELECT visitid, COUNT(*) FROM analytics GROUP BY visitid HAVING COUNT(*) > 1;
SELECT fullvisitorid, COUNT(*) FROM analytics GROUP BY fullvisitorid HAVING COUNT(*) > 1;
SELECT id, COUNT(*) FROM analytics GROUP BY id HAVING COUNT(*) > 1;

-- SELECT * FROM products
SELECT sku, COUNT(*) FROM products GROUP BY sku HAVING COUNT(*) > 1; -- No duplicates
SELECT name, COUNT(*) FROM products GROUP BY name HAVING COUNT(*) > 1;
SELECT orderedquantity, COUNT(*) FROM products GROUP BY orderedquantity HAVING COUNT(*) > 1;
SELECT stocklevel, COUNT(*) FROM products GROUP BY stocklevel HAVING COUNT(*) > 1;
SELECT sentimentscore, COUNT(*) FROM products GROUP BY sentimentscore HAVING COUNT(*) > 1;
SELECT sentimentmagnitude, COUNT(*) FROM products GROUP BY sentimentmagnitude HAVING COUNT(*) > 1;
SELECT restockingleadtime, COUNT(*) FROM products GROUP BY restockingleadtime HAVING COUNT(*) > 1;
SELECT visitnumber, COUNT(*) FROM products GROUP BY visitnumber HAVING COUNT(*) > 1;


-- SELECT * FROM sales_by_sku
SELECT productsku, COUNT(*) FROM sales_by_sku GROUP BY productsku HAVING COUNT(*) > 1; -- no duplicates
SELECT total_ordered, COUNT(*) FROM sales_by_sku GROUP BY total_ordered HAVING COUNT(*) > 1;

-- SELECT * FROM sales_report
SELECT productsku, COUNT(*) FROM sales_report GROUP BY productsku HAVING COUNT(*) > 1; -- no duplicates
SELECT total_ordered, COUNT(*) FROM sales_report GROUP BY total_ordered HAVING COUNT(*) > 1;
SELECT name, COUNT(*) FROM sales_report GROUP BY name HAVING COUNT(*) > 1;
SELECT stocklevel, COUNT(*) FROM sales_report GROUP BY stocklevel HAVING COUNT(*) > 1;
SELECT sentimentscore, COUNT(*) FROM sales_report GROUP BY sentimentscore HAVING COUNT(*) > 1;
SELECT sentimentmagnitude, COUNT(*) FROM sales_report GROUP BY sentimentmagnitude HAVING COUNT(*) > 1;
SELECT ratio, COUNT(*) FROM sales_report GROUP BY ratio HAVING COUNT(*) > 1;
SELECT restockingleadtime, COUNT(*) FROM sales_report GROUP BY restockingleadtime HAVING COUNT(*) > 1;

-------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM all_sessions -- id"
SELECT * FROM analytics -- id
SELECT * FROM intermediate_table
SELECT * FROM products -- sku
SELECT * FROM sales_by_sku -- productsku
SELECT * FROM sales_report -- productsku

-- all_session to products


-- analytics to intermediate_table
SELECT an.id, it.visitnumber
FROM analytics AS an
JOIN intermediate_table AS it USING(visitnumber)

SELECT *
FROM analytics AS an
FULL OUTER JOIN all_sessions AS ass ON an.visitid = ass.id
WHERE ass.id = 4162285926

-- possibly different datatypes of PRIMARY KEY and FOREIGN KEY
-- intermediate table is empty
-- values b/w P and F must match including datatype
-- remove "id" as primary keys
	-- use sku or productsku instead