-- Create the Customers table
select * from Customers
select * from  Branches
select * from Accounts
select * from Transactions

-- 1. What are the names of all the customers who live in New York?
select CONCAT(FirstName,' ',LastName) as full_name from customers
where state ='NY';

-- 2. What is the total number of accounts in the Accounts table?
select count(distinct AccountID) as Total_Accounts from accounts;

-- 3. What is the total balance of all checking accounts?
select sum(Balance) as Total_Balance_Available_In_Checking_Account from Accounts
where AccountType = 'Checking';

-- 4. What is the total balance of all accounts associated with customers who live in Los Angeles?
Select c.city,sum(a.balance) as total_Balance_For_Los_Angeles_Customers 
from Accounts as a
join customers as c
on a.customerid = c.customerid
where c.city = 'Los Angeles'
group by c.city;

-- 5. Which branch has the highest average account balance?
select b.branchName , avg(a.balance) as brach_balance
from Branches as b
join Accounts as a
on b.branchid = a.branchid
group by b.branchName;

-- 6. Which customer has the highest current balance in their accounts?
select top 1 CONCAT(c.FirstName,' ',c.LastName) as customer_name,sum(a.balance) as balance
from Customers as c
join Accounts as a
on c.customerID = a.CustomerID
where a.AccountType = 'checking'
group by c.FirstName,c.LastName
order by balance desc

-- 7. Which customer has made the most transactions in the Transactions table?
select CONCAT(c.FirstName,' ',c.LastName) as customer_name , count(t.transactionID) as transaction_count
from Transactions as t
join accounts as a
on t.accountID = a.accountId
join customers as c
on a.customerid = c.customerid
group by c.FirstName,c.LastName
order by transaction_count desc

-- 8.Which branch has the highest total balance across all of its accounts?
select top 1
b.branchName , sum(a.balance) as brach_balance
from Branches as b
join Accounts as a
on b.branchid = a.branchid
group by b.branchName
order by brach_balance desc

-- 9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts?
select top 1 CONCAT(c.FirstName,' ',c.LastName) as customer_name,sum(a.balance) as balance
from Customers as c
join Accounts as a
on c.customerID = a.CustomerID
group by c.FirstName,c.LastName,c.customerid
order by balance desc

-- 10. Which branch has the highest number of transactions in the Transactions table?

select top 1 b.branchname, count(t.transactionID) as transaction_count
from Transactions as t
join accounts as a
on t.accountID = a.accountId
join branches as b
on b.branchid = a.branchid
group by b.branchname
order by transaction_count desc