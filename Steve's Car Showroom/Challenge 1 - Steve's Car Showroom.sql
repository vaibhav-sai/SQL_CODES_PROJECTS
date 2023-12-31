select * from cars;

select * from sales;

select * from salespersons;

-- 1. What are the details of all cars purchased in the year 2022?

select c.*,s.purchase_date from cars as c
join sales as s
on c.car_id = s.car_id
where year(s.purchase_date) = '2022' 
order by s.purchase_date desc

-- 2. What is the total number of cars sold by each salesperson?
select sp.name,count(s.sale_id) as cars_sold from sales as s
join salespersons as sp
on s.salesman_id = sp.salesman_id
group by sp.name
order by cars_sold desc

-- 3. What is the total revenue generated by each salesperson?
select sp.name , sum(c.cost_$) as revenue_generated
from salespersons as sp
join sales as s
on sp.salesman_id = s.salesman_id
join cars as c 
on c.car_id = s.car_id
group by sp.name
order by revenue_generated desc;


-- 4. What are the details of the cars sold by each salesperson?

select sp.name,c.*
from salespersons as sp
join sales as s
on sp.salesman_id = s.salesman_id
join cars as c 
on c.car_id = s.car_id;


-- 5. What is the total revenue generated by each car type?
select c.type , sum(c.cost_$) as revenue_generated
from cars as c
join sales as s
on c.car_id = s.car_id
group by c.type
order by revenue_generated desc

-- 6. What are the details of the cars sold in the year 2021 by salesperson 'Emily Wong'?
select sp.name,c.* from salespersons as sp
join sales as s
on sp.salesman_id = s.salesman_id
join cars as c
on s.car_id = c.car_id
where  year(s.purchase_date) = '2021' and sp.name = 'Emily Wong';

-- 7. What is the total revenue generated by the sales of hatchback cars?
select c.style,sum(c.cost_$) as revenue_generated from cars as c
join sales as s
on c.car_id = s.car_id 
where c.style = 'Hatchback'
group by c.style

-- 8. What is the total revenue generated by the sales of SUV cars in the year 2022?
select c.style,sum(c.cost_$) as revenue_generated from cars as c
join sales as s
on c.car_id = s.car_id 
where c.style = 'SUV' and year(s.purchase_date) = '2022'
group by c.style

-- 9. What is the name and city of the salesperson who sold the most number of cars in the year 2023?
select top 1 sp.name,sp.city, count(s.sale_id) as cars_sold
from salespersons as sp
join sales as s
on sp.salesman_id = s.salesman_id
group by sp.name,sp.city
order by cars_sold desc

-- 10. What is the name and age of the salesperson who generated the highest revenue in the year 2022?
select top 1 sp.name,sp.age , sum(c.cost_$) as revenue_generated 
from salespersons as sp
join sales as s
on sp.salesman_id = s.salesman_id 
join cars as c 
on c.car_id = s.car_id
where year(s.purchase_date) = '2022'
group by sp.name,sp.age
order by revenue_generated desc