-- create table country_currency

CREATE TABLE IF NOT EXISTS country_currency (
    country VARCHAR(255),
    currencycode VARCHAR(255)
);

-- import csv file country_currency.csv

SELECT * FROM country_currency

-- window function

CREATE OR REPLACE FUNCTION update_currency_code()
RETURNS VOID AS $$
DECLARE
    country_rec RECORD;
BEGIN
    FOR country_rec IN (SELECT country, currencycode FROM country_currency) LOOP
        -- Update all_sessions table with the corresponding currency code
        UPDATE all_sessions
        SET currencycode = country_rec.currencycode
        WHERE country = country_rec.country;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

--


SELECT * FROM country_currency