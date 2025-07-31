/*
Writer : Kiran
Date : 31-July-2025
-- SQL Stored Procedures Code Resuse 
	A named collection of SQL statements stored in the database.
--  Stored Procedures are reusable, precompiled SQL code blocks 
	that can accept input (IN), return output (OUT),and handle business logic efficiently. 
	They improve performance, security, and reduce redundancy.

IN parameter: Accepts a value passed by the caller.
OUT parameter: Sends a value back to the caller.
Benefits: Encapsulates complex logic.
		 Centralized changes.
		 Reduces client-server traffic.

*/
-- Create Table
Create Database SQLIntermediateCompanyVault
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

--Create a Stored Procedure with IN Parameter
CREATE PROCEDURE GetEmployeesByDepartment
    @Dept VARCHAR(50)
AS
BEGIN
    SELECT * FROM Employees WHERE Department = @Dept;
END;
--Execute Procedure
EXEC GetEmployeesByDepartment @Dept = 'IT';

-- Stored Procedure with IN and OUT Parameters
CREATE PROCEDURE GetEmployeeSalary
    @EmpName VARCHAR(100),
    @Salary INT OUTPUT
AS
BEGIN
    SELECT @Salary = Salary FROM Employees WHERE Name = @EmpName;
END;
-- Execute and Get Output:
DECLARE @Sal INT;
EXEC GetEmployeeSalary @EmpName = 'Kiran', @Salary = @Sal OUTPUT;
PRINT 'Salary: ' + CAST(@Sal AS VARCHAR);

--Stored Procedure with Multiple Parameters

CREATE PROCEDURE AddEmployee
    @Name VARCHAR(100),
    @Dept VARCHAR(50),
    @Salary INT
AS
BEGIN
    INSERT INTO Employees (Name, Department, Salary)
    VALUES (@Name, @Dept, @Salary);
END;

EXEC AddEmployee @Name = 'Kiran K', @Dept = 'IT', @Salary = 60000;