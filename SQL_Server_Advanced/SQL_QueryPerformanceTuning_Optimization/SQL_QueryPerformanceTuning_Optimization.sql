/*
Writer  : Kiran
Date	: 07-August-2025
Lession : Advanced SQL Server :  Query Performance Tuning – Optimization

To improve the speed and efficiency of SQL queries by identifying and eliminating bottlenecks, 
ensuring faster data retrieval and optimal resource usage.

Query Performance Tuning involves analyzing, identifying, and optimizing slow-running queries. 
SQL Server provides tools and techniques to measure, understand, and improve query execution.
 
Common Causes of Slow Queries: : Missing indexes
								 Poorly written queries
								 Large scans (instead of seeks)
								 Unnecessary joins
								 Excessive nested subqueries
								 Outdated statistics

Key Concepts:
Indexing >  Speeds up data access for specific columns
Statistics > Helps optimizer estimate row counts
Query Optimizer > Chooses the best way to execute a query

Tools for Tuning: >   SQL Profiler > Database Engine Tuning Advisor > DMVs (Dynamic Management Views)
*/
 

--Code Examples
 --View Execution Plan
-- Enable execution plan in SSMS (Ctrl+M or click “Include Actual Execution Plan”)
SELECT * FROM Employees_Refactor WHERE FirstName = 'John';

--Use STATISTICS TIME and IO
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT * FROM Orders WHERE OrderDate > '2023-01-01';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

--Identify Missing Indexes
SELECT 
    migs.avg_total_user_cost, 
    mid.statement AS TableName,
    mid.equality_columns, mid.inequality_columns,
    mid.included_columns
FROM sys.dm_db_missing_index_group_stats migs
JOIN sys.dm_db_missing_index_groups mig ON migs.group_handle = mig.index_group_handle
JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
ORDER BY migs.avg_total_user_cost DESC;

--Rewriting Queries for Performance Poor Query:

SELECT * FROM Employees_Refactor WHERE YEAR(HireDate) = 2023;
--Better (SARGable - can use index):

SELECT * FROM Employees_Refactor 
WHERE HireDate >= '2023-01-01' AND HireDate < '2024-01-01';

 --Create Index for Optimization


CREATE NONCLUSTERED INDEX IX_Employees_LastName
ON Employees(LastName);

/*
Summary
Tuning improves query execution time and reduces server load.
Use execution plans, indexes, and statistics to identify issues.
Rewrite non-SARGable queries to allow index usage.
Regularly analyze and refactor slow queries for optimal performance.
*/

-- Create Employees_Refactor table
CREATE TABLE Employees_Refactor (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Department NVARCHAR(50) NOT NULL,
    JobTitle NVARCHAR(50) NOT NULL,
    HireDate DATE NOT NULL,
    Salary DECIMAL(10,2),
    ManagerID INT,
    City NVARCHAR(50),
    Country NVARCHAR(50)
);

-- Create Orders table for performance testing examples
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    CustomerName NVARCHAR(100),
    OrderDate DATE NOT NULL,
    OrderAmount DECIMAL(10,2),
    Status NVARCHAR(20)
);

-- Insert sample data into Employees_Refactor table with European names
INSERT INTO Employees_Refactor (FirstName, LastName, Email, Department, JobTitle, HireDate, Salary, ManagerID, City, Country) VALUES
-- IT Department
('Alessandro', 'Rossi', 'a.rossi@company.com', 'IT', 'Software Developer', '2023-03-15', 65000.00, 5, 'Milan', 'Italy'),
('Marie', 'Dubois', 'm.dubois@company.com', 'IT', 'Database Administrator', '2023-07-22', 70000.00, 5, 'Lyon', 'France'),
('Klaus', 'Müller', 'k.muller@company.com', 'IT', 'System Administrator', '2022-11-08', 68000.00, 5, 'Berlin', 'Germany'),
('Isabella', 'García', 'i.garcia@company.com', 'IT', 'DevOps Engineer', '2023-01-12', 72000.00, 5, 'Barcelona', 'Spain'),
('Nikos', 'Papadopoulos', 'n.papadopoulos@company.com', 'IT', 'IT Manager', '2021-05-03', 85000.00, NULL, 'Athens', 'Greece'),
('Astrid', 'Larsson', 'a.larsson@company.com', 'IT', 'Software Architect', '2023-09-17', 78000.00, 5, 'Stockholm', 'Sweden'),

-- HR Department  
('François', 'Leclerc', 'f.leclerc@company.com', 'HR', 'HR Manager', '2022-04-10', 75000.00, NULL, 'Paris', 'France'),
('Elena', 'Kowalski', 'e.kowalski@company.com', 'HR', 'HR Specialist', '2023-06-25', 55000.00, 7, 'Warsaw', 'Poland'),
('Giovanni', 'Bianchi', 'g.bianchi@company.com', 'HR', 'Recruiter', '2023-02-14', 52000.00, 7, 'Rome', 'Italy'),
('John', 'Smith', 'j.smith@company.com', 'HR', 'HR Assistant', '2023-08-20', 45000.00, 7, 'London', 'UK'),

-- Finance Department
('Ingrid', 'Andersen', 'i.andersen@company.com', 'Finance', 'Financial Analyst', '2023-12-05', 62000.00, 12, 'Copenhagen', 'Denmark'),
('Pedro', 'Silva', 'p.silva@company.com', 'Finance', 'Accountant', '2022-08-18', 58000.00, 12, 'Lisbon', 'Portugal'),
('Catherine', 'Martin', 'c.martin@company.com', 'Finance', 'Finance Manager', '2021-01-28', 80000.00, NULL, 'Brussels', 'Belgium'),
('Matteo', 'Ferrari', 'm.ferrari@company.com', 'Finance', 'Financial Controller', '2023-04-15', 75000.00, 12, 'Florence', 'Italy'),

-- Marketing Department
('Lars', 'Nielsen', 'l.nielsen@company.com', 'Marketing', 'Marketing Manager', '2022-03-20', 73000.00, NULL, 'Oslo', 'Norway'),
('Sofia', 'Popović', 's.popovic@company.com', 'Marketing', 'Digital Marketing Specialist', '2023-11-30', 56000.00, 15, 'Belgrade', 'Serbia'),
('Jean-Pierre', 'Bernard', 'jp.bernard@company.com', 'Marketing', 'Content Creator', '2023-04-08', 48000.00, 15, 'Marseille', 'France'),
('Anna', 'Korhonen', 'a.korhonen@company.com', 'Marketing', 'Brand Manager', '2023-10-07', 61000.00, 15, 'Helsinki', 'Finland'),

-- Sales Department
('Katarina', 'Novák', 'k.novak@company.com', 'Sales', 'Sales Manager', '2022-09-12', 82000.00, NULL, 'Bratislava', 'Slovakia'),
('Marco', 'Rosso', 'm.rosso@company.com', 'Sales', 'Sales Representative', '2023-01-15', 54000.00, 19, 'Venice', 'Italy'),
('Björn', 'Eriksson', 'b.eriksson@company.com', 'Sales', 'Account Executive', '2023-05-22', 59000.00, 19, 'Gothenburg', 'Sweden'),
('Amélie', 'Moreau', 'a.moreau@company.com', 'Sales', 'Sales Coordinator', '2023-03-18', 51000.00, 19, 'Nice', 'France');

