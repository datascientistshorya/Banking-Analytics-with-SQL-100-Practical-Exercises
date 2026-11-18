-- =====================================================
-- NEXUS BANK SQL INTERVIEW PRACTICE DATABASE
-- MySQL 8.0+
-- =====================================================

CREATE DATABASE IF NOT EXISTS nexus_bank_sql;

USE nexus_bank_sql;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS loan_payments;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS cards;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS branches;

SET FOREIGN_KEY_CHECKS = 1;

SET SESSION cte_max_recursion_depth = 10000;


-- =====================================================
-- 1. BRANCHES
-- =====================================================

CREATE TABLE branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    state VARCHAR(50),
    manager_name VARCHAR(100),
    opening_date DATE
);

INSERT INTO branches VALUES
(1, 'Nexus Mumbai Central', 'Mumbai', 'Maharashtra', 'Amit Sharma', '2005-04-15'),
(2, 'Nexus Delhi Main', 'New Delhi', 'Delhi', 'Neha Verma', '2008-07-20'),
(3, 'Nexus Bangalore Tech', 'Bangalore', 'Karnataka', 'Rahul Mehta', '2010-02-10'),
(4, 'Nexus Chennai South', 'Chennai', 'Tamil Nadu', 'Priya Nair', '2012-11-05'),
(5, 'Nexus Hyderabad City', 'Hyderabad', 'Telangana', 'Vikram Rao', '2014-06-18'),
(6, 'Nexus Pune Central', 'Pune', 'Maharashtra', 'Sneha Patil', '2016-09-12'),
(7, 'Nexus Haldwani Branch', 'Haldwani', 'Uttarakhand', 'Arjun Bisht', '2018-03-25'),
(8, 'Nexus Jaipur Branch', 'Jaipur', 'Rajasthan', 'Karan Singh', '2020-01-15');


-- =====================================================
-- 2. CUSTOMERS
-- =====================================================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(20),
    date_of_birth DATE,
    city VARCHAR(50),
    state VARCHAR(50),
    customer_segment VARCHAR(30),
    registration_date DATE,
    branch_id INT,

    FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
);

INSERT INTO customers (
    customer_id,
    first_name,
    last_name,
    gender,
    date_of_birth,
    city,
    state,
    customer_segment,
    registration_date,
    branch_id
)
WITH RECURSIVE seq(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 1200
)
SELECT
    n,

    ELT(
        MOD(n - 1, 20) + 1,
        'Aarav', 'Vivaan', 'Aditya', 'Arjun',
        'Rohan', 'Ishita', 'Ananya', 'Priya',
        'Neha', 'Rahul', 'Karan', 'Sneha',
        'Vikram', 'Meera', 'Kabir', 'Aisha',
        'Dev', 'Riya', 'Aman', 'Nisha'
    ),

    ELT(
        MOD(n * 7, 20) + 1,
        'Sharma', 'Verma', 'Singh', 'Mehta',
        'Patel', 'Rao', 'Nair', 'Gupta',
        'Joshi', 'Kapoor', 'Malhotra', 'Das',
        'Bisht', 'Kumar', 'Mishra', 'Chopra',
        'Iyer', 'Reddy', 'Saxena', 'Thakur'
    ),

    CASE
        WHEN MOD(n, 13) = 0 THEN NULL
        WHEN MOD(n, 2) = 0 THEN 'Male'
        ELSE 'Female'
    END,

    CASE
        WHEN MOD(n, 29) = 0 THEN NULL
        ELSE DATE_ADD(
            '1955-01-01',
            INTERVAL MOD(n * 173, 16400) DAY
        )
    END,

    CASE
        WHEN MOD(n, 31) = 0 THEN NULL
        WHEN MOD(n, 13) = 0 THEN ' HALDWANI '
        WHEN MOD(n, 13) = 1 THEN 'haldwani'
        ELSE ELT(
            MOD(n - 1, 8) + 1,
            'Mumbai', 'Delhi', 'Bangalore', 'Chennai',
            'Hyderabad', 'Pune', 'Haldwani', 'Jaipur'
        )
    END,

    CASE
        WHEN MOD(n, 31) = 0 THEN NULL
        ELSE ELT(
            MOD(n - 1, 8) + 1,
            'Maharashtra', 'Delhi', 'Karnataka',
            'Tamil Nadu', 'Telangana', 'Maharashtra',
            'Uttarakhand', 'Rajasthan'
        )
    END,

    CASE
        WHEN MOD(n, 97) = 0 THEN NULL
        WHEN MOD(n, 10) < 5 THEN 'Retail'
        WHEN MOD(n, 10) < 8 THEN 'Premium'
        ELSE 'Business'
    END,

    DATE_ADD(
        '2017-01-01',
        INTERVAL MOD(n * 19, 3500) DAY
    ),

    MOD(n - 1, 8) + 1

FROM seq;


-- =====================================================
-- 3. ACCOUNTS
-- =====================================================

CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    account_type VARCHAR(30),
    opening_date DATE,
    balance DECIMAL(15,2),
    account_status VARCHAR(20),
    interest_rate DECIMAL(5,2),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
);

INSERT INTO accounts (
    account_id,
    customer_id,
    branch_id,
    account_type,
    opening_date,
    balance,
    account_status,
    interest_rate
)
WITH RECURSIVE seq(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 2400
)
SELECT
    n,

    FLOOR((n - 1) / 2) + 1,

    MOD(n * 3, 8) + 1,

    ELT(
        MOD(n - 1, 4) + 1,
        'Savings', 'Current', 'Salary', 'Fixed Deposit'
    ),

    DATE_ADD(
        '2017-01-01',
        INTERVAL MOD(n * 23, 3300) DAY
    ),

    ROUND(1000 + MOD(n * 7919, 1500000), 2),

    CASE
        WHEN MOD(n, 23) = 0 THEN 'Closed'
        WHEN MOD(n, 11) = 0 THEN 'Dormant'
        ELSE 'Active'
    END,

    CASE
        WHEN MOD(n, 19) = 0 THEN NULL
        WHEN MOD(n - 1, 4) = 0 THEN 3.50
        WHEN MOD(n - 1, 4) = 1 THEN 0.00
        WHEN MOD(n - 1, 4) = 2 THEN 2.50
        ELSE 6.75
    END

FROM seq;


-- =====================================================
-- 4. TRANSACTIONS
-- =====================================================

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_date DATETIME,
    transaction_type VARCHAR(30),
    amount DECIMAL(15,2),
    transaction_status VARCHAR(20),
    channel VARCHAR(30),
    merchant_category VARCHAR(50),

    FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);

INSERT INTO transactions (
    transaction_id,
    account_id,
    transaction_date,
    transaction_type,
    amount,
    transaction_status,
    channel,
    merchant_category
)
WITH RECURSIVE seq(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 9600
)
SELECT
    n,

    MOD(n * 7 - 1, 2400) + 1,

    TIMESTAMP(
        DATE_ADD(
            '2024-01-01',
            INTERVAL MOD(n * 17, 1050) DAY
        ),
        MAKETIME(
            MOD(n * 7, 24),
            MOD(n * 11, 60),
            MOD(n * 13, 60)
        )
    ),

    ELT(
        MOD(n - 1, 4) + 1,
        'Deposit', 'Withdrawal', 'Transfer', 'Payment'
    ),

    ELT(
        MOD(n - 1, 12) + 1,
        500, 1000, 2500, 5000,
        10000, 25000, 50000, 100000,
        250000, 750, 1500, 7500
    ),

    CASE
        WHEN MOD(n, 17) = 0 THEN 'Failed'
        WHEN MOD(n, 13) = 0 THEN 'Pending'
        ELSE 'Success'
    END,

    CASE
        WHEN MOD(n, 113) = 0 THEN NULL
        ELSE ELT(
            MOD(n - 1, 5) + 1,
            'ATM', 'Branch', 'Mobile', 'Internet', 'POS'
        )
    END,

    CASE
        WHEN MOD(n, 19) = 0 THEN NULL
        ELSE ELT(
            MOD(n - 1, 8) + 1,
            'Shopping', 'Utilities', 'Travel', 'Food',
            'Healthcare', 'Education', 'Entertainment', 'Fuel'
        )
    END

FROM seq;


-- =====================================================
-- 5. LOANS
-- =====================================================

CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    loan_type VARCHAR(30),
    loan_amount DECIMAL(15,2),
    interest_rate DECIMAL(5,2),
    loan_date DATE,
    tenure_months INT,
    loan_status VARCHAR(20),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
);

INSERT INTO loans (
    loan_id,
    customer_id,
    branch_id,
    loan_type,
    loan_amount,
    interest_rate,
    loan_date,
    tenure_months,
    loan_status
)
WITH RECURSIVE seq(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 720
)
SELECT
    n,

    MOD(n * 37 - 1, 1200) + 1,

    MOD(n * 5, 8) + 1,

    ELT(
        MOD(n - 1, 4) + 1,
        'Home', 'Personal', 'Auto', 'Business'
    ),

    ROUND(
        50000 + MOD(n * 13279, 4500000),
        2
    ),

    CASE
        WHEN MOD(n, 41) = 0 THEN NULL
        ELSE ROUND(7 + MOD(n * 7, 900) / 100, 2)
    END,

    DATE_ADD(
        '2020-01-01',
        INTERVAL MOD(n * 9, 1500) DAY
    ),

    ELT(
        MOD(n - 1, 5) + 1,
        12, 24, 36, 60, 120
    ),

    CASE
        WHEN MOD(n, 17) = 0 THEN 'Defaulted'
        WHEN MOD(n, 5) = 0 THEN 'Closed'
        ELSE 'Active'
    END

FROM seq;


-- =====================================================
-- 6. LOAN PAYMENTS
-- =====================================================

CREATE TABLE loan_payments (
    payment_id INT PRIMARY KEY,
    loan_id INT NOT NULL,
    payment_date DATE,
    payment_amount DECIMAL(15,2),
    payment_status VARCHAR(20),

    FOREIGN KEY (loan_id)
        REFERENCES loans(loan_id)
);

INSERT INTO loan_payments (
    payment_id,
    loan_id,
    payment_date,
    payment_amount,
    payment_status
)
WITH RECURSIVE seq(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 3600
)
SELECT
    n,

    MOD(n * 17 - 1, 600) + 1,

    DATE_ADD(
        '2024-03-01',
        INTERVAL MOD(n * 13, 980) DAY
    ),

    ROUND(
        2000 + MOD(n * 317, 50000),
        2
    ),

    CASE
        WHEN MOD(n, 19) = 0 THEN 'Failed'
        WHEN MOD(n, 7) = 0 THEN 'Late'
        ELSE 'Paid'
    END

FROM seq;


-- =====================================================
-- 7. CARDS
-- =====================================================

CREATE TABLE cards (
    card_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    account_id INT NOT NULL,
    card_type VARCHAR(20),
    issue_date DATE,
    expiry_date DATE,
    card_status VARCHAR(20),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);

INSERT INTO cards (
    card_id,
    customer_id,
    account_id,
    card_type,
    issue_date,
    expiry_date,
    card_status
)
WITH RECURSIVE seq(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 1600
)
SELECT
    n,

    FLOOR((MOD(n * 3 - 1, 2400)) / 2) + 1,

    MOD(n * 3 - 1, 2400) + 1,

    CASE
        WHEN MOD(n, 3) = 0 THEN 'Credit'
        ELSE 'Debit'
    END,

    DATE_ADD(
        '2021-01-01',
        INTERVAL MOD(n * 11, 1800) DAY
    ),

    CASE
        WHEN MOD(n, 37) = 0 THEN NULL
        ELSE DATE_ADD(
            '2023-01-01',
            INTERVAL MOD(n * 37, 1800) DAY
        )
    END,

    CASE
        WHEN MOD(n, 17) = 0 THEN 'Blocked'
        WHEN MOD(n, 11) = 0 THEN 'Expired'
        ELSE 'Active'
    END

FROM seq;


-- =====================================================
-- 8. EMPLOYEES
-- =====================================================

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    branch_id INT NOT NULL,
    designation VARCHAR(50),
    joining_date DATE,
    salary DECIMAL(12,2),

    FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
);

INSERT INTO employees (
    employee_id,
    employee_name,
    branch_id,
    designation,
    joining_date,
    salary
)
WITH RECURSIVE seq(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 96
)
SELECT
    n,

    CONCAT(
        ELT(
            MOD(n - 1, 10) + 1,
            'Amit', 'Neha', 'Rahul', 'Priya', 'Vikram',
            'Sneha', 'Arjun', 'Meera', 'Karan', 'Riya'
        ),
        ' ',
        ELT(
            MOD(n * 7, 10) + 1,
            'Sharma', 'Verma', 'Singh', 'Mehta', 'Patel',
            'Rao', 'Nair', 'Gupta', 'Joshi', 'Bisht'
        )
    ),

    MOD(n - 1, 8) + 1,

    ELT(
        MOD(n - 1, 5) + 1,
        'Branch Manager',
        'Relationship Manager',
        'Loan Officer',
        'Operations Analyst',
        'Customer Executive'
    ),

    DATE_ADD(
        '2016-01-01',
        INTERVAL MOD(n * 23, 3500) DAY
    ),

    ROUND(
        25000 + MOD(n * 1739, 100000),
        2
    )

FROM seq;


-- =====================================================
-- 9. INDEXES FOR ANALYTICAL QUERIES
-- =====================================================

CREATE INDEX idx_customers_branch
ON customers(branch_id);

CREATE INDEX idx_customers_segment
ON customers(customer_segment);

CREATE INDEX idx_accounts_customer
ON accounts(customer_id);

CREATE INDEX idx_accounts_branch
ON accounts(branch_id);

CREATE INDEX idx_accounts_status
ON accounts(account_status);

CREATE INDEX idx_transactions_account
ON transactions(account_id);

CREATE INDEX idx_transactions_date
ON transactions(transaction_date);

CREATE INDEX idx_transactions_status
ON transactions(transaction_status);

CREATE INDEX idx_transactions_channel
ON transactions(channel);

CREATE INDEX idx_loans_customer
ON loans(customer_id);

CREATE INDEX idx_loans_branch
ON loans(branch_id);

CREATE INDEX idx_loans_status
ON loans(loan_status);

CREATE INDEX idx_payments_loan
ON loan_payments(loan_id);

CREATE INDEX idx_payments_date
ON loan_payments(payment_date);

CREATE INDEX idx_cards_customer
ON cards(customer_id);

CREATE INDEX idx_employees_branch
ON employees(branch_id);



show tables;
select* from accounts;
select* from branches;
select* from cards;
select* from customers;
select* from employees;
select* from loan_payments;
select* from loans;
select* from transactions;