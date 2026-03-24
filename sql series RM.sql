--1: Customer Transaction Summary
-- BUSINESS QUESTION:The retail banking team needs a complete
-- customer activity report showing each
-- customer's transaction history alongside
-- how they compare to the overall bank average.
SELECT
    c.customer_id,
    CONCAT(INITCAP(TRIM(c.first_name)),' ',INITCAP(TRIM(c.last_name))) AS full_name_clean,
    COALESCE(CAST(t.transaction_date AS VARCHAR),'No date on file') AS clean_transaction_date,
    COALESCE(t.transaction_type,'No transaction type on file') AS clean_transaction_type,
    COALESCE(t.amount,0.00) AS clean_amount,
    ROUND(AVG(COALESCE(t.amount,0.00)) OVER (),2) AS over_all_avg,
CASE
    WHEN t.amount > AVG(COALESCE(t.amount,0.00)) OVER () THEN 'ABOVE AVERAGE'
    ELSE 'BELOW AVERAGE'
END AS avg_check
FROM customers AS c
LEFT JOIN accounts AS a
ON c.customer_id = a.customer_id
LEFT JOIN transactions AS t
on a.account_id = t.account_id
WHERE a.status = 'active'
ORDER BY full_name_clean, t.transaction_date;


-- 2: Branch Loan Rankings
--
-- BUSINESS QUESTION:
-- The lending team wants to rank all
-- active loans by principal within
-- each branch to identify which
-- branches carry the heaviest
-- individual loan exposure.

SELECT
    c.customer_id,
    CONCAT(INITCAP(TRIM(c.first_name)),' ',INITCAP(TRIM(c.last_name))) AS full_name_clean,
    INITCAP(REPLACE(REPLACE(TRIM(b.branch_name),'   ',' '),'  ',' ')) AS branch_name_clean,
    COALESCE(l.loan_type,'No Loan TYPE') AS clean_loan_type,
    COALESCE(l.principal,0.00) AS clean_principal,
    RANK() OVER (PARTITION BY b.branch_id ORDER BY l.principal DESC) AS branch_loan_rank
FROM customers AS c
LEFT JOIN accounts AS a
ON c.customer_id = a.customer_id
LEFT JOIN branches AS b
ON a.branch_id = b.branch_id
LEFT JOIN loans AS l
ON c.customer_id = l.customer_id
WHERE l.status = 'active'
ORDER BY branch_name_clean, branch_loan_rank;

-- BUSINESS QUESTION 3:
-- The relationship management team wants
-- to understand how customers borrowing
-- behavior changes over time. They want
-- to see each loan alongside the previous
-- one and how much the customer's borrowing
-- has increased or decreased.



SELECT
    CONCAT(INITCAP(TRIM(c.first_name)),' ',INITCAP(TRIM(c.last_name))) AS full_name_clean,
    l.loan_type,
    l.principal,
    l.issued_date,
    COALESCE(LAG(l.principal) OVER (PARTITION BY c.customer_id ORDER BY issued_date), 0) AS previous_loan_comparison,
    l.principal - COALESCE(LAG(l.principal) OVER (PARTITION BY c.customer_id ORDER BY issued_date), 0) AS loan_principal_difference,
CASE
    WHEN LAG(l.principal) OVER (PARTITION BY c.customer_id ORDER BY issued_date) IS NULL THEN 'First Loan'
    WHEN l.principal - COALESCE(LAG(l.principal) OVER (PARTITION BY c.customer_id ORDER BY issued_date), 0) > 0 THEN 'Borrowing More'
    WHEN l.principal - COALESCE(LAG(l.principal) OVER (PARTITION BY c.customer_id ORDER BY issued_date), 0) < 0 THEN 'Borrowing Less'
    WHEN l.principal - COALESCE(LAG(l.principal) OVER (PARTITION BY c.customer_id ORDER BY issued_date), 0) = 0 THEN 'Same Amount'
    ELSE 'Unknown'
END AS trend
FROM customers AS c
LEFT JOIN loans AS l
ON c.customer_id = l.customer_id
WHERE l.status = 'active'
ORDER BY full_name_clean, l.issued_date;