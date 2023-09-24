-- DATA ANALYSIS
-- total no. of pizzas ordered

select count(order_id) from customer_orders;
-- 14 pizzas are ordered.

-- total no. of pizzas ordered each day 
select DATEPART(day,order_time) as each_day,count(*) as pizzas_ordered from customer_orders
group by DATEPART(day,order_time);

-- # total no. of pizzas ordered each hour in a day
select DATEPART(HOUR,order_time) as each_Hour,count(*) as pizzas_ordered from customer_orders
group by DATEPART(HOUR,order_time);

--# total no. of pizzas ordered by each customer

select customer_id,count(*) as total_orders from customer_orders
group by customer_id
order by total_orders desc;

-- # How many unique customer orders were made?
select pizza_id,count(*) as unique_pizza from customer_orders
group by pizza_id;

-- # How many successful orders were delivered ?
select count(*) as successful_orders from runner_orders
where cancellation is null;

--	# # How many successful orders were delivered by each runner ?
select runner_id,count(*) as successful_orders from runner_orders
where cancellation is null
group by runner_id;

-- # how many orders got cancelled for each runner ?
select runner_id,count(*) as successful_orders from runner_orders
where cancellation is not null
group by runner_id;

-- # average time each runner takes to deliver the order ?

select runner_id,round(avg(cast(duration as float)),2) as avg_time from runner_orders
group by runner_id;

-- # How many of each type of pizza was delivered?

select a.pizza_id,count(a.pizza_id) as pizza_delivered from customer_orders as a
join runner_orders as b
on a.order_id = b.order_id
where b.cancellation is null
group by a.pizza_id;

-- # How many Vegetarian and Meatlovers were ordered by each customer?
select customer_id,pizza_id,count(pizza_id) as pizza_count from customer_orders
group by customer_id,pizza_id;


-- # How many pizzas delivered in a single order ?
select order_id,count(order_id) as order_delivered from customer_orders
group by order_id;

-- #What was the maximum number of pizzas delivered in a single order?
select top(1) order_id,count(order_id) as order_delivered from customer_orders
group by order_id
order by order_delivered desc;

--#  how many pizzas had at least 1 change ?

select count(order_id) as changes_in_pizza from customer_orders
where exclusions is not null or extras is not null;

-- # For each customer, how many pizzas had at least 1 change ?
select customer_id,count(order_id) as changes_in_pizza from customer_orders
where exclusions is not null or extras is not null
group by customer_id;

-- # For each customer, how many pizzas had at least 1 change and how many had no changes?
select customer_id,
sum(case when exclusions is not null or extras is not null then 1 else 0 end) as changes_in_pizza,
sum(case when exclusions is null AND extras is null then 1 else 0 end) as no_changes_in_pizza
from customer_orders as a
join runner_orders as b
on a.order_id=b.order_id
WHERE cancellation IS NULL
GROUP BY customer_id
ORDER BY customer_id;

-- # How many pizzas were delivered that had both exclusions and extras?
select count(*) as changes_in_pizza from customer_orders as a
join runner_orders as b
on a.order_id=b.order_id
where exclusions is not null and extras is not null and cancellation IS NULL
GROUP BY customer_id
ORDER BY customer_id;

-- # What was the total quantity of pizzas ordered for each hour of each day?

select DATEPART(day,order_time) as each_day,DATEPART(HOUR,order_time) as each_hour,count(order_id) as pizzas_ordered from customer_orders
group by DATEPART(day,order_time),DATEPART(HOUR,order_time);

--# What was the volume of orders for each date of the week?
select count(*) as orders,datepart(DAY,order_time) as each_date
from customer_orders_temp
group by datepart(DAY,order_time) ;

--# What was the volume of orders for each day of the week?
select count(*) as orders,DATENAME(weekday,order_time) as each_date
from customer_orders_temp
group by DATENAME(weekday,order_time) ;

--# What was the volume of orders for each day of each week?
select count(*) ,DATENAME(weekday,order_time) as each_date ,DATEPART(WEEK,order_time) as each_week
from customer_orders_temp
group by DATENAME(weekday,order_time), DATEPART(WEEK,order_time) ;

----------------------------------------------------------------------------------------------------------------------
select * from customer_orders;

