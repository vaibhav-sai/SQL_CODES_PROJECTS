# Basic:
# 1) Retrieve the total number of orders placed.
# 2) Calculate the total revenue generated from pizza sales.
# 3) Identify the highest-priced pizza.
# 4) Identify the most common pizza size ordered.
# 5) List the top 5 most ordered pizza types along with their quantities.

# 1) Retrieve the total number of orders placed.
select count(order_id) as Total_Orders from orders;

# 2) Calculate the total revenue generated from pizza sales.
select round(sum(od.quantity*pd.price),2) as Total_Revenue from 
order_details as od 
join pizzas as pd
on od.pizza_id = pd.pizza_id;

# 3) Identify the highest-priced pizza.
select pt.name,p.size,p.price from 
pizza_types as pt 
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
order by p.price desc;

# 4) Identify the most common pizza size ordered.
select pd.size , count(od.pizza_id) as ordered_times from 
pizzas as pd
left join order_details as od
on pd.pizza_id = od.pizza_id
group by pd.size
order by ordered_times desc;

# 5) List the top 5 most ordered pizza types along with their quantities.
select pt.name,count(od.order_id) as pizza_ordered,sum(od.quantity) as quantities
from pizza_types as pt
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join order_details as od
on p.pizza_id = od.pizza_id
group by pt.name
order by pizza_ordered desc
limit 5;