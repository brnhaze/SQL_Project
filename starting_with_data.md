Question 1: 
  - What country is fullvisitorid 9087906 in the all_sessions table.

SQL Queries:
  
  SELECT * FROM all_sessions

  SELECT fullvisitorid, city, country, currencycode
  FROM all_sessions
  WHERE fullvisitorid = 9087906
    
  UPDATE all_sessions
  SET country = 'USA'
  WHERE fullvisitorid = 9087906

Answer: USA



Question 2: Compare all of the products using two different methods

SQL Queries:

  SELECT ass.productsku, ass.v2productname, p.name, p.sku, sbs.productsku, sr.name, sr.productsku
  FROM all_sessions AS ass
  JOIN products AS p USING(id)
  JOIN sales_by_sku AS sbs USING(id)
  JOIN sales_report AS sr USING(id)

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

  

Answer:
- UNON ALL method was more efficient; I had to deal with the difference in number of columns by using NULL to missing oclumns or informatoin.



Question 3: 

SQL Queries:

Answer:



Question 4: 

SQL Queries:

Answer:



Question 5: 

SQL Queries:

Answer:
