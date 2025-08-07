/*
Writer  : Kiran
Date	: 07-August-2025
Lession : Advanced SQL Server :  Execution Plans – Performance Analysis

To visually analyze how SQL Server executes queries using execution plans, 
helping to identify inefficiencies such as table scans, missing indexes, or expensive operations. 
It enables performance optimization.

An execution plan is a graphical or textual representation of how SQL Server will execute a query. 
It shows the sequence of operations (scan, join, sort, etc.), along with the cost of each.

There are two types:
Estimated Execution Plan: Predicts the plan without executing the query.
Actual Execution Plan: Shows the real operations and row counts after query execution.

Key Components in an Execution Plan:
 
Index Seek > Efficient index-based access

Key Lookup > Lookup in clustered index after index seek

Nested Loops > Good for small datasets

 Match > Used for large datasets / joins

Estimated vs Actual Rows > Mismatch = outdated stats or bad estimates

Operator Cost % > Relative cost of each step in the plan
 
*/
 
--Sample Table & Data


-- Create sample table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10,2)
);

-- Insert dummy data
INSERT INTO Products (ProductID, Name, Category, Price)
VALUES
(1, 'Camera', 'Electronics', 800),
(2, 'Monopoly Board Game', 'Toys & Games', 500),
(3, 'Television', 'Electronics', 120),
(4, 'Magic: The Gathering Commander Deck', 'Toys & Games', 300);

--Enable Execution Plan
--In SSMS, press Ctrl + M or click “Include Actual Execution Plan” before executing any query.
--Run a Query

SELECT * FROM Products WHERE Name = 'Television';
--If no index on Name, you’ll likely see a Table Scan in the plan.

--Add Index & Recheck
-- Add index to improve performance
CREATE NONCLUSTERED INDEX IX_Products_Name ON Products(Name);

-- Rerun the same query
SELECT * FROM Products WHERE Name = 'Television';
--Now, the execution plan will likely show Index Seek — a sign of optimized query performance.

--📈 Use Cases of Execution Plan:
--Find issues in slow-running queries.
--Check for missing indexes.
--Understand join strategy (Nested Loop, Hash Match, etc.).
--Compare Estimated vs Actual rows to validate statistics.

 --Summary
--Key Points 
--Explanation
--Execution Plans help tune queries
--Analyze operators, cost, and data flow
--Index Seek is better than Scan
--Means SQL Server found an efficient index
--Use SSMS tools
--Ctrl + M enables Actual Execution Plan
--Look for high-cost operations
--These indicate opportunities for improvement

