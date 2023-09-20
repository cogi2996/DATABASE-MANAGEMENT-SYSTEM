
-- Tạo bảng "Emp"
CREATE TABLE Emp (
    eid INT PRIMARY KEY,
    ename VARCHAR(255),
    age INT,
    salary REAL
);

-- Tạo bảng "Works"
CREATE TABLE Works (
    eid INT,
    did INT,
    pct_time INT,
    FOREIGN KEY (eid) REFERENCES Emp(eid),
    FOREIGN KEY (did) REFERENCES Dept(did)
);

-- Tạo bảng "Dept"
CREATE TABLE Dept (
    did INT PRIMARY KEY,
    budget REAL,
    managerid INT
);

--1.
alter table Emp
add constraint Emp_MinSalary
check (Emp.salary >= 1000)
--2.
alter table Dept
add constraint Valid_manager
foreign key (managerid) references Emp(eid)
--3
alter table Works
add constraint pct_check
check (pct_time < 100)

IF OBJECT_ID ('Sales.reminder1', 'TR') IS NOT NULL 
  DROP TRIGGER Sales.reminder1; 
GO
CREATE TRIGGER reminder1 ON Sales.Customer 
AFTER INSERT, UPDATE 
AS RAISERROR ('Notify Customer Relations', 16, 10); 
GO 

--4
IF OBJECT_ID ('Emp.CheckSalaryEmp', 'TR') IS NOT NULL 
  DROP TRIGGER Emp.CheckSalaryEmp; 
GO
create trigger CheckSalaryEmp
on Emp
after insert, update
as
begin
	if exists (
		select 1
		from Emp e,Works
		where  e.eid = Works.eid and e.salary >=  (select Emp.salary from Emp,Dept where  Dept.did = Works.did and Dept.managerid = Emp.eid ) 
	)
	begin
	 RAISERROR('A manager must always have a higher salary than any employee that he or she manages.',16,1);
	ROLLBACK TRANSACTION;
	end
end
go
use COMPANY
go
--5
IF OBJECT_ID ('Emp.IncreaseSalary', 'TR') IS NOT NULL 
  DROP TRIGGER Emp.IncreaseSalary; 
GO

create trigger IncreaseSalary 
on Emp
after update
as 
-- lấy id và salary thằng nhân viên vừa update
declare @id int, @EmpSal real
select @id = new.eid, @EmpSal = new.salary
from deleted old, inserted new
where new.eid = old.eid
-- lấy id người quản lí thàng nhân viên vừa bị update
declare @manageId int
select @manageId = Dept.managerid from Dept where Dept.managerid = @id

if 
(select Emp.salary from Emp where Emp.eid  = @manageId) < @EmpSal
begin
update Emp
set salary = @EmpSal
where Emp.eid = @manageId
end
go




--6
use COMPANY
go
DROP TRIGGER IncreaseSalary;
go
-- Xóa trigger có tên 'IncreaseSalary'
IF OBJECT_ID ('Emp.IncreaseSalary', 'TR') IS NOT NULL
  DROP TRIGGER Emp.IncreaseSalary;
go

create trigger IncreaseSalary
on Emp
after update
as
if UPDATE(salary)
begin
-- lấy id và salary của thằng nhân viên vừa update #salary
	declare @id int, @EmpSal real
	select @id = new.eid, @EmpSal = new.salary
	from  inserted new
-- tìm ra id manager của nó
	declare @managerid int
	select @managerid = Dept.managerid
	from Dept 
	where Dept.did = (select Works.did from Works where @id = Works.eid)
	--Emp(eid) --> (eid)Works(did) --> (did)Dept
-- tăng lương manager nếu có
	if @EmpSal > (select Emp.salary from Emp where Emp.eid = @managerid )
	begin
	-- Update Emp tại dòng có id của manager --> update salary
		update Emp
		set Emp.salary = @EmpSal
		where Emp.eid = @managerid
	end
-- tăng budget của dept nếu có
-- sum Lương của nhân viên trong bộ phân
-- did - dept
-- eid's did
-- @id--> (eid)Work(eid)-->(eid)Emp

-- tìm ra dept của Emp
declare @EmpDept int
select @EmpDept = Works.did  from Works where Works.eid = @id

--EmpDept--> (did)Works(eid) --> (eid)Emp
declare @TotalSalary real
select @TotalSalary = sum(Emp.salary)
from Emp,Works
where Works.did = @EmpDept and Works.eid = Emp.eid

-- Dept budget update ( nếu có )
if @TotalSalary > ( select Dept.budget from Dept where Dept.did = @EmpDept)
begin 
	update Dept
	set budget = @TotalSalary
	where Dept.did = @EmpDept
end

end
go

-- Chèn dữ liệu vào bảng Emp
INSERT INTO Emp (eid, ename, age, salary)
VALUES
    (1, 'John', 30, 50000.00),
    (2, 'Alice', 35, 60000.00),
    (3, 'Bob', 40, 75000.00),
    (4, 'Mary', 28, 48000.00),
    (5, 'David', 45, 90000.00),
    (6, 'Linda', 32, 55000.00);

go
--create view ( can update)
create view SeniorEmpSalary (sid,salary)
as select Emp.eid,Emp.salary
from Emp
where Emp.age >=35;
go
-- create view (un-update)
create view TotalSeniorSalary (salary)
as select sum(Emp.Salary) as ToTalSalary
from Emp
where Emp.age >=35;
go

select T.salary
from TotalSeniorSalary T

update TotalSeniorSalary
set salary *=2


select s.sid, s.salary
from SeniorEmpSalary s
go
-- update view
update SeniorEmpSalary
set salary /=2;

select *
from Emp;