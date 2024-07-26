use pizza_sales;

create table orders (
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id));


create table order_details (
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_details_id));

CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    ingredients TEXT
);

CREATE TABLE pizzas (
    pizza_id VARCHAR(50) PRIMARY KEY,
    pizza_type_id VARCHAR(50),
    size CHAR(1),
    price DECIMAL(5, 2),
    FOREIGN KEY (pizza_type_id) REFERENCES pizza_types(pizza_type_id)
);
