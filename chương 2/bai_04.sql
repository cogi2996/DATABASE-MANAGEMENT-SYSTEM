-- Tạo cơ sở dữ liệu "InWork"
CREATE DATABASE InWork;

-- Sử dụng cơ sở dữ liệu "InWork"
USE InWork;

-- Tạo bảng Emp
CREATE TABLE Emp (
    eid INTEGER PRIMARY KEY,
    ename VARCHAR(255),
    age INTEGER,
    salary REAL
);

-- Chèn dữ liệu vào bảng Emp
INSERT INTO Emp (eid, ename, age, salary) VALUES
    (1, 'John Doe', 35, 50000.0),
    (2, 'Jane Smith', 28, 45000.0),
    (3, 'Bob Johnson', 40, 60000.0);

-- Tạo bảng Works
CREATE TABLE Works (
    eid INTEGER,
    did INTEGER,
    pct_time INTEGER,
    PRIMARY KEY (eid, did),
    FOREIGN KEY (eid) REFERENCES Emp(eid),
    FOREIGN KEY (did) REFERENCES Dept(did)
);

-- Chèn dữ liệu vào bảng Works
INSERT INTO Works (eid, did, pct_time) VALUES
    (1, 101, 100),
    (2, 102, 75),
    (3, 101, 50);

-- Tạo bảng Dept
CREATE TABLE Dept (
    did INTEGER PRIMARY KEY,
    budget REAL,
    managerid INTEGER,
    FOREIGN KEY (managerid) REFERENCES Emp(eid)
);

-- Chèn dữ liệu vào bảng Dept
INSERT INTO Dept (did, budget, managerid) VALUES
    (101, 1000000.0, 1),
    (102, 800000.0, 2),
    (103, 1200000.0, 3);
go

CREATE TRIGGER CheckManagerAge
ON Dept
AFTER INSERT, UPDATE
AS
BEGIN
    -- Check if any new manager's age is less than or equal to 30
    IF EXISTS (
        SELECT 1
        FROM inserted i INNER JOIN Emp e ON i.managerid = e.eid
        WHERE e.age <= 30
    )
    BEGIN
        RAISERROR('Managers must be older than 30 years.', 16, 1);
        ROLLBACK TRANSACTION; -- Rollback the transaction to prevent the change
    END
END;
go

INSERT INTO Emp (eid, ename, age, salary) VALUES
    (4, 'John ', 29, 50000.0)
go
INSERT INTO Emp (eid, ename, age, salary) VALUES
    (5, 'John ', 31, 50000.0)
go

INSERT INTO Dept (did, budget, managerid) VALUES
    (104, 1000000.0, 5)
go