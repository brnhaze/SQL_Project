# ******** analytics.csv file was too large -- please use script to create columns: nalytics_too_big_script.sql

# Final-Project-Transforming-and-Analyzing-Data-with-SQL

## Information
- SQL_Project: https://github.com/brnhaze/SQL_Project
- Generated from: lighthouse-labs/Final-Project-SQL
- Pwd: ~/Documents/Lighthouselabs/Data Analysis/SQL_Project
  - File Path: C:\Users\ashwi\Documents\LighthouseLabs\Data Analysis\SQL_Project\Files\2024-02-23 Part_1

## CSV Files
- all_sessions.csv
- analytics.csv
- products.csv
- sales_by_sky.csv
- sales_report.csv
- country_currency.csv

## Created Tables
- country_currency
- Intermediate Tables
  - IT_1
  - IT_2
  - IT_3
  - IT_4
 
## Scripts
- 3 Data Profiling_Validation_Cleansing.sql
- starting_with_questions.sql
- 4 country_currencycode_scripting.sql
- 5 relationships.sql

## Images
- schema.png
- Q1_Image.jpg
- Q2_Image.jpg
- Q3_Image.jpg
- Q4_Image.jpg
- Q5_Image.jpg
- QA_1

## Project Description
  # Extracting data from a SQL database
  # Cleaning, transforming and analyzing data
  # Loading data into a database
  # Developing and implementing a QA process to validate transformed data against raw data

## Project Instructions
  ### Part 1: Loading csv Files into Database
    - Create Database (dB) called "ecommerce"
    - Set up tables
      - Resources
        - https://www.postgresqltutorial.com/postgresql-tutorial/import-csv-file-into-posgresql-table/
        - https://www.youtube.com/watch?v=6Jf7eTkIaR4
  ### Part 2: Data Cleaning
  ### Part 3: Starting with Questions
  ### Part 4: Starting with Data
  ### Part 5: QA Your Data

## Submission Guidelines
  1. README.md file
    - This file should be an overview of your project, covering roughly the same points as your presentation
  2. cleaning_data.md file
    - Fill out this file with a description of the issues that will be addressed by cleaning the data
    - Include the queries used to clean the data
  3. startingwithquestions.md file
    - Provide the answer to the 5 questions and the queries used to answer each question
  4. startingwithdata.md file
    - Provide the 3 - 5 new questions you decided could be answered with the data
    - Include the answer to each question and the accompanying queries used to obtain the answer
  5. QA.md file
    - Identify and describe your risk areas
    - Develop and execute a QA process to address the risk areas identified, providing the SQL queries used to implement
  6. schema.png file
    - This file should contain the ERD of the database

## Evaluation Ruberic
  - SQL
    - Implements advanced SQL techniques/skills
      - (i.e. changing data type or creating custom field within SQL query)
  - Data Acquisition
    - Finds relevant data sources with thought given to source reliability and the data quality.
    - Parses data efficiently
  - Data Audit
    - Identifies potential issues with quality and quantity of data and fixes issues at the source of the data .
    - Generates hypothesis of what can be done with the data.
  - Data Cleaning
    - Thinks beyond basic data cleaning techniques to consider additional data issues
    - (i.e. capitalization of text)
  - Tool Installation & Set Up
    - Recommends problem specific tools and can set up any tool stack required.
  - Coding Comprehension
    - Comments code using best practices for variable names, syntax etc.
    - Further explanation of code is not required.
  - Organization
    - README.md is well written, easily understood, and precise instructions are included.
    - Files created can easily be shared with others.
    - File organization allows for easy collaboration with others.

## Project/Goals
(fill in your description and goals here)
- Create a functioning database with relationships
- Clean the data
- Query and answer questions showing understanding of tables and relationships
- I wanted to understand the databases tables's columns and values, use commands to observe for duplicate, null, and unique values; in turn, create primary and secondary foreign keys to build relationships. I hoped this would have made the query process easier and better to ask and answer questions.

## Process
### (your step 1)
### (your step 2)
1. View .csv files
2. Find null, duplicate, and unique columns with data
3. Choose primary and foreign keys
4. create relationships and or intermediate tables
5. Attempt answering questions
6. data profiling, validation, cleansing, and testing (verifying)
7. Answer or modify questions answers
8. QA process
9. Reflection
10. Answer or modify questions answers
11. Reflection

## Results
(fill in what you discovered this data could tell you and how you used the data to answer those questions)
- data was all over the place
  - e.g., multiple productsku and sku with different product names and unit prices.
- sales_report.csv was chosen as the primary source for some questions
- It was difficult to build relationsihps with the tables because of the multiple and different values from different columns. Almost seemed as some csv files were from different entities.

## Challenges 
(discuss challenges you faced in the project)
- Creating relationships was difficult; I had to review and had a chat with Alibek
  - I chose to create Intermediate Tables to complete this task.
- Some columns such as productSKU and sku were difficult to eliminate characters to create a shortened unique value.
- I did not understand what some of the questions were asking.
- I had a difficult time trying to remember or choose what form syntax.
  - Failed at many but kept trying until working.
- Still having a hard time distinguishing which Subqueries to use and writing CTE's for questions I did not understand was not easy.

## Future Goals
(what would you do if you had more time?)
- I would like to be able to write more user-defined scripts. The one I wrote was not easy but I managed after watching some Youtube videos.
- Practicse using different functions and being able to recognize which windows-function may be best.