-- Insert sample data into Orders table
INSERT INTO Orders (EmployeeID, CustomerName, OrderDate, OrderAmount, Status) VALUES
(1, 'Tech Solutions Ltd', '2023-01-15', 15000.00, 'Completed'),
(2, 'Digital Corp', '2023-02-20', 8500.00, 'Completed'),
(3, 'Innovation Hub', '2023-03-10', 12000.00, 'Pending'),
(4, 'Future Systems', '2023-04-05', 9800.00, 'Completed'),
(5, 'Smart Tech', '2023-05-12', 22000.00, 'Completed'),
(6, 'Global Dynamics', '2023-06-18', 17500.00, 'Processing'),
(7, 'Enterprise Solutions', '2023-07-25', 6700.00, 'Completed'),
(8, 'Modern Systems', '2023-08-30', 11200.00, 'Completed'),
(9, 'Advanced Tech', '2023-09-15', 14800.00, 'Cancelled'),
(10, 'Progressive Corp', '2023-10-22', 19600.00, 'Completed'),
(11, 'Elite Solutions', '2023-11-08', 7300.00, 'Processing'),
(12, 'Prime Systems', '2023-12-14', 13400.00, 'Completed'),
(13, 'NextGen Tech', '2022-12-20', 16900.00, 'Completed'),
(14, 'Innovative Corp', '2022-11-15', 8900.00, 'Completed'),
(15, 'Strategic Solutions', '2022-10-10', 21500.00, 'Completed'),
(16, 'Dynamic Systems', '2024-01-05', 12700.00, 'Processing'),
(17, 'Forward Tech', '2024-01-20', 18300.00, 'Completed'),
(18, 'Leading Edge', '2024-02-12', 9400.00, 'Processing');

-- Performance Testing Examples

-- 1. View Execution Plan
-- Enable execution plan in SSMS (Ctrl+M or click "Include Actual Execution Plan")
SELECT * FROM Employees_Refactor WHERE FirstName = 'John';

-- 2. Use STATISTICS TIME and IO
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SELECT * FROM Orders WHERE OrderDate > '2023-01-01';
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

-- 3. Identify Missing Indexes (System Query)
SELECT 
    migs.avg_total_user_cost, 
    mid.statement AS TableName,
    mid.equality_columns, 
    mid.inequality_columns,
    mid.included_columns
FROM sys.dm_db_missing_index_group_stats migs
JOIN sys.dm_db_missing_index_groups mig ON migs.group_handle = mig.index_group_handle
JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
WHERE mid.statement LIKE '%Employees_Refactor%' OR mid.statement LIKE '%Orders%'
ORDER BY migs.avg_total_user_cost DESC;

-- 4. Rewriting Queries for Performance

-- Poor Query (Non-SARGable):
SELECT * FROM Employees_Refactor WHERE YEAR(HireDate) = 2023;

-- Better Query (SARGable - can use index):
SELECT * FROM Employees_Refactor 
WHERE HireDate >= '2023-01-01' AND HireDate < '2024-01-01';

-- Another Poor Query Example:
SELECT * FROM Employees_Refactor WHERE UPPER(LastName) = 'ROSSI';

-- Better Alternative:
SELECT * FROM Employees_Refactor WHERE LastName = 'Rossi';

-- 5. Create Indexes for Optimization
CREATE NONCLUSTERED INDEX IX_Employees_Refactor_LastName
ON Employees_Refactor(LastName);

CREATE NONCLUSTERED INDEX IX_Employees_Refactor_HireDate
ON Employees_Refactor(HireDate);

CREATE NONCLUSTERED INDEX IX_Employees_Refactor_Department
ON Employees_Refactor(Department);

CREATE NONCLUSTERED INDEX IX_Orders_OrderDate
ON Orders(OrderDate);

CREATE NONCLUSTERED INDEX IX_Orders_EmployeeID
ON Orders(EmployeeID);

-- 6. Additional Performance Test Queries

-- Test query performance before and after index creation
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- Query that will benefit from LastName index
SELECT EmployeeID, FirstName, LastName, Department, JobTitle
FROM Employees_Refactor 
WHERE LastName = 'Rossi';

-- Query that will benefit from HireDate index
SELECT COUNT(*) AS EmployeesHired2023
FROM Employees_Refactor 
WHERE HireDate >= '2023-01-01' AND HireDate < '2024-01-01';

-- Query that will benefit from Department index
SELECT Department, AVG(Salary) AS AvgSalary
FROM Employees_Refactor 
GROUP BY Department;

-- Join query that will benefit from both table indexes
SELECT e.FirstName, e.LastName, COUNT(o.OrderID) AS TotalOrders, SUM(o.OrderAmount) AS TotalAmount
FROM Employees_Refactor e
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
WHERE e.HireDate >= '2023-01-01'
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY TotalAmount DESC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;