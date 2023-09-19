
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




