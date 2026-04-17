create database ShopManager;
use ShopManager; 

create table Categories (
   category_id int auto_increment primary key,
   category_name varchar(100) not null
);
create table products (
   product_id int auto_increment primary key ,
   product_name varchar(100) not null,
   price decimal(10,2) not null,
   stock int check (stock >= 0) not null,
   category_id int not null,
   foreign key (category_id) references categories (category_id)
);

insert into categories (category_name)
values ('Điện tử'),
       ('Thời trang');
insert into products (product_name,price,stock,category_id)
values ('iPhone 15',25000000,10,1),
       ('Samsung S23',20000000,5,1),
       ('Áo sơ mi nam',500000,50,2),
       ('Giày thể thao',1200000,20,2);
       
update products
set price = 26000000
where product_id = 1;

delete from products
where product_id = 4;
delete from products
where price < 1000000;

select product_id,product_name,price,stock,category_id
from products
where true;
select product_id,product_name,price,stock,category_id
from products
where stock > 15;
select product_id,product_name,price,stock,category_id
from products
where price >= 1000000 and price <=25000000; 
select product_id,product_name,price,stock,category_id
from products
where stock > 0 and product_name <> 'iPhone 15';
select product_id,product_name,price,stock,category_id
from products
where price >= 500000 and category_id <> 1;