/*
Writer : Kiran
Date : 31-July-2025
Indexes help SQL Server locate rows faster by creating lookup structures, 
much like a book index. They significantly boost performance for SELECT 
queries and sometimes for JOINs, ORDER BY, and WHERE clauses.

An index is a data structure (B-Tree) that SQL Server uses to quickly find and access the data in a table.

Types of Indexes:
Clustered Index : Sorts and stores the actual table data physically in order of the key. Only one per table.
Non-Clustered Index : Creates a separate structure with pointers to the actual data. Multiple allowed per table.
The PRIMARY KEY creates a Clustered Index by default.

*/
-- Create Table
 
use SQLIntermediateCompanyVault

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100),
    Department VARCHAR(50),
    Salary INT
);
 INSERT INTO Employees (Name, Department, Salary)
VALUES 
('Kiran', 'IT', 30000),
('MarK', 'HR', 50000),
('David', 'Finance', 45000);
 
--Create Non-Clustered Index on Department
 CREATE NONCLUSTERED INDEX IX_Employees_Department
ON Employees (Department);

--Check Index Usage with Execution Plan
-- Enable Actual Execution Plan in SSMS (Ctrl + M)
SELECT * FROM Employees WHERE Department = 'IT';
--You’ll see SQL Server using the non-clustered index in the execution plan.

--Delete Index (if Need)
DROP INDEX IX_Employees_Department ON Employees;


--Create Composite Index (Multiple Columns)
CREATE NONCLUSTERED INDEX IX_Dept_Salary
ON Employees (Department, Salary);

--Used for multi-filter queries like:
SELECT * FROM Employees 
WHERE Department = 'Finance' AND Salary > 40000;


