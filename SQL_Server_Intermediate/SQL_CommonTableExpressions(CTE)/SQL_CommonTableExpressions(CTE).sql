/*
Writer : Kiran
Date : 31-July-2025

A Common Table Expression (CTE) is a temporary result set that you can reference within a SELECT, INSERT, UPDATE, or DELETE statement. 
CTEs simplify nested queries and support recursive querying, especially useful for hierarchical data like org charts or folder structures.

Recursive CTE:
Used to repeatedly call itself until a condition is met (commonly for hierarchy/tree traversal).

*/
 
use SQLIntermediateCompanyVault

--Sample Table Setup
 CREATE TABLE EmployeesCTE (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(100),
    ManagerID INT  -- Self-referencing FK
);

INSERT INTO EmployeesCTE VALUES
(1, 'CEO', NULL),
(2, 'CTO', 1),
(3, 'CFO', 1),
(4, 'Dev Manager', 2),
(5, 'Developer', 4),
(6, 'Accountant', 3);

--Non-Recursive CTE (Simple View)
WITH TechEmployees AS (
    SELECT * FROM EmployeesCTE WHERE ManagerID = 2
)
SELECT * FROM TechEmployees;
--This CTE simplifies the query logic for reuse.


--Recursive CTE (Org Chart)
WITH OrgChart AS (
    -- Anchor member (top-level boss)
    SELECT EmpID, Name, ManagerID, 0 AS Level
    FROM EmployeesCTE
    WHERE ManagerID IS NULL

    UNION ALL

    -- Recursive member
    SELECT e.EmpID, e.Name, e.ManagerID, oc.Level + 1
    FROM EmployeesCTE e
    INNER JOIN OrgChart oc ON e.ManagerID = oc.EmpID
)
SELECT * FROM OrgChart ORDER BY Level, EmpID;
--Traverses the employee hierarchy from top (CEO) to bottom.