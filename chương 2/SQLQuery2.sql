use Company;
go

insert into Emp values(101,'John Doe',32,15000)
INSERT INTO Emp VALUES(101,'John Doe',32,15000);
INSERT INTO Emp VALUES(102,'Alice Smith',28,16000);
INSERT INTO Emp VALUES(103,'Bob Johnson',35,17000);
INSERT INTO Emp VALUES(104,'Emily Davis',30,15500);
INSERT INTO Emp VALUES(105,'Michael Wilson',40,18000);
INSERT INTO Emp VALUES(106,'Sarah Brown',29,16500);
INSERT INTO Emp VALUES(107,'David Lee',33,17500);
INSERT INTO Emp VALUES(108,'Laura Garcia',27,14500);
INSERT INTO Emp VALUES(109,'James Robinson',36,19000);
INSERT INTO Emp VALUES(110,'Linda Martinez',31,16000);

go
select *
from Emp;
go

update Emp
set salary = salary * 1.1;
go

insert into Dept values (111,'Toy',1000000,102)
INSERT INTO Dept VALUES (112, 'Electronics', 800000, 104);
INSERT INTO Dept VALUES (113, 'Clothing', 750000, 105);
INSERT INTO Dept VALUES (114, 'Furniture', 900000, 107);
INSERT INTO Dept VALUES (115, 'Sports', 600000, 108);
go

select *
from Dept;
go

INSERT INTO Works VALUES (101, 111, 8);
INSERT INTO Works VALUES (102, 112, 9);
INSERT INTO Works VALUES (103, 113, 7);
INSERT INTO Works VALUES (104, 114, 8);
INSERT INTO Works VALUES (105, 115, 9);
INSERT INTO Works VALUES (106, 111, 7);
INSERT INTO Works VALUES (107, 112, 8);
INSERT INTO Works VALUES (108, 113, 9);
INSERT INTO Works VALUES (109, 114, 7);
INSERT INTO Works VALUES (110, 115, 8);

select *
from Works;

delete from Dept
where dname  = 'Toy';