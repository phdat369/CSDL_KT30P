create database miniprojectss12;
use miniprojectss12;


-- 1. Bảng Khoa
CREATE TABLE Department (
    DeptID VARCHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- 2. Bảng SinhVien
CREATE TABLE Student (
    StudentID VARCHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    BirthDate DATE,
    DeptID VARCHAR(5),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- 3. Bảng MonHoc
CREATE TABLE Course (
    CourseID VARCHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

-- 4. Bảng DangKy
CREATE TABLE Enrollment (
    StudentID VARCHAR(6),
    CourseID VARCHAR(6),
    Score DECIMAL(4,2), 
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Chèn dữ liệu mẫu
INSERT INTO Department VALUES
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

INSERT INTO Student VALUES
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');

insert into course 
values ('C001','Lập trình C',12000),
       ('P002','Lập trình Python',15000),
       ('W003','Lập trình Web',12000),
       ('DT01','Cơ sở dữ liệu',12000);
insert into Enrollment 
values ('S00001','C001',9.3),
       ('S00002','C001',6.7),
       ('S00003','C001',8.9),
       ('S00004','C001',9.6),
       ('S00005','C001',7.5);

create view ViewStudentBasic 
as select s.StudentID,s.FullName,d.DeptName
from student s 
inner join department d 
on d.deptid = s.deptid;

select StudentID,FullName,DeptName
from ViewStudentBasic;

create index idxFullName 
on student(FullName);

delimiter //
create procedure GetStudentsIT ()
begin
   select s.fullname,d.deptname
   from student s
   inner join department d
   on d.deptid = s.deptid
   where d.deptname = 'Information Technology';
end //
delimiter ;
call GetStudentsIT();

create view ViewStudentCountByDept 
as select d.deptname,count(s.studentid) as totalstudent
from department d 
inner join student s 
on s.deptid = d.deptid
group by d.deptname;

select deptname
from ViewStudentCountByDept
where totalstudent = (select max(totalstudent)
                      from ViewStudentCountByDept);

delimiter //
create procedure GetTopScoreStudent (
   in varCourseID varchar(6)
)
begin
   select s.fullname 
   from enrollment e
   inner join course c
   on c.courseid = e.courseid 
   inner join student s 
   on s.studentid = e.studentid
   where e.coureseid in (select courseid
                        from course
                        where coursename = varCourseID)
	order by e.score desc
    limit 1;
end //
delimiter ;
call GetTopScoreStudent ('Lập trình C');