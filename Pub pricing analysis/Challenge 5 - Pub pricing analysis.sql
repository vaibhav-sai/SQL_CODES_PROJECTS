select * from sales_pub;
select * from pubs;
select * from ratings;
select * from beverages;

-- 1. How many pubs are located in each country?
select country , count(pub_id) as pub_counts 
from pubs
group by country;

-- 2. What is the total sales amount for each pub, including the beverage price and quantity sold ?
select p.pub_name, sum(b.price_per_unit * s.quantity) as total_sales_amount
from pubs as p
join sales_pub as s
on p.pub_id = s.pub_id
join beverages as b 
on b.beverage_id = s.beverage_id
group by p.pub_name;

-- 3. Which pub has the highest average rating?
select p.pub_name , round(avg(r.rating),2) as avg_rating from pubs as p
join ratings as r 
on p.pub_id = r.Pub_id
group by p.pub_name
order by avg_rating desc;

--4. What are the top 5 beverages by sales quantity across all pubs?
select top 5 b.beverage_name , sum(s.quantity) as total_quantity from
beverages as b
join sales_pub as s
on b.beverage_id = s.beverage_id
group by beverage_name
order by total_quantity desc;

-- 5. How many sales transactions occurred on each date?
select transaction_date , count(sale_id) as sales_count from sales_pub
group by transaction_date;

--6. Find the name of someone that had cocktails and which pub they had it in.
select p.pub_name , r.customer_name , b.category 
from sales_pub as s
join beverages as b 
on b.beverage_id = s.beverage_id
join pubs as p 
on p.pub_id = s.pub_id
join ratings as r
on r.pub_id = p.pub_id
where b.category = 'Cocktail'

-- 7. What is the average price per unit for each category of beverages, excluding the category 'Spirit'?
select category , round(avg(price_per_unit),2) as avg_per
from beverages
where category <> 'Spirit'
group by category
order by avg_per desc

-- 8. Which pubs have a rating higher than the average rating of all pubs?
select p.pub_name from pubs as p
join ratings as r
on p.pub_id = r.pub_id 
where r.rating > (select avg(rating) from ratings)

-- 9. What is the running total of sales amount for each pub, ordered by the transaction date?
with cte1 as (
select p.pub_name ,s.transaction_date, sum(s.quantity * b.price_per_unit)  as total_sales_amount
from sales_pub as s
join pubs as p
on p.pub_id = s.pub_id
join beverages as b 
on s.beverage_id = b.beverage_id
group by p.pub_name , s.transaction_date)
select * , sum(total_sales_amount) over(partition by pub_name order by transaction_date 
ROWS BETWEEN unbounded preceding AND CURRENT ROW) as running_total
from cte1;

-- 10. For each country, what is the average price per unit of beverages in each category, 
-- and what is the overall average price per unit of beverages across all categories?

SELECT
   country,
   category,
   round(AVG(price_per_unit), 2) AS avg_price 
FROM
   beverages b 
   JOIN
      sales_pub s 
      ON s.beverage_id = b.beverage_id 
   JOIN
      pubs p 
      ON p.pub_id = s.pub_id 
GROUP BY
   country,
   category;

-- 11. For each pub, what is the percentage contribution of each category of beverages
-- to the total sales amount, and what is the pub's overall sales amount?
WITH cte AS
(
   SELECT
      pub_name,
      SUM(quantity*price_per_unit) AS total_sales 
   FROM
      beverages b 
      JOIN
         sales_pub s 
         ON s.beverage_id = b.beverage_id 
      JOIN
         pubs p 
         ON p.pub_id = s.pub_id 
   GROUP BY
      pub_name
)
,
cte2 AS
(
   SELECT
      pub_name,
      category,
      SUM(quantity*price_per_unit) AS sales 
   FROM
      beverages b 
      JOIN
         sales_pub s 
         ON s.beverage_id = b.beverage_id 
      JOIN
         pubs p 
         ON p.pub_id = s.pub_id 
   GROUP BY
      pub_name,
      category
)
SELECT
   cte.pub_name,
   category,
   sales,
   total_sales,
   concat(round((sales / total_sales)*100, 2), '%') AS category_contribution 
FROM
   cte 
   JOIN
      cte2 
      ON cte.pub_name = cte2.pub_name 
ORDER BY
   cte.pub_name;