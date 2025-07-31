/*
Writer : Kiran
Date : 31-July-2025

User-Defined Functions (UDFs) are reusable SQL routines that return a value (scalar) or a table (table-valued). 
They help modularize logic, simplify queries, and improve code reusability in SQL Server.

Types of UDFs

Scalar Function > Single value (INT, VARCHAR, etc.) > Return computed/calculated values

Inline Table-Valued Function (ITVF) > Table (via SELECT) > Return result sets from logic

Multi-Statement Table-Valued Function (MSTVF) > Table (via INSERTs/logic) > Complex logic with multiple steps

*/
 
use SQLIntermediateCompanyVault

  -- Scalar
CREATE FUNCTION fn_Scalar (@Param INT) RETURNS INT AS BEGIN RETURN @Param * 2 END

-- Table-Valued
CREATE FUNCTION fn_TableValued (@Dept VARCHAR(50)) RETURNS TABLE AS
RETURN (SELECT * FROM Employees WHERE Department = @Dept);

--Scalar Function – Return Bonus Amount
CREATE FUNCTION fn_GetBonus
(@Salary INT)
RETURNS INT
AS
BEGIN
    RETURN @Salary * 10 / 100; -- 10% bonus
END;

SELECT Name, Salary, dbo.fn_GetBonus(Salary) AS Bonus
FROM Employees;

--Inline Table-Valued Function (ITVF)
CREATE FUNCTION fn_EmployeesByDept
(@Dept VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT EmpID, Name FROM Employees WHERE Department = @Dept
);

SELECT * FROM dbo.fn_EmployeesByDept('IT');

--Multi-Statement Table-Valued Function
CREATE FUNCTION fn_HighEarners ()
RETURNS @Result TABLE (EmpID INT, Name VARCHAR(100))
AS
BEGIN
    INSERT INTO @Result
    SELECT EmpID, Name FROM Employees WHERE Salary > 50000;

    RETURN;
END;

SELECT * FROM dbo.fn_HighEarners();