# Intermediate:
#1 Join the necessary tables to find the total quantity of each pizza category ordered.
#2 Determine the distribution of orders by hour of the day.
#3 Join relevant tables to find the category-wise distribution of pizzas.
#4 Group the orders by date and calculate the average number of pizzas ordered per day.
#5 Determine the top 3 most ordered pizza types based on revenue.

#1 Join the necessary tables to find the total quantity of each pizza category ordered.
select pt.category,count(od.order_id) as pizza_ordered,sum(od.quantity) as quantities
from pizza_types as pt
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join order_details as od
on p.pizza_id = od.pizza_id
group by pt.category
order by pizza_ordered desc;

#2 Determine the distribution of orders by hour of the day.
select hour(time) as hour_in_day , count(order_id) as orders_recived
from orders
group by hour(time);

#3 Join relevant tables to find the category-wise distribution of pizzas.
select category,count(name) as pizzas_distribution 
from pizza_types
group by category;

#4 Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(total_quantity),0) average_umber_of_pizzas_ordered_per_day from
(select o.date,sum(od.quantity) as total_quantity
from orders as o
join order_details as od
on o.order_id = od.order_id
group by o.date)  as order_quantity;

#5 Determine the top 3 most ordered pizza types based on revenue.

select pt.name,round(sum(p.price * od.quantity),2) as total_revenue 
from pizzas as p
join order_details as od
on p.pizza_id = od.pizza_id
join pizza_types as pt
on pt.pizza_type_id = p.pizza_type_id
group by pt.name
order by total_revenue desc
limit 3;