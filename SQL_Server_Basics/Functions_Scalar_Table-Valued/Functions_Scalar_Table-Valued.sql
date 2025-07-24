/*
Writer : Kiran
Date : 24-July-2025
Reusability
Functions allow you to:
Encapsulate logic: Write once, reuse everywhere.
Avoid duplication: Useful for repetitive calculations or logic.
Improve maintainability: Centralize logic so updates are easier.
Enhance readability: Makes queries cleaner and easier to understand.

In SQL Server, functions allow you to encapsulate reusable logic in a structured way.
There are mainly two types:

1. Scalar Functions
Returns a single value (e.g., string, number, date).
Used in SELECTs, WHERE clauses, etc.

2. Table-Valued Functions (TVF)
Returns a table result set.

Can be joined or queried like a normal table.
*/

-- Returns full name by combining first and last names
CREATE FUNCTION dbo.GetFullName
(
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50)
)
RETURNS VARCHAR(101)
AS
BEGIN
    RETURN RTRIM(@FirstName + ' ' + @LastName)
END;

-- Usge of Scalary Function
Select dbo.GetFullName('Kiran','Kumar') as FullName;


--Inline Table-Valued Function
Create Function dbo.GetEmployeesByDept
(@DeptId INT)
RETURNS TABLE
AS
RETURN
(
	SELECT  EmpID, EmpName, DeptID 
	from Employees 
		where DeptID=@DeptId
);


-- Usge of Inline Table Valued Function
Select * from  dbo.GetEmployeesByDept(1);