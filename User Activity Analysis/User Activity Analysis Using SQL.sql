select * from users;

select * from logins;

--consider Today's date is 28-june-2024
--1. Management wants to see all the users that did not login in the past 5 months 
--return: username.
-- 5 month's back date will be 28-01-2024

-- Soultion 1
select user_id , max(login_timestamp) as latest_login 
from logins 
group by user_id
having max(login_timestamp) < DATEADD(month,-5,'2024-06-28');

-- Solution 2
select distinct user_id from logins where user_id not in 
(select user_id from logins
where login_timestamp > DATEADD(month,-5,'2024-06-28'))

--2. For the business units' quarterly analysis, calculate how many users and 
--how many sessions were at each quarter order by quarter from newest to oldest.
--Return: first day of the quarter, user_cnt, session_cnt.

with cte1 as (
select DATEPART(quarter,login_timestamp) as QTR,DATEPART(year,login_timestamp) as [year],
count(user_id)  as user_cnt,count(session_id) as session_cnt , 
min(login_timestamp) as QTR_First_Login,
FORMAT(DATEADD(month, DATEDIFF(month, 0, min(login_timestamp)), 0), 'dd-MM-yyyy') AS first_day_of_month
from logins
group by DATEPART(quarter,login_timestamp),DATEPART(year,login_timestamp))
select first_day_of_month,[year],QTR,user_cnt,session_cnt
from cte1;

--3. Display user id's that Log-in in January 2024 and did not Log-in on November 2023.
--Return: User_id


select distinct user_id from logins
where login_timestamp between '2024-01-01' and '2024-01-31'
and user_id not in (
select user_id from logins
where login_timestamp between '2023-11-01' and '2023-11-30');


--4. Add to the query from Q2 the percentage change in sessions from last quarter. 
--Return: first day of the quarter, session_cnt, session_cnt_prev, Session_percent_change.
with cte1 as (
select DATEPART(quarter,login_timestamp) as QTR,DATEPART(year,login_timestamp) as [year],
count(user_id)  as user_cnt,count(session_id) as session_cnt ,
FORMAT(DATEADD(month, DATEDIFF(month, 0, min(login_timestamp)), 0), 'dd-MM-yyyy') 
AS first_day_of_month
from logins
group by DATEPART(quarter,login_timestamp),DATEPART(year,login_timestamp))
select first_day_of_month,[year],QTR,session_cnt,lag(session_cnt,1,0) over(order by [year],QTR,first_day_of_month)
as session_cnt_prev,
round(((session_cnt-lag(session_cnt,1) over(order by [year],QTR,first_day_of_month))*1.0
/lag(session_cnt,1) over(order by [year],QTR,first_day_of_month)*1.0 )*100,2) as Session_percent_change
from cte1;

--5. Display the user that had the highest session score (max) for each day 
--Return: Date, username, score

with cte1 as (
select cast(login_timestamp as date) as [date]  ,
[user_id] , sum(session_score) as highest_session_score
from logins
group by [user_id],cast(login_timestamp as date))
select [user_id],[date],highest_session_score from (
select * , ROW_NUMBER() over(partition by [date]order by highest_session_score desc) as rn
from cte1) as a
where rn = 1;

--6. To identify our best users Return the users that had a session on every single day since their first login 
--(make assumptions if needed).
--Return: User_id
-- Today's date is 2024-06-28
with cte1 as (
select user_id,min(cast(login_timestamp as date)) as first_login,
DATEDIFF(day,min(cast(login_timestamp as date)),'2024-06-28')+1 as no_of_logins_required,
count(distinct cast(login_timestamp as date)) as no_of_login_days
from logins
group by USER_ID)
select user_id
from cte1
where no_of_logins_required = no_of_login_days;

--7. On what dates there were no Log-in at all?
--Return: Login_dates

with cte1 as (
select min(cast(login_timestamp as date)) as first_login,
min(cast(login_timestamp as date)) as next_date,
max(cast(login_timestamp as date)) as last_login from logins
union all
select first_login,DATEADD(day,1,next_date) as next_date,last_login
from cte1
where DATEADD(day,1,next_date) <=last_login)
select next_date as no_login_date from cte1
where next_date not in (select distinct cast(login_timestamp as date) from logins)
OPTION (MAXRECURSION 0);
