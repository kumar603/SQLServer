/*
Writer  : Kiran
Date	: 07-August-2025
Lession : Advanced SQL Server :  Dynamic SQL – Flexible Queries

Dynamic SQL allows you to construct and execute SQL statements at runtime. It is useful when:
* The structure of a query is not known until runtime
* You need to handle dynamic WHERE clauses, table names, or column names
* Building reusable procedures that work across different tables/conditions

Dynamic SQL is a programming technique where SQL statements are built as strings and
executed at runtime using commands like `EXEC` or `sp_executesql`.

There are two main ways:
* `EXEC('sql_string')` – Simple execution, no parameterization
* `sp_executesql` – Allows parameterized queries (recommend for security and performance)
 
Use Cases:
* Searching with optional filters
* Dynamic ordering or sorting
* Working with unknown table/column names

*Caution: Always prefer `sp_executesql` over `EXEC()` to prevent SQL injection.

*/

-- Scenario: Search employees by optional filters (department and job title)

-- Using sp_executesql with parameters
DECLARE @SQL NVARCHAR(MAX)
DECLARE @Dept NVARCHAR(50) = 'IT'
DECLARE @JobTitle NVARCHAR(50) = NULL

SET @SQL = '
SELECT EmployeeID, FullName, Department, JobTitle
FROM Employees_execsql
WHERE 1 = 1'

IF @Dept IS NOT NULL
    SET @SQL += ' AND Department = @Dept'

IF @JobTitle IS NOT NULL
    SET @SQL += ' AND JobTitle = @JobTitle'

EXEC sp_executesql @SQL,
     N'@Dept NVARCHAR(50), @JobTitle NVARCHAR(50)',
     @Dept = @Dept, @JobTitle = @JobTitle
 

 --Example : Dynamic table name (not parameterizable)

 
DECLARE @TableName NVARCHAR(100) = 'Employees_execsql'
DECLARE @SQL NVARCHAR(MAX)

SET @SQL = 'SELECT TOP 5 * FROM ' + QUOTENAME(@TableName)
EXEC(@SQL)


 --**QUOTENAME()** is used to avoid SQL injection by safely quoting table or column names.

 --**Summary**
 /*
| Key Points      | Description                                                  |
| --------------- | ------------------------------------------------------------ |
| `EXEC()`        | Executes plain SQL string. No parameters.                    |
| `sp_executesql` | Allows execution with parameters. Safer and faster.          |
| `QUOTENAME()`   | Escapes identifiers like table/column names.                 |
| Use Cases       | Optional filters, dynamic table/column names, complex logic. |
| Security Tip    | Avoid string concatenation with user input. Use parameters.  |
*/
 
 -- Table create and Insert Sample Data
CREATE TABLE Employees_execsql (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Department NVARCHAR(50) NOT NULL,
    JobTitle NVARCHAR(50) NOT NULL,
    HireDate DATE,
    Salary DECIMAL(10,2),
    ManagerID INT
);

-- Insert sample data into Employees table
INSERT INTO Employees_execsql (FullName, FirstName, LastName, Email, Department, JobTitle, HireDate, Salary, ManagerID) VALUES
-- IT Department
('Alessandro Rossi', 'Alessandro', 'Rossi', 'a.rossi@company.com', 'IT', 'Software Developer', '2022-03-15', 65000.00, 5),
('Marie Dubois', 'Marie', 'Dubois', 'm.dubois@company.com', 'IT', 'Database Administrator', '2021-07-22', 70000.00, 5),
('Klaus Müller', 'Klaus', 'Müller', 'k.muller@company.com', 'IT', 'System Administrator', '2020-11-08', 68000.00, 5),
('Isabella García', 'Isabella', 'García', 'i.garcia@company.com', 'IT', 'DevOps Engineer', '2023-01-12', 72000.00, 5),
('Nikos Papadopoulos', 'Nikos', 'Papadopoulos', 'n.papadopoulos@company.com', 'IT', 'IT Manager', '2019-05-03', 85000.00, NULL),
('Astrid Larsson', 'Astrid', 'Larsson', 'a.larsson@company.com', 'IT', 'Software Architect', '2021-09-17', 78000.00, 5),

-- HR Department
('François Leclerc', 'François', 'Leclerc', 'f.leclerc@company.com', 'HR', 'HR Manager', '2018-04-10', 75000.00, NULL),
('Elena Kowalski', 'Elena', 'Kowalski', 'e.kowalski@company.com', 'HR', 'HR Specialist', '2022-06-25', 55000.00, 7),
('Giovanni Bianchi', 'Giovanni', 'Bianchi', 'g.bianchi@company.com', 'HR', 'Recruiter', '2023-02-14', 52000.00, 7),

-- Finance Department
('Ingrid Andersen', 'Ingrid', 'Andersen', 'i.andersen@company.com', 'Finance', 'Financial Analyst', '2021-12-05', 62000.00, 12),
('Pedro Silva', 'Pedro', 'Silva', 'p.silva@company.com', 'Finance', 'Accountant', '2020-08-18', 58000.00, 12),
('Catherine Martin', 'Catherine', 'Martin', 'c.martin@company.com', 'Finance', 'Finance Manager', '2019-01-28', 80000.00, NULL),

-- Marketing Department
('Lars Nielsen', 'Lars', 'Nielsen', 'l.nielsen@company.com', 'Marketing', 'Marketing Manager', '2020-03-20', 73000.00, NULL),
('Sofia Popović', 'Sofia', 'Popović', 's.popovic@company.com', 'Marketing', 'Digital Marketing Specialist', '2022-11-30', 56000.00, 13),
('Jean-Pierre Bernard', 'Jean-Pierre', 'Bernard', 'jp.bernard@company.com', 'Marketing', 'Content Creator', '2023-04-08', 48000.00, 13),

-- Sales Department
('Katarina Novák', 'Katarina', 'Novák', 'k.novak@company.com', 'Sales', 'Sales Manager', '2019-09-12', 82000.00, NULL),
('Marco Ferrari', 'Marco', 'Ferrari', 'm.ferrari@company.com', 'Sales', 'Sales Representative', '2022-01-15', 54000.00, 16),
('Anna Korhonen', 'Anna', 'Korhonen', 'a.korhonen@company.com', 'Sales', 'Account Executive', '2021-10-07', 61000.00, 16);

-- Test queries to verify the data

 