/*
Writer : Kiran
Date : 24-July-2025

Combining Data — Retrieve data from multiple related tables based on logical relationships between them
 JOINs are used to combine rows from two or more tables based on a related column between them.
 
 INNER JOIN > Returns records with matching values in both tables.
 LEFT JOIN > Returns all records from the left table and matched records from the right.
 RIGHT JOIN > Returns all records from the right table and matched records from the left.
 FULL JOIN > Returns records when there is a match in either left or right table.
*/

-- Creating a Employees , Departments
--CREATE TABLE Employees (
--    EmpID INT PRIMARY KEY,
--    EmpName VARCHAR(100),
--    DeptID INT
--);

--CREATE TABLE Departments (
--    DeptID INT PRIMARY KEY,
--    DeptName VARCHAR(50)
--);

----Sample Data for Join Testing
----Departments 
--INSERT INTO Departments (DeptID, DeptName)
--VALUES
--(1, 'HR'),
--(2, 'Finance'),
--(3, 'Engineering'),
--(4, 'Marketing'),  -- Dept with no employees
--(5, 'IT');  -- Dept with no employees

  
----Employees Table

--INSERT INTO Employees (EmpID, EmpName, DeptID)
--VALUES
--(101, 'Alice', 1),
--(102, 'Mark', 2),
--(103, 'Dave', 3),
--(104, 'David', NULL),   -- No department assigned
--(105, 'Eva', 5);       -- Invalid DeptID (not in Departments)


-- INNER JOIN
SELECT E.EmpID, E.EmpName, D.DeptName
FROM Employees E
INNER JOIN Departments D ON E.DeptID = D.DeptID;

-- LEFT JOIN
SELECT E.EmpID, E.EmpName, D.DeptName
FROM Employees E
LEFT JOIN Departments D ON E.DeptID = D.DeptID;

-- RIGHT JOIN
SELECT E.EmpID, E.EmpName, D.DeptName
FROM Employees E
RIGHT JOIN Departments D ON E.DeptID = D.DeptID;

-- FULL OUTER JOIN
SELECT E.EmpID, E.EmpName, D.DeptName
FROM Employees E
FULL OUTER JOIN Departments D ON E.DeptID = D.DeptID;