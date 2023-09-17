Create database Company;
use company;
go
CREATE TABLE Emp (
    eid INTEGER PRIMARY KEY,
    ename varchar(100),
    age INTEGER,
    salary REAL
);
go

create table Works(
	eid integer REFERENCES Emp(Eid),
	did integer,
	pct_time integer
	primary key (eid,did)
);
go
create table Dept(
	did integer primary key,
	dname varchar(100),
	budget real,
	managerid integer,
	foreign key (managerid) references emp (eid)
	
);

go
alter table Works
ADD CONSTRAINT fk_works_dept
foreign Key (did) references Dept(did)
go