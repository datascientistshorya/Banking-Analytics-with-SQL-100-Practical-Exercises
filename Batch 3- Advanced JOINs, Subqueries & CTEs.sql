-- Batch 3: Advanced JOINs, Subqueries & CTEs
/*Generate a report of customers and their bank accounts.

Requirements:
- Display customer ID, first name and last name.
- Display account ID, account type and account balance.
- Display branch ID.
- Include only customers who have at least one account.
- Sort by account balance in descending order.*/

select 
	c.customer_id,
	c.first_name,
    c.last_name,
    a.account_id,
    a.account_type,
    a.balance,
    a.branch_id
from customers c
inner join accounts a on 
c.customer_id=a.customer_id
order by a.balance desc;

/*Find all customers who do not have any associated bank accounts.

Requirements:
- Display customer ID.
- First name and last name.
- Email.
- Use LEFT JOIN instead of NOT EXISTS.
- Sort alphabetically by customer name.*/

select
	c.customer_id,
    c.first_name,
    c.last_name
from customers c  
left join accounts a  on
c.customer_id=a.customer_id
WHERE a.account_id IS NULL;

/*Generate a branch-wise banking performance report.

Requirements:
- Display branch ID.
- Display branch name.
- Calculate total number of accounts.
- Calculate total number of transactions.
- Calculate total transaction amount.
- Sort by total transaction amount in descending order.*/

select
	b.branch_id,
    b.branch_name,
    count(distinct a.account_id) as total_accounts,
    count(distinct t.transaction_id) as total_transactions,
    sum(t.amount) as total_transaction_amount
from branches b 
inner join accounts a 
on b.branch_id=a.branch_id
inner join transactions t
on a.account_id=t.account_id
group by b.branch_id,b.branch_name
order by total_transaction_amount desc;

/*Identify pairs of customers who belong to the same city.

Requirements:
- First customer ID and name.
- Second customer ID and name.
- Common city.
- Avoid matching a customer with themselves.
- Avoid duplicate customer pairs.*/

SELECT
    c1.customer_id AS customer1_id,
    c1.first_name AS customer1_first_name,
    c1.last_name AS customer1_last_name,

    c2.customer_id AS customer2_id,
    c2.first_name AS customer2_first_name,
    c2.last_name AS customer2_last_name,

    c1.city AS common_city

FROM customers c1
INNER JOIN customers c2
    ON c1.city = c2.city
WHERE c1.customer_id < c2.customer_id
ORDER BY common_city;

/*Find all bank accounts whose balance is greater than the average balance across all accounts.

Requirements:
- Display account ID.
- Customer ID.
- Branch ID.
- Account balance.
- Sort by account balance in descending order.
Use a scalar subquery to calculate the average balance.*/

select
	account_id,
    customer_id,
    branch_id,
    balance
from accounts
where balance>(
	select avg(balance) from accounts)
order by balance desc;

/*Find customers who have at least one account associated with a branch whose total transaction amount exceeds ₹10,00,000.

Requirements:
- Display customer ID.
- First name and last name.
- Email.
- Use an IN subquery.
- Avoid duplicate customers.*/

SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.last_name
FROM customers c
INNER JOIN accounts a
    ON c.customer_id = a.customer_id
WHERE a.branch_id IN (
    SELECT a2.branch_id
    FROM accounts a2
    INNER JOIN transactions t
        ON a2.account_id = t.account_id
    GROUP BY a2.branch_id
    HAVING SUM(t.amount) > 1000000
)
ORDER BY c.customer_id;

/*Find transactions whose amount is greater than the average transaction amount of their respective account.

Requirements:
- Display transaction ID.
- Display account ID.
- Display transaction amount.
- Display transaction date.
- Sort by account ID and transaction amount in descending order*/
select
	t1.transaction_id,
    t1.account_id,
    t1.amount,
    t1.transaction_date
from transactions t1
where t1.amount>(
	select avg(t2.amount)
    from transactions t2
    where t2.account_id=t1.account_id)
order by t1.account_id,t1.amount desc;

/*Identify bank accounts that have never recorded a transaction.

Requirements:
- Display account ID.
- Display customer ID.
- Display account type.
- Display account balance.
- Use NOT EXISTS.
- Sort by account ID.*/

SELECT
    a.account_id,
    a.customer_id,
    a.account_type,
    a.balance
FROM accounts a
WHERE NOT EXISTS (
    SELECT 1
    FROM transactions t
    WHERE t.account_id = a.account_id
)
ORDER BY a.account_id;

/*Using a Common Table Expression (CTE), generate a customer-level transaction summary.

Requirements:
- Display customer ID.
- Display first name and last name.
- Calculate total number of accounts.
- Calculate total number of transactions.
- Calculate total transaction amount.
- Calculate average transaction amount.*/

with customer_data as(
	select
		c.customer_id,
        c.first_name,
        c.last_name,
        count(distinct a.account_id) as total_accounts,
        count(distinct t.transaction_id) as total_transactions,
        avg(t.amount) as avg_transaction_amount
	from customers c 
    inner join accounts a 
		on c.customer_id=a.customer_id
	inner join transactions t 
		on t.account_id=a.account_id
	group by c.customer_id,c.first_name,c.last_name
) 
select * from customer_data;        
    

/*Create a customer performance report using multiple CTEs.

Classify customers based on their total transaction amount:
Total transaction amount	Classification
Below ₹50,000	Low Activity
₹50,000–₹2,00,000	Medium Activity
Above ₹2,00,000	High Activity

Requirements:
- Display customer ID and name.
- Display total transaction count.
- Display total transaction amount.
- Display average transaction amount.
- Display customer classification.
- Sort by total transaction amount in descending order.
- Use at least two CTEs.*/

select
	c.customer_id,
    c.first_name,
    c.last_name,
    count(distinct  t.transaction_id) as total_transactions,
    sum(t.amount) as total_transaction_amount,
    avg(t.amount) as avg_transaction_amount,
    case
		when sum(t.amount)< 50000 then 'Low Activity'
        when sum(t.amount)> 200000 then 'High Activity'
        else 'Medium Activity'
	end as activity_indicator
    from customers c 
    inner join accounts a 
		on c.customer_id=a.customer_id
	inner join transactions t 
		on a.account_id=t.account_id
group by c.customer_id,c.first_name,c.last_name;


-- with CTE
WITH customer_transactions AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        COUNT(DISTINCT t.transaction_id) AS total_transactions,
        SUM(t.amount) AS total_transaction_amount,
        AVG(t.amount) AS avg_transaction_amount
    FROM customers c
    INNER JOIN accounts a
        ON c.customer_id = a.customer_id
    INNER JOIN transactions t
        ON a.account_id = t.account_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
),

customer_classification AS (
    SELECT
        customer_id,
        first_name,
        last_name,
        total_transactions,
        total_transaction_amount,
        avg_transaction_amount,
        CASE
            WHEN total_transaction_amount < 50000
                THEN 'Low Activity'
            WHEN total_transaction_amount > 200000
                THEN 'High Activity'
            ELSE 'Medium Activity'
        END AS activity_indicator
    FROM customer_transactions
)

SELECT *
FROM customer_classification
ORDER BY total_transaction_amount DESC;
        