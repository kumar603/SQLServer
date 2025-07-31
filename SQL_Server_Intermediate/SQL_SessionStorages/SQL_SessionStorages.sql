/*
Writer : Kiran
Date : 31-July-2025

Temporary e variables are used to store and manipulate 
temporary datasets inside stored procedures, scripts, or batch operations.
They're helpful for complex queries, intermediate processing, or performance tuning.

 Basic familiarity with SELECT, INSERT, DELETE

*/
 
use SQLIntermediateCompanyVault

  CREATE TABLE #TempEmployees (
    EmpID INT,
    Name VARCHAR(100)
);

INSERT INTO #TempEmployees VALUES (1, 'Mark'), (2, 'Test');

SELECT * FROM #TempEmployees;

DROP TABLE #TempEmployees; -- Optional, auto-dropped when session ends

--Visible in Other Sessions
CREATE TABLE ##GlobalTemp (
    ID INT,
    Info VARCHAR(50)
);

INSERT INTO ##GlobalTemp VALUES (1, 'Available Global');

-- In another session, you can run:
-- SELECT * FROM ##GlobalTemp;

DECLARE @Tempemp TABLE (
    EmpID INT,
    Name VARCHAR(100)
);

INSERT INTO @Tempemp VALUES (101, 'Mark'), (102, 'Test');

SELECT * FROM @Tempemp;


--Use Case in Stored Procedure
CREATE PROCEDURE GetHighSalaryEmployees
AS
BEGIN
    DECLARE @HighSalary TABLE (EmpID INT, Name VARCHAR(100));

    INSERT INTO @HighSalary
    SELECT EmpID, Name FROM Employees WHERE Salary > 50000;

    SELECT * FROM @HighSalary;
END;

EXEC GetHighSalaryEmployees;