-- Basics
-- Q1. Retrieve all records from the customers table.

select* from customers;

-- 2	Display customer ID, first name, last name, city and customer segment.
select customer_id, first_name,last_name,city, customer_segment from customers;

-- Find all unique customer segments.
select distinct customer_segment from customers;

-- 4	Retrieve the five accounts with the highest balances.
select* from accounts
order by balance desc limit 5;

-- 5	Display customers alphabetically by last name, then first name.
select first_name, last_name from customers
order by last_name,first_name;

-- 6	Retrieve transaction ID, amount and transaction type. Rename amount as transaction_amount.
select transaction_id,amount as 'Transaction Amount', transaction_type from transactions;


-- 7	Display the 10 most recently opened accounts.
select * from accounts 
order by opening_date desc
limit 10;

-- 8 Retrieve all employees and calculate their annual salaries.
select *, salary*12 as 'Annual Salary' from employees;

-- 9 Find all customers belonging to the Premium segment.
select * from customers 
where customer_segment='Premium';

-- 10 Retrieve active savings accounts with balances greater than ₹50,000.
select * from accounts 
where balance>50000 
and 
account_status='active';