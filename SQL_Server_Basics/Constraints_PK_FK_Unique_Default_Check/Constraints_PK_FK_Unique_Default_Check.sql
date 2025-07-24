/*
Writer : Kiran
Date : 24-July-2025
-- Data Integrity — Ensure that the data in your database 
	is accurate and reliable by enforcing rules at the table level.
	SQL Constraints are rules enforced on columns to maintain data integrity.

PRIMARY KEY  > Primary Key > Uniquely identifies each record in a table; does not allow NULLs.

FOREIGN KEY > Foreign Key > Enforces a relationship between columns of two tables.

UNIQUE > Unique Key> Ensures all values in a column are different.

DEFAULT > Default Value > Provides a default value when none is specified during insert.

CHECK > Check Constraint > Validates data before it’s entered (e.g., age must be > 0).

NOT NULL > Not Null Constraint > Ensures that a column cannot have a NULL value.	 
*/
 CREATE TABLE EmployeeDetails (
    EmpID INT PRIMARY KEY,                            -- PK
    EmpName VARCHAR(100) NOT NULL,                    -- NOT NULL
    Email VARCHAR(100) UNIQUE,                        -- UNIQUE
    DepartmentID INT,                                 
    JoinDate DATE DEFAULT GETDATE(),                  -- DEFAULT
    Age INT CHECK (Age >= 18),                        -- CHECK
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DeptID) -- FK
);

--select * from Departments 
--CREATE TABLE Departments (
--    DeptID INT PRIMARY KEY,
--    DeptName VARCHAR(50) NOT NULL
--);

--Practice Tips
--Try inserting employees without a JoinDate to test the DEFAULT.

--Try inserting two employees with the same Email to test the UNIQUE.

--Try inserting an employee with Age < 18 to see the CHECK constraint in action.

--Try inserting a DepartmentID that doesn’t exist in Departments to test FOREIGN KEY.

