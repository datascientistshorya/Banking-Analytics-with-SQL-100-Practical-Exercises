-- Batch 2: Filtering, conditions and aggregations

/*11 Find all transactions where the transaction amount is between ₹10,000 and ₹1,00,000, inclusive.

Requirements:
- Display transaction ID, account ID, transaction amount and transaction date.
- Sort by transaction amount in descending order*/ 
select transaction_id, account_id, amount, transaction_date
from transactions
where amount between 10000 and 100000
order by amount desc;

/*12 Find all customers who hold accounts in any of the following branches:
- Branch ID 1
- Branch ID 3
- Branch ID 5
- Branch ID 7
Requirements:
- Display customer ID, customer name, account ID and branch ID.
- Avoid duplicate customer-account combinations.
- Sort by branch ID.*/
select * from customers 
where branch_id in (1,3,5,7)
order by branch_id;

/* 13 Find customers whose first name:
- Starts with 'A', OR
- Ends with 'n', OR
- Contains 'sh' (case-insensitive).
Requirements:
- Display customer ID, first name, last name and email.
- Sort alphabetically by first name.*/ 
select customer_id,first_name,last_name from customers
where first_name like 'A%'
or first_name like '%n'
or first_name like '%sh%';

/*14 Classify transactions into three categories based on transaction amount:
Transaction amount	Category
Below ₹5,000	Small
₹5,000–₹50,000	Medium
Above ₹50,000	Large

Requirements:
- Display transaction ID, account ID, transaction amount and transaction category.
- Sort by transaction amount in descending order.*/

select transaction_id,account_id,amount, 
case 
	when amount<5000 then 'small'
	when amount between 5000 and 50000 then 'medium'
	else 'large' end as transaction_category
from transactions
order by amount desc;

/*15 Find the number of customers associated with each branch.

Requirements:
- Display branch ID and customer count.
- Include only branches having at least one customer.
- Sort by customer count in descending order.*/

select branch_id, count(*) as customer_count
from customers
group by branch_id
order by customer_count desc;

/*16 Identify branches whose total transaction amount exceeds ₹10,00,000.

Requirements:
- Display branch ID, total transaction amount and transaction count.
- Sort by total transaction amount in descending order.*/

select a.branch_id,count(t.transaction_id) as total_transactions,sum(t.amount) as total_transaction_amount
from transactions t 
inner join accounts a on
t.account_id=a.account_id
group by a.branch_id
having total_transaction_amount>1000000
order by total_transaction_amount desc ;

/*17 Analyze the loans issued by the bank.

Calculate:
- Total number of loans.
- Total loan amount.
- Average loan amount.
- Maximum loan amount.
- Minimum loan amount.
Also calculate these metrics separately for each loan status.*/

select
	count(loan_id) as total_loans,
    sum(loan_amount) as total_loan_amount,
    avg(loan_amount) as avg_loan_amount,
    max(loan_amount) as max_loan_amount,
    min(loan_amount) as min_loan_amount
from loans;

select
	loan_status,
    count(loan_id) as total_loans,
    sum(loan_amount) as total_loan_amount,
    avg(loan_amount) as avg_loan_amount,
    max(loan_amount) as max_loan_amount,
    min(loan_amount) as min_loan_amount
from loans
group by loan_status;


/*18 Analyze accounts based on their account status.

Requirements:
- Display branch ID.
- Calculate the total number of accounts.
- Count active accounts.
- Count inactive accounts.
- Count closed accounts.
Display one row per branch.*/

select
	branch_id,
    count(account_id) as total_accounts,
    sum(case when account_status='Active' then 1 else 0 end) as Active_Accounts,
    sum(case when account_status='Closed' then 1 else 0 end) as Closed_Accounts,
	sum(case when account_status='Dormant' then 1 else 0 end) as Dormant_accounts
from accounts
group by branch_id;

/* 19 Analyze transaction activity month by month.

Requirements:
- Extract transaction year and month.
- Calculate total transaction count.
- Calculate total transaction amount.
- Calculate average transaction amount.
- Sort chronologically.*/

select 
	year(transaction_date) as t_year,
    month(transaction_date) as t_month,
    count(transaction_id) as total_transactions,
    sum(amount) as total_T_amount,
    avg(amount) as avg_T_amount
from transactions
group by t_year,t_month;

/*20 Identify customers who satisfy all the following conditions:
1. Have at least two bank accounts.
2. Have completed transactions worth more than ₹1,00,000 in total.
3. Have an average transaction amount greater than ₹10,000.
Requirements:
- Display customer ID and customer name.
- Display total number of accounts.
- Display transaction count.
- Display total transaction amount.
- Display average transaction amount.
- Sort by total transaction amount in descending order.*/

select c.customer_id,c.first_name,c.last_name, count(distinct a.account_id) as total_accounts,
count(t.transaction_id) as total_transactions,
sum(t.amount) as total_amount,
avg(t.amount) as avg_amount

from customers c 
inner join accounts a on 
c.customer_id=a.customer_id
inner join transactions t on
t.account_id=a.account_id
group by c.customer_id,c.first_name,c.last_name
having total_amount>100000
and avg_amount>10000
and COUNT(DISTINCT a.account_id) >= 2

order by total_amount desc;

/*Identify branches where:
- At least 100 transactions have occurred.
- The average transaction amount exceeds ₹15,000.
Requirements:
- Display branch ID.
- Display transaction count.
- Display total transaction amount.
- Display average transaction amount.
- Sort by average transaction amount in descending order.*/
select a.branch_id, count(t.transaction_id) as No_of_transactions,
sum(t.amount) as total_T_Amount,
avg(t.amount) as avg_T_amount
from accounts a 
inner join transactions t on
t.account_id=a.account_id
group by a.branch_id
having No_of_transactions>100
and avg_T_amount>15000
order by avg_T_amount desc ;

/*Find customers who do not currently have any bank accounts.

Requirements:
- Display customer ID.
- Display first name and last name.
- Display email.
- Use NOT EXISTS rather than NOT IN.
- Sort alphabetically by first name.*/

SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM accounts a
    WHERE a.customer_id = c.customer_id
)
ORDER BY c.first_name ASC;