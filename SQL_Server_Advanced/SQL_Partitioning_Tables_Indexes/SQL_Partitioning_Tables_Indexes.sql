/*
Writer  : Kiran
Date	: 07-August-2025
Lession : Advanced SQL Server : Partitioning   – Large Datasets

Partitioning helps divide large tables or indexes into smaller, manageable pieces (partitions) 
to improve query performance, maintenance, and scalability for large datasets.

Partition Function > Defines how to divide data into partitions based on a boundary value.

Index Partitioning > Same as table partitioning but specifically applied to indexes for efficient indexing of large datasets.

Benefits of Partitioning : 
Improved query performance by scanning only relevant partitions.
Easier data maintenance (e.g., Roll out old data).
Parallel processing on partitions.
*/
 
--Create Filegroups

ALTER DATABASE EmployeesDB FILEGROUP FG1;
ALTER DATABASE EmployeesDB ADD FILEGROUP FG2;

--Add Files to Filegroups

ALTER DATABASE EmployeesDB 
ADD FILE (NAME = N'FG1_File', FILENAME = 'C:\Data\FG1.ndf') TO FILEGROUP FG1;

ALTER DATABASE EmployeesDB  
ADD FILE (NAME = N'FG2_File', FILENAME = 'C:\Data\FG2.ndf') TO FILEGROUP FG2;

--Create Partition Function
CREATE PARTITION FUNCTION YearPartitionFunction (INT)
AS RANGE LEFT FOR VALUES (2022);

--Create Partition Scheme
CREATE PARTITION SCHEME YearPartitionScheme
AS PARTITION YearPartitionFunction
TO (FG1, FG2);

--Create Partitioned Table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    SaleYear INT,
    Amount DECIMAL(10,2)
) ON YearPartitionScheme(SaleYear);

 --Insert and Query Data

INSERT INTO Sales VALUES (1, 2021, 1000);
INSERT INTO Sales VALUES (2, 2023, 2000);

-- Query to check which partition a row falls in
SELECT * FROM Sales WHERE SaleYear = 2023;

--Partitioned Index (Optional)
CREATE CLUSTERED INDEX IX_Sales_Year
ON Sales(SaleYear)
ON YearPartitionScheme(SaleYear);
 
 --Summary

--Partitioning is useful for > Large tables and indexes
--Partition is based on > A column (called partition key)
--Needed objects > Filegroups, Partition Function, Partition Scheme
--Improves > Query performance, manageability, and scalability
--Supported in > Enterprise / Developer editions

