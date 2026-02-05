create database e_commerce_retail;

use e_commerce_retail;

CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(50),
    gender VARCHAR(5),
    signup_date DATE,
    city VARCHAR(30)
);

CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30),
    cost_price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    order_date DATE,
    order_status VARCHAR(20),
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id VARCHAR(10) PRIMARY KEY,
    order_id VARCHAR(10),
    product_id VARCHAR(10),
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers VALUES
('C001','Rahul Sharma','M','2024-01-10','Delhi'),
('C002','Priya Singh','F','2024-02-12','Mumbai'),
('C003','Amit Verma','M','2024-03-05','Bangalore'),
('C004','Sneha Patel','F','2024-01-25','Ahmedabad'),
('C005','Rohit Gupta','M','2024-04-01','Delhi'),
('C006','Anjali Mehta','F','2024-05-11','Pune'),
('C007','Vikas Khanna','M','2024-02-19','Chandigarh'),
('C008','Neha Joshi','F','2024-03-29','Jaipur'),
('C009','Arjun Nair','M','2024-06-15','Kochi'),
('C010','Kavya Iyer','F','2024-04-18','Chennai'),
('C011','Suresh Rao','M','2024-01-30','Hyderabad'),
('C012','Pooja Malhotra','F','2024-02-08','Delhi'),
('C013','Manish Kapoor','M','2024-05-20','Mumbai'),
('C014','Divya Bansal','F','2024-06-05','Noida'),
('C015','Nitin Arora','M','2024-03-11','Gurgaon');


INSERT INTO products VALUES
('P101','iPhone 14','Electronics',60000),
('P102','Samsung TV','Electronics',35000),
('P103','Bluetooth Speaker','Accessories',2500),
('P104','Laptop Dell','Electronics',55000),
('P105','Air Fryer','Home',8000),
('P106','Smart Watch','Accessories',5000),
('P107','Microwave Oven','Home',15000),
('P108','Headphones','Accessories',3000),
('P109','Refrigerator','Home',40000),
('P110','Tablet','Electronics',25000);

INSERT INTO orders VALUES
('O1001','C001','2024-06-01','Delivered',78000),
('O1002','C002','2024-06-05','Delivered',42000),
('O1003','C003','2024-06-12','Delivered',3000),
('O1004','C001','2024-07-01','Delivered',65000),
('O1005','C004','2024-07-04','Cancelled',12000),
('O1006','C005','2024-07-10','Delivered',90000),
('O1007','C006','2024-07-15','Delivered',18000),
('O1008','C002','2024-08-01','Delivered',32000),
('O1009','C007','2024-08-04','Delivered',45000),
('O1010','C008','2024-08-10','Delivered',10000),
('O1011','C009','2024-08-15','Delivered',85000),
('O1012','C010','2024-09-01','Delivered',27000),
('O1013','C011','2024-09-07','Delivered',40000),
('O1014','C012','2024-09-15','Delivered',15000),
('O1015','C013','2024-10-01','Delivered',62000),
('O1016','C014','2024-10-10','Delivered',9000),
('O1017','C015','2024-10-15','Delivered',52000),
('O1018','C003','2024-11-01','Delivered',30000),
('O1019','C001','2024-11-10','Delivered',15000),
('O1020','C006','2024-11-20','Delivered',45000);


INSERT INTO order_items VALUES
('IT45','O1001','P101',1,78000),
('IT12','O1002','P102',1,42000),
('IT88','O1003','P103',1,3000),
('IT09','O1004','P104',1,65000),
('IT71','O1005','P105',1,12000),
('IT33','O1006','P109',1,90000),
('IT60','O1007','P106',2,9000),
('IT22','O1008','P110',1,32000),
('IT91','O1009','P102',1,45000),
('IT04','O1010','P108',2,5000),
('IT57','O1011','P109',1,85000),
('IT19','O1012','P110',1,27000),
('IT83','O1013','P102',1,40000),
('IT67','O1014','P105',1,15000),
('IT50','O1015','P104',1,62000),
('IT29','O1016','P103',3,3000),
('IT76','O1017','P101',1,52000),
('IT05','O1018','P110',1,30000),
('IT94','O1019','P108',3,5000),
('IT11','O1020','P107',1,45000),
('IT39','O1020','P106',1,0),
('IT62','O1006','P108',2,6000),
('IT08','O1001','P103',2,6000),
('IT70','O1015','P106',1,0),
('IT48','O1004','P108',1,0),
('IT97','O1011','P103',1,0),
('IT21','O1017','P103',2,6000),
('IT66','O1002','P106',1,0),
('IT14','O1009','P108',1,0),
('IT36','O1013','P103',2,6000),
('IT80','O1012','P106',1,0),
('IT58','O1018','P108',2,6000),
('IT06','O1014','P103',1,0),
('IT44','O1010','P106',1,0);




select * from order_items;

select * from orders;

select * from customers;

select * from products;

/*1. Monthly Revenue Trend + Running Total
How does revenue change month-over-month, and what is the cumulative revenue?
*/


with cte as(select year(order_date) as years, month(order_date) as months, sum(total_amount) as revenue 
from orders where order_status="Delivered" group by years, months),

trend as (select years, months, revenue, lag(revenue) over (order by years, months) as prev_rev, 
sum(revenue) over(order by years, months) as cum_rev
from cte) 

select years, months, revenue, round((revenue-prev_rev)/prev_rev,2) as MOM_Change, cum_rev from trend;

/*
2. Top 3 Products Per Category (Window Function)
Which are the top 3 revenue-generating products in each category?

*/
with cte as (select prd.category as categories, prd.product_name as products, sum((orditm.quantity*orditm.price)) as total_value
from products prd join order_items orditm on prd.product_id = orditm.product_id 
join orders ord on ord.order_id = orditm.order_id where order_status = "Delivered"
group by categories, products),

top_products as (select categories, products, total_value,
dense_rank() over (partition by categories order by total_value desc) as ranks from cte)

select categories, products, total_value from top_products where ranks<=3;

/*
3. Customer Lifetime Value Ranking
Rank customers based on total lifetime spend.
*/

select cust.customer_id customer_id, cust.customer_name customer_names, sum(ord.total_amount) as total_spend, 
rank() over (order by sum(ord.total_amount) desc) as ranks
from customers cust
join orders ord on cust.customer_id = ord.customer_id 
where order_status="Delivered" 
group by cust.customer_id, cust.customer_name order by ranks;

/*
4. Customer Segmentation (High / Medium / Low)
Segment customers based on total spend.
*/
select ord.customer_id, cust.customer_name, sum(total_amount) as Total_Value,
case
	when sum(total_amount)>50000 then "High Value"
	when sum(total_amount)>20000 and sum(total_amount)<50000 then "Medium Value" 
	when sum(total_amount)<20000 then "Low Value"
	else "No value"
End as Segment
from customers cust
join orders ord on cust.customer_id = ord.customer_id group by ord.customer_id;


/*
5. Churn Detection
Identify customers inactive for 90+ days.
*/

select cust.customer_id, MAX(ord.order_date) as last_order_date from customers cust
join orders ord on cust.customer_id = ord.customer_id 
group by cust.customer_id having DATEDIFF(CURDATE(), max(ord.order_date))>90;

/*
6. Repeat Customer Percentage
What percentage of customers are repeat buyers?
*/

with cte as (select cust.customer_id, count(ord.order_id) as num_orders from customers cust join
orders ord on cust.customer_id = ord.customer_id group by cust.customer_id having num_orders>1)


select round((select count(*) from cte)*100/(select count(distinct(customer_id)) from orders),2) as repeat_cust_percent;

/*
7. Product Profitability Analysis
Which products generate the highest profit?
*/
select prd.product_id, prd.product_name, sum(ord_itm.quantity * ord_itm.price)-sum(ord_itm.quantity * prd.cost_price) as profit
from products prd join order_items ord_itm on prd.product_id = ord_itm.product_id 
join orders ord on ord_itm.order_id = ord.order_id where order_status="Delivered"
group by prd.product_id, prd.product_name order by profit desc;


/*
8. City Revenue Contribution %
Which cities contribute most to revenue?
*/



select cust.city, sum(ord.total_amount) as total_contributions,
concat(round(sum(ord.total_amount)/(select sum(total_amount) from orders)*100,2),"%") as contributions  
from customers cust join orders ord 
on cust.customer_id = ord.customer_id where order_status = "Delivered" group by cust.city 
order by total_contributions desc limit 5;

/*
9. Average Order Value by Customer Segment
What is the average order value across High / Medium / Low segments?
*/



with customer_segments as (select cust.customer_id, round(sum(ord.total_amount),2) as total_order_amount,
Case 
	when sum(ord.total_amount)<=15000 then "Low Segment"
    when sum(ord.total_amount)<=40000 then "Medium Segment"
	when sum(ord.total_amount)>40000 then "High Segment"
else "Wrong Amount"
end as customer_segment
from customers cust
join orders ord on cust.customer_id = ord.customer_id where ord.order_status="Delivered" group by cust.customer_id)

select cs.customer_segment, round(avg(ord.total_amount),2) as avg_order_val from customer_segments cs
join orders ord on ord.customer_id = cs.customer_id
group by cs.customer_segment
order by avg_order_val desc;    


 