select * into customer_orders_cleaned_temp from
(
SELECT 
    order_id,
    customer_id,
    pizza_id,
    exclusions_list.value AS exclusions,
    extras_list.value AS extras,
    order_time
FROM CUSTOMER_ORDERS
CROSS APPLY STRING_SPLIT(CAST(exclusions AS VARCHAR), ',') AS exclusions_list
CROSS APPLY STRING_SPLIT(CAST(extras AS VARCHAR), ',') AS extras_list) as a



select * from customer_orders_cleaned_temp;

--# What was the most commonly added extra?

select * from customer_orders_cleaned_temp;

select * from pizza_toppings;

select top(1) a.topping_name,count(b.extras) as toppings_count from pizza_toppings as a
join customer_orders_cleaned_temp as b
on a.topping_id=cast(b.extras as int)
group by a.topping_name


-- # What was the least commonly added extra?
select top(1) a.topping_name,count(b.extras) as toppings_count from pizza_toppings as a
join customer_orders_cleaned_temp as b
on a.topping_id=cast(b.extras as int)
group by a.topping_name
order by toppings_count

-- # What was the most common exclusion?
select a.topping_name,count(b.exclusions) as toppings_count from pizza_toppings as a
join customer_orders_cleaned_temp as b
on a.topping_id=cast(b.exclusions as int)
group by a.topping_name


-- # If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes -
-- # how much money has Pizza Runner made so far if there are no delivery fees?

select * from customer_orders;
select * from runner_orders;
select * from pizza_names;

select runner_id,
sum(case when pizza_id = 1 then 12
when pizza_id = 2 then 10 end) as total_amount
from customer_orders as a
join runner_orders as b
on a.order_id = b.order_id
where b.cancellation is null
group by runner_id


-- # How many runners signed up and in which week? (i.e. week starts 2021-01-01)

select runner_id,DATEPART(week,registration_date) as week_number from runners;

-- # What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
select * from runner_orders
select * from customer_orders

WITH runner_pickup AS (
    SELECT 
        order_id,
        runner_id,cancellation,
        DATEPART(MINUTE, pickup_time) AS pickup_minute
    FROM runner_orders
),order_time as (
select order_id,DATEPART(MINUTE,order_time) as order_time
from customer_orders)
select a.runner_id,avg(a.pickup_minute - b.order_time) as avgtime_min from 
runner_pickup as a
join order_time as b
on a.order_id = b.order_id
where a.cancellation is null
group by a.runner_id


-- # What was the average distance travelled for each customer?

select * from customer_orders
select * from runner_orders

select a.customer_id,round(avg(cast(b.distance as float)) ,2)from customer_orders as a
join runner_orders as b 
on a.order_id = b.order_id
group by a.customer_id;

-- # Is there any relationship between the number of pizzas and how long the order takes to prepare?
WITH runner_pickup AS (
    SELECT 
        order_id,
        runner_id,cancellation,
        DATEPART(MINUTE, cast(pickup_time as datetime)) AS pickup_minute
    FROM runner_orders
),order_time as (
select order_id,DATEPART(MINUTE,order_time) as order_time
from customer_orders)
select a.order_id,(a.pickup_minute - b.order_time) as time_taken_to_make_Pizza from 
runner_pickup as a
join order_time as b
on a.order_id = b.order_id
where a.cancellation is null


-- # What was the longest and shortest delivery times for all orders?
select max(cast(duration as int)) as longest_delivery_time, min(cast(duration as int)) as shortest_delivery_time
from runner_orders;

--# what is average speed of each runner
with cte1 as(select *,(duration / 60) as 'duration_in_hrs' from runner_orders_temp) 
select runner_id, avg(distance/duration_in_hrs) as avg_speed from cte1
group by runner_id ;

--# What was the average speed for each runner for each delivery and do you notice any trend for these values?
with cte1 as(select *,(duration / 60) as 'duration_in_hrs' from runner_orders_temp) 
select *, avg(distance/duration_in_hrs) as avg_speed from cte1
group by runner_id , order_id ;

--# What is the successful delivery percentage for each runner?
select runner_id, (count(pickup_time) / count(order_id) * 100) as delivery_perc
from runner_orders_temp
group by runner_id ;