# President-Election-Analysis
Indian-Presidential-Election-Analysis

# President Election Analysis (SQL)

# Project Overview
This project analyzes President of India election data using SQL.  
It covers database design, table relationships, sample data insertion, and analytical queries to extract meaningful election insights.

The project demonstrates a strong understanding of SQL concepts such as joins, aggregations, constraints, and real-world data modeling.



# Database Design
The database consists of the following tables:

Office  
Stores election offices such as President and Vice President.

Candidate  
Stores candidate details and is linked to the Office table.

Voter  
Stores voter information.

Vote  
Stores voting records that connect voters and candidates.

An ER Diagram is included to visually represent table relationships.



## Tools and Technologies
SQL  
Relational Database Concepts  
ER Diagram for schema visualization



# Key Features and Queries
Creation and management of the election database  
Insertion of sample data for offices, candidates, voters, and votes  
Display of candidates with their respective offices  
Vote count calculation for each candidate  
Overall winner identification based on maximum votes  
Vote percentage calculation for each candidate  
Majority winner detection with more than 50 percent votes  
Voter-wise voting details including candidate and office



# Sample Insights
Vote distribution across candidates  
Winner identification using aggregate functions  
Majority calculation using HAVING clause  
Safe calculations using NULLIF to avoid divide-by-zero errors



# Files Included
PRESIDENT OF INDIA ELECTIONS.sql – Complete SQL script  
president_election_er_diagram.pdf – ER diagram of the database


# Outcome
This project demonstrates practical SQL skills including database design, data integrity using foreign keys, analytical querying, and real-world election data modeling.

It is suitable for Data Analyst and SQL Developer roles.
