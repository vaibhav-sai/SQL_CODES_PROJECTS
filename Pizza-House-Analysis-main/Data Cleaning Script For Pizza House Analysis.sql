-- Data Cleaning 

-- CUSTOMER_ORDERS Table Cleaning 

select * from CUSTOMER_ORDERS;

-- create TEMPORARY table 

SELECT *
INTO CUSTOMER_ORDERS_TEMP
FROM CUSTOMER_ORDERS;

-- View the Temporary Table
select * from CUSTOMER_ORDERS_TEMP;

-- Data celeaning here i am replacing '','null' to NULL in exclusions,extras column
select order_id,customer_id,pizza_id,
case when exclusions = 'null' then NULL
when exclusions='' then NULL 
else 
exclusions end as exclusions,
case when extras = 'null' then NULL
when extras='' then NULL 
else 
extras end as extras
from CUSTOMER_ORDERS_TEMP;

-- Truncated the existing column 
truncate table CUSTOMER_ORDERS

-- added the cleaned data in the existing table 
INSERT INTO CUSTOMER_ORDERS (order_id, customer_id, pizza_id, exclusions, extras,order_time)
SELECT order_id, customer_id, pizza_id,
       CASE WHEN exclusions = 'null' OR exclusions = '' THEN NULL ELSE exclusions END AS exclusions,
       CASE WHEN extras = 'null' OR extras = '' THEN NULL ELSE extras END AS extras,order_time
FROM CUSTOMER_ORDERS_TEMP;

-- view the original/existing table 
select * from CUSTOMER_ORDERS;


-- Data Cleaning 
-- RUNNER_ORDERS Table cleaning 

select * from RUNNER_ORDERS;

-- Tempory table creation 

select * into RUNNER_ORDERS_TEMP
from RUNNER_ORDERS;

-- View the Temp Table 
select * from RUNNER_ORDERS_TEMP

-- Data Cleaning 

select order_id,runner_id,
(case when pickup_time='null' then NULL
else cast(pickup_time as DATETIME) end) as pickup_time,
(case when distance = 'null' then NULL
else cast(replace(LTRIM(RTRIM(distance)),'km','') as FLOAT)
end )as distance,
(case when duration = 'null' then NULL
else cast(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(duration)), 'minutes', ''), 'mins', ''),'minute','') as float)
end) as duration,
(case when cancellation ='' then NULL 
when cancellation = 'null' then NULL
else cancellation end) as cancellation
from RUNNER_ORDERS_TEMP

-- Truncate existing table 
truncate table runner_orders;


-- insert data from temp table to existing table
INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
select order_id,runner_id,
(case when pickup_time='null' then NULL
else cast(pickup_time as DATETIME) end) as pickup_time,
(case when distance = 'null' then NULL
else cast(replace(LTRIM(RTRIM(distance)),'km','') as FLOAT)
end )as distance,
(case when duration = 'null' then NULL
else cast(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(duration)), 'minutes', ''), 'mins', ''),'minute','') as float)
end) as duration,
(case when cancellation ='' then NULL 
when cancellation = 'null' then NULL
else cancellation end) as cancellation
from RUNNER_ORDERS_TEMP;

-- view data from runner_orders
select * from runner_orders;


-- Data Cleaning on pizza_recipes

select * from pizza_recipes;

-- Tempory table creation 

select * into pizza_recipes_Temp
from pizza_recipes;

-- Data Cleaning in Temp Table 
select pizza_id,value as toppings from pizza_recipes_Temp
cross apply STRING_SPLIT(cast(toppings as VARCHAR),',') as toppings_list

-- Truncate existing table 
truncate table pizza_recipes;

-- insert data into pizza_recipes from Temp Table 
INSERT INTO pizza_recipes
  (pizza_id, toppings)
select pizza_id,value as toppings from pizza_recipes_Temp
cross apply STRING_SPLIT(cast(toppings as VARCHAR),',') as toppings_list

-- View data of pizza_recipes

select * from pizza_recipes;