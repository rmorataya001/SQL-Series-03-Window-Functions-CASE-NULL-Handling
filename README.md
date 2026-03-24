# SQL-Series-03-Window-Functions-CASE-NULL-Handling

# SQL Portfolio Series: Window Functions, CASE, and NULL Handling
**Author:** Rene Morataya  
**Database:** PostgreSQL (DatsGRIP)  
**Series:** SQL Series 03: Window Functions, CASE Statements, and NULL Handling

---

## Business Questions Answered

This series entry answers three real banking analytics questions using advanced SQL techniques on a custom built synthetic banking database.

### Query 1: Customer Transaction Summary
**Question:** Which transactions are above or below the overall bank average?  
**What it answers:** The retail banking team gets a complete transaction report showing every customer's activity alongside the bank wide average — making outliers immediately visible without losing row level detail.  
**Concepts:** Window AVG, OVER(), COALESCE, CASE, 3-table JOIN

### Query 2: Branch Loan Rankings
**Question:** Which customers carry the heaviest loan exposure within each branch?  
**What it answers:** The lending team can identify which branches hold the highest individual loan risk and which customers are driving that exposure at a local level.  
**Concepts:** RANK(), PARTITION BY branch, 4-table JOIN, string cleaning

### Query 3: Customer Loan Progression
**Question:** How has each customer's borrowing behavior changed over time?  
**What it answers:** The relationship management team can see whether each customer is borrowing more or less over time — giving them early signals for retention opportunities or default risk.  
**Concepts:** LAG, COALESCE, CASE trend labels, PARTITION BY customer

---

## Overview

This is the third entry in my ongoing SQL learning series. While working through a structured SQL course and building my own synthetic banking database from scratch, I tackled some of the more advanced concepts that separate basic querying from real analytical thinking.

This one was a step up. Window functions, trend analysis with LAG, conditional logic with CASE, and NULL handling all in the same queries. Not every query is perfect and that is intentional. This is learning in public.

Every query was written manually. Claude AI was used as a tutor to review answers, explain mistakes, and push the difficulty progressively.

---

## Database Schema

This series uses a custom built banking database called `banking_portfolio_v2` with 8 connected tables:

- **customers:** profiles, contact info, credit scores
- **accounts:** checking, savings, money market accounts
- **transactions:** deposits, withdrawals, fees, transfers, interest
- **loans:** personal, auto, student, mortgage with status tracking
- **loan_payments:** payment history per loan
- **credit_cards:** card types, limits, balances, statuses
- **branches:** physical bank locations with dirty data intentionally baked in
- **employees:** bank staff linked to branches with salary and hire dates

The data includes intentional dirty data: inconsistent casing, extra spaces, NULL values, and duplicate-ish names to simulate real world data quality challenges.

---

## Concepts Applied

**Window Functions**
- `OVER()`: defines the window for calculations without collapsing rows
- `PARTITION BY`: splits the window into groups, similar to GROUP BY but keeps all rows
- `ORDER BY` inside OVER: controls row order within the window
- `RANK()`: ranks rows within a partition, ties get the same rank and skip the next number
- `DENSE_RANK()`: same as RANK but no skipping on ties
- Running totals using default frame behavior

**LAG for Trend Analysis**
- `LAG(column, offset, default)`: grabs the value from a previous row
- Used to compare each loan to the customer's previous loan
- Combined with CASE to label borrowing trends over time

**CASE Statements**
- Conditional logic to label and categorize data
- Used alongside window functions to flag above or below average transactions
- Combined with LAG differences to produce trend labels

**NULL Handling**
- `COALESCE`: replaces NULL with a fallback value
- `NULLIF`: turns a value into NULL when it matches a condition
- Wrapping window functions in COALESCE for clean output
- Understanding the difference between filtering NULLs out vs labeling them

**String Cleaning**
- `INITCAP`, `TRIM`, `REPLACE` nested together for branch and customer name cleaning
- Handling inconsistent casing and extra spaces in real data

**Multi-table JOINs**
- 4 table LEFT JOIN chains across customers, accounts, branches, loans, and transactions
- Understanding how many-to-many relationships create duplicate rows
- Using branch_id vs branch_name for partitioning to avoid dirty data issues

---

## Honest Notes

- Query 2 has a known duplicate row issue caused by a many-to-many relationship between accounts and loans. The fix requires subqueries or CTEs which are next in the learning series.
- Query 1 uses COALESCE inside AVG which slightly skews the average by replacing NULLs with zeros before calculating. A cleaner approach is letting AVG ignore NULLs naturally.
- These are intentionally left as is. Real data work involves iteration and improvement over time.

---

## Next Steps

This project is purely for SQL practice and skill building. The natural next step would be to take these business questions further by connecting the cleaned data to a visualization tool like Tableau or Power BI for a deeper dive into the patterns. For example the loan progression trends from Query 3 and the transaction averages from Query 1 would both make compelling dashboards for a full banking analytics report. That is a future project once the SQL fundamentals are fully locked in.

---

## What is Next in the Series

- Subqueries: fixing the duplicate row issue properly
- CTEs: cleaner and more readable ways to stage complex queries
- More window function patterns as the course progresses

---

## Series Index

| Entry | Topic |
|-------|-------|
| SQL Series 01 | JOINs and Aggregations |
| SQL Series 02 | String Functions and Data Cleaning |
| SQL Series 03 | Window Functions, CASE, and NULL Handling (this entry) |
| SQL Series 04 | Coming soon: Subqueries and CTEs |
