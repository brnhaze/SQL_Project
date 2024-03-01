Answer the following questions and provide the SQL queries used to find the answer.

**Question 1: Which cities and countries have the highest level of transaction revenues on the site?**


SQL Queries:
   
    SELECT city, country, transactionrevenue
    FROM all_sessions
    WHERE transactionrevenue IS NOT NULL
    ORDER BY transactionrevenue DESC
    LIMIT 5
    
Answer: See Q1_Image

- United States Top 5
- Top 2 cities values not in data set
- 3rd  city is Sunnyvale

**Question 2: What is the average number of products ordered from visitors in each city and country?**

SQL Queries:

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

Answer: See Q2_Image

**Question 3: Is there any pattern in the types (product categories) of products ordered from visitors in each city and country?**

SQL Queries:

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

Answer: No ? See Q3_Image

**Question 4: What is the top-selling product from each city/country? Can we find any pattern worthy of noting in the products sold?**

SQL Queries:

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

Answer: See Q4_Image

**Question 5: Can we summarize the impact of revenue generated from each city/country?**

SQL Queries:

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

Answer: See Q5_Image







