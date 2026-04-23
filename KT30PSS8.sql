create database BOOKSTOREDB;
use BOOKSTOREDB;

create table category (
   category_id int PRIMARY KEY auto_increment,
   category_name varchar(100) not null,
   description VARCHAR(255) 
);
create table book (
   book_id int primary key auto_increment,
   title varchar(150) not null,
   status int default 1,
   publish_date date,
   price decimal(10,2) check (price >= 0 ),
   category_id int not null,
   foreign key (category_id) references category (category_id)
);
create table bookorder (
   order_id int primary key auto_increment,
   customer_name varchar(100) not null,
   book_id int ,
   order_date date default(current_date()),
   delivery_date date,
   foreign key (book_id) references book (book_id) on delete cascade
);

alter table book
add author_name varchar(100) not null;

alter table bookorder 
modify customer_name varchar(200) not null;

insert into category (category_name,description)
values ('IT & Tech','Sách lập trình'),
       ('Business','Sách kinh doanh'),
       ('Novel','Tiểu thuyết');
insert into book (title,status,publish_date,price,category_id,author_name)
values ('Clean Code',1,'2020-05-10',500000,1,'Robert C.Martin'),
       ('Đắc Nhân Tâm',0,'2018-08-20',150000,2,'Dale Carnegie'),
       ('JavaScript Nâng Cao',1,'2023-01-15',350000,1,'Kyle Simpson'),
       ('Nhà Giả Kim',0,'2015-11-25',120000,3,'Paulo Coelho');
insert into bookorder (customer_name,book_id,order_date,delivery_date)
values ('Nguyen Hai Nam',1,'2025-01-10 ','2025-01-15 '),
       ('Tran Bao Ngoc',3,'2025-02-05 ','2025-02-10 '),
       ('Le Hoang Yen',3,'2025-03-11 ',null);
       
update book 
set price = 50000
where category_id = 1;

update bookorder 
set delivery_date = '2025-12-31 '
where delivery_date is null;

delete from bookorder 
where order_date < '2025-02-01';

select title,
	   author_name,
       case
           when status = 1 then 'Còn hàng'
           when status = 0 then 'Hết hàng'
		end as status_name 
from book;

select upper(title) as title_upper,
       (round((current_date() - publish_date)/24/365)) as 'Năm xuất bản đến nay'
from book;

select title,price,category_name 
from book b
inner join category c
on b.category_id = c.category_id;

select title,price
from book 
order by price desc 
limit 2;

select category_name
from category
group by (select category_id 
from book)
having count(book_id) > 2 ;