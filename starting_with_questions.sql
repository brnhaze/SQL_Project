-- **Question 1: Which cities and countries have the highest level of transaction revenues on the site?**

SELECT * FROM all_sessions

-- SELECT city, country, transactionrevenue
-- FROM all_sessions
-- WHERE transactionrevenue = (SELECT MAX(transactionrevenue) FROM all_sessions)

SELECT city, country, transactionrevenue
FROM all_sessions
WHERE transactionrevenue IS NOT NULL
ORDER BY transactionrevenue DESC
LIMIT 5

-- **Question 2: What is the average number of products ordered from visitors in each city and country?** ?????????????????????

SELECT AVG(orderedquantity) FROM products
SELECT a_s.city, a_s.country, a_s.fullvisitorid FROM all_sessions AS a_s

SELECT
    ass.fullvisitorid, ass.country, ass.city, p.orderedquantity,
    ROUND(AVG(orderedquantity) OVER (PARTITION BY city, country),0) AS avg_num_prod_ordered
FROM all_sessions AS ass
JOIN analytics AS an USING(id)
JOIN products AS p USING(id)
WHERE ass.city IS NOT NULL
	AND ass.country IS NOT NULL
	AND ass.fullvisitorid IS NOT NULL
	AND p.orderedquantity IS NOT NULL
GROUP BY orderedquantity, city, country, ass.fullvisitorid

---

-- SELECT
--     ass.fullvisitorid, ass.country, ass.city, p.orderedquantity,
--     ROUND(AVG(p.orderedquantity) OVER (PARTITION BY ass.country, ass.city), 0) AS avg_num_prod_ordered
-- FROM all_sessions AS ass
-- JOIN analytics AS an USING(id)
-- JOIN products AS p USING(id)
-- WHERE ass.city IS NOT NULL
--     AND ass.country IS NOT NULL
--     AND ass.fullvisitorid IS NOT NULL
--     AND p.orderedquantity IS NOT NULL
-- GROUP BY ass.country, ass.city, ass.fullvisitorid, p.orderedquantity

-- **Question 3: Is there any pattern in the types (product categories) of products ordered from visitors in each city and country?**

SELECT * FROM all_sessions
SELECT v2productcategory, city, country FROM all_sessions

SELECT * FROM products
SELECT orderedquantity FROM products

--

-- SELECT ass.city, ass.country, ass.v2productcategory,
-- 	COUNT(*) As total_orders,
-- ROUND(AVG(p.orderedquantity),0) AS avg_od_qty
-- FROM all_sessions AS ass
-- JOIN analytics AS an USING(id)
-- JOIN products AS p USING(id)
-- WHERE ass.v2productcategory IS NOT NULL
-- 	AND ass.city IS NOT NULL
-- 	AND ass.country IS NOT NULL
-- GROUP BY ass.country, ass.city, ass.v2productcategory

--

SELECT
    ass.fullvisitorid, ass.country, ass.city,
    ARRAY_AGG(ass.v2productcategory) AS prod_cat,
	RANK() OVER (PARTITION BY ass.country, ass.city ORDER BY COUNT(*) DESC) AS category_rank
FROM all_sessions AS ass
JOIN analytics AS an USING (id)
JOIN products AS p USING (id)
WHERE ass.city IS NOT NULL
    AND ass.country IS NOT NULL
    AND ass.fullvisitorid IS NOT NULL
    AND ass.v2productcategory IS NOT NULL
GROUP BY ass.country, ass.city, ass.fullvisitorid

-- **Question 4: What is the top-selling product from each city/country? Can we find any pattern worthy of noting in the products sold?**

SELECT * FROM all_sessions AS ass -- city, country, v2productname, 
SELECT * FROM analytics AS an -- 
SELECT * FROM products AS p -- 
SELECT * FROM sales_by_sku AS sbu -- 
SELECT * FROM sales_report AS sr -- productsku, total_ordered, name

-- SELECT ass.city, ass.country, sr.productsku, sr.total_ordered, sr.name
-- FROM all_sessions AS ass
-- JOIN sales_report AS sr USING(id)
-- WHERE ass.city IS NOT NULL
-- 	AND ass.country IS NOT NULL
-- 	AND sr.productsku IS NOT NULL
-- 	AND sr.total_ordered IS NOT NULL
-- 	AND sr.name IS NOT NULL
	
--

WITH ProductRanks AS (
    SELECT ass.city, ass.country, sr.productsku, sr.total_ordered, sr.name,
        RANK() OVER (PARTITION BY ass.city, ass.country ORDER BY sr.total_ordered DESC) AS product_rank
    FROM all_sessions AS ass
    JOIN sales_report AS sr USING (id)
    WHERE ass.city IS NOT NULL
        AND ass.country IS NOT NULL
        AND sr.productsku IS NOT NULL
        AND sr.total_ordered IS NOT NULL
        AND sr.name IS NOT NULL)
SELECT productsku, name, total_ordered, city, country, product_rank
FROM ProductRanks
WHERE product_rank = 1


-- **Question 5: Can we summarize the impact of revenue generated from each city/country?**

-- SELECT * FROM all_sessions AS ass -- ass.city, ass.country, ass.productprice
-- SELECT * FROM analytics AS an -- an.unit_price
-- SELECT * FROM products AS p -- p.sku, p.orderedquantity
-- SELECT * FROM sales_by_sku AS sbs -- sbs.productsku, sbs.total_ordered
-- SELECT * FROM sales_report AS sr -- sr.productsku, sr.total_ordered

-- SELECT ass.city, ass.country, ass.productprice FROM all_sessions AS ass,
-- SELECT an.unit_price FROM analytics AS an,
-- SELECT p.sku, p.orderedquantity FROM products AS p,
-- SELECT sbs.productsku, sbs.total_ordered FROM sales_by_sku AS sbs,
-- SELECT sr.productsku, sr.total_ordered FROM sales_report AS sr

WITH rev_sum AS (
    SELECT ass.city, ass.country,
        SUM(ass.productprice * p.orderedquantity * sbs.total_ordered) AS total_rev
    FROM all_sessions AS ass
    JOIN analytics AS an USING(id)
    JOIN products AS p USING(id)
    JOIN sales_by_sku AS sbs USING(id)
    GROUP BY ass.city, ass.country)
SELECT city, country, total_rev
FROM rev_sum
WHERE total_rev IS NOT NULL
	AND city IS NOT NULL
	AND total_rev > 0
ORDER BY total_rev DESC

-- SELECT city, COUNT(*) FROM all_sessions WHERE city IS NOT NULL GROUP BY city 