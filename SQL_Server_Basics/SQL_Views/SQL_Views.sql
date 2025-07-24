/*
Writer : Kiran
Date : 24-July-2025

 Views provide abstraction and simplify complex queries. 
 They act as virtual tables and help in reusing SQL logic without duplicating code. 
 They're useful for reporting, security (read-only access), and joining multiple tables.
 
A View is a named SQL query stored in the database.
It does not store data, only the query logic.
Views can be:
Simple: based on a single table.
Complex: join multiple tables with filters.
can use views just like tables: SELECT * FROM view_name.

View Types:
Simple > Based on one table, no functions
Complex > Joins, aggregations, functions
Indexed > Materialized for performance


*/
  --Example 1: Simple View for Employee Names

  -- Create a simple view
CREATE VIEW vw_EmployeeNames
AS
SELECT 
    EmpID,
    EmpName AS FullName
FROM Employees;
GO

-- Use the view
SELECT * FROM vw_EmployeeNames;


--Complex View for Employees with Department
-- Create a view with join
CREATE VIEW vw_EmployeeDepartment
AS
SELECT 
    E.EmpID,
    E.EmpName AS FullName,
    D.DeptName
FROM Employees E
JOIN Departments D ON E.DeptID = D.DeptID;
GO

-- Use the view
SELECT * FROM vw_EmployeeDepartment;

-- Use the view
SELECT * FROM vw_EmployeeDepartment;


--Filtered View for High Earners
-- View with WHERE clause
CREATE VIEW vw_HighSalaryEmployees
AS
SELECT 
    EmpID,
    EmpName,
    DeptID
FROM Employees
WHERE DeptID > 1;
GO

-- Query
SELECT * FROM vw_HighSalaryEmployees