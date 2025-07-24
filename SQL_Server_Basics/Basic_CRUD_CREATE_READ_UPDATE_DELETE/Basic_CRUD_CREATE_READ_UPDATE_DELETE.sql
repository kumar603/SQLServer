/*
Writer : Kiran
Date : 24-July-2025
-- Basic CRUD (SELECT, INSERT, UPDATE, DELETE)
-- SQL Query Operations — Learn how to Create, Read,
		Update, and Delete records from tables using SQL Server commands.

Create > INSERT > Add new records to a table
Read > SELECT > Retrieve data from one or more tables
Update > UPDATE > Changes existing data
Delete > DELETE > Remove data from a table

-- Always use WHERE clause in UPDATE and DELETE to avoid affecting all rows
*/
--  Insert Data
INSERT INTO StudentDetails (StudentID, FullName, DateOfBirth, Marks, Gender, IsPresent)
VALUES (1, 'Kiran Kumar', '2000-05-15', 88.50, 'M', 1);

-- Select Data
 SELECT FullName,Marks from StudentDetails;

 -- Update Data
 UPDATE StudentDetails 
 SET  Marks = 91.75
 WHERE  StudentId = 1

 --DELETE Data
DELETE FROM StudentDetailss
WHERE StudentID = 1;