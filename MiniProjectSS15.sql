create database StudentManagement;
use StudentManagement;

create table students (
   student_id varchar(5) primary key,
   full_name varchar(50) not null,
   total_debt decimal(10,2) default 0
);
create table subjects (
   subject_id varchar(5) primary key,
   subject_name varchar(50) not null,
   credits int check (credits > 0)
);
create table gardes (
   student_id varchar(5) not null,
   subject_id varchar(5) not null,
   score decimal(4,2) check (score between 0 and 10),
   foreign key (student_id) references students (student_id),
   foreign key (subject_id) references subjects (subject_id),
   primary key (student_id,subject_id)
); 
create table grade_log (
   log_id int primary key auto_increment,
   student_id varchar(5) not null,
   old_score decimal(4,2),
   new_score decimal(4,2),
   change_date datetime default current_timestamp,
   foreign key (student_id) references students (student_id)
);
insert into students (student_id,full_name,total_debt) 
values ('MS001','Nguyễn Văn A',0),
       ('MS002','Trần Thị B',12000),
       ('MS003','Lê Văn C',20000),
       ('MS004','Phạm Thành D',0),
       ('MS005','Lò Văn E',15000);
       
-- Phần A Câu 1: 
delimiter // 
create trigger tg_check_score
before insert on gardes 
for each row
begin
   if new.score < 0 then set new.score = 0;
   elseif new.score > 10 then set new.score = 10;
   end if;
end // 
delimiter ;
insert into gardes (student_id,subject_id,score)
values ('MS001','SB001',-1),
	   ('MS002','SB001',11);
-- Phần A Câu 2: 
start transaction;
insert into students (student_id,full_name,total_debt)
values ('SV02','Ha Bich Ngoc',5000000);
commit; 
-- Phần B Câu 1: 
delimiter //
create trigger tg_log_grade_update 
after update on gardes
for each row
begin
   insert into grade_log (student_id,old_score,new_score,change_date)
   values(new.student_id,old.score,new.score,now());
end // 
delimiter ;
drop trigger tg_log_grade_update;
update gardes 
set score = 8
where student_id = 'MS001';
-- Phần B Câu 2:
delimiter // 
create procedure sp_pay_tuition (
   in v_student_id varchar(5),
   in v_price_return decimal(10,2)
)
begin 
declare v_total_debt decimal(10,2);
select total_debt into v_total_debt 
from students 
where student_id = v_student_id; 
start transaction; 
update students 
set total_debt = total_debt - v_price_return
where student_id = v_student_id;
	if v_total_debt - v_price_return  < 0 then rollback;
    else commit;
    end if;
end // 
delimiter ;
call sp_pay_tuition('SV01',2000000);
-- Phần C Câu 1: 
delimiter //
create trigger tg_prevent_pass_update
before update on grades 
for each row
begin 
   if old.score >= 4 then SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không được phép sửa điểm này';
   end if;
end // 
delimiter ; 
