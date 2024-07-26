# Advanced:
#1 Calculate the percentage contribution of each pizza type to total revenue.
#2 Analyze the cumulative revenue generated over time.
#3 Determine the top 3 most ordered pizza types based on revenue for each pizza category.


#1 Calculate the percentage contribution of each pizza type to total revenue.

with percentage_contribution as (
SELECT 
    distinct pt.category,
    ROUND(SUM(p.price * od.quantity) OVER (PARTITION BY pt.category),1) AS total_revenue_individual,
    SUM(p.price * od.quantity) over(order by (select null)) AS total_revenue
FROM 
    pizzas AS p
JOIN 
    order_details AS od
    ON p.pizza_id = od.pizza_id
JOIN 
    pizza_types AS pt
    ON pt.pizza_type_id = p.pizza_type_id)
select category, round((total_revenue_individual/total_revenue) * 100 ,2) as percentage_contribution
from percentage_contribution;

#2 Analyze the cumulative revenue generated over time.
with revenue_per_date as (
select o.date,ROUND(SUM(p.price * od.quantity),2) as revenue_per_date
from pizzas as p
join order_details as od
ON p.pizza_id = od.pizza_id
join orders as o
on o.order_id = od.order_id
group by o.date)
select date,revenue_per_date,sum(revenue_per_date) over(order by date asc) as cumulative_revenue_per_date
from revenue_per_date;

#3 Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category,name,total_revenue from 
(select category,name,total_revenue, rank() over(partition by category order by total_revenue desc) as rnk 
from (
select pt.category,pt.name,round(sum(p.price * od.quantity),2) as total_revenue 
from pizzas as p
join order_details as od
on p.pizza_id = od.pizza_id
join pizza_types as pt
on pt.pizza_type_id = p.pizza_type_id
group by pt.category,pt.name) as a ) as b
where rnk < 3