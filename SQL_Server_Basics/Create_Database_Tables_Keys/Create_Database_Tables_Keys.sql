/*
--Database: A container of data objects (tables, views, stored procedures, Functions).
--Table: Stores data in rows and columns.
--Primary Key (PK): Uniquely identifies each row.
--Foreign Key (FK): Creates a relationship between tables.
*/
-- Create a new database
CREATE DATABASE CompanyVault;
GO

-- Use the database
USE CompanyVault;
GO

-- Create a table with a primary key
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(100)
);

-- Create another table with a foreign key
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);
