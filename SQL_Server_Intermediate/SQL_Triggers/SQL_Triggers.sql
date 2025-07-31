/*
Writer : Kiran
Date : 31-July-2025
Triggers are special stored procedures that automatically execute in response 
		 to certain data manipulation events (INSERT, UPDATE, DELETE) on a table or view.
They are used for: 	Enforcing business rules Maintaining audit trails Preventing unwanted data changes
Types of Triggers:
AFTER Trigger > Executes after the triggering event completes. Used for auditing, logging, validation.
INSTEAD OF Trigger > Executes in place of the DML event. Used to override or prevent the action.
*/
-- Create Table
 
use SQLIntermediateCompanyVault

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100),
    Department VARCHAR(50),
    Salary INT
);
 INSERT INTO Employees (Name, Department, Salary)
VALUES 
('Kiran', 'IT', 30000),
('MarK', 'HR', 50000),
('David', 'Finance', 45000);
CREATE TABLE AuditLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    EmpID INT,
    ActionType VARCHAR(10),
    ActionTime DATETIME DEFAULT GETDATE()
);

 --A. AFTER INSERT Trigger
CREATE TRIGGER trg_AfterInsert
ON Employees
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (EmpID, ActionType)
    SELECT EmpID, 'INSERT' FROM inserted;
END;

 --Test It
 INSERT INTO Employees (Name, Department, Salary)
VALUES ('Priya', 'IT', 55000);

SELECT * FROM AuditLog;

--INSTEAD OF DELETE Trigger
CREATE TRIGGER trg_InsteadOfDelete
ON Employees
INSTEAD OF DELETE
AS
BEGIN
    PRINT 'Delete not allowed on Employees!';
END

 --Test It
DELETE FROM Employees WHERE EmpID = 5;
-- You will see: Delete not allowed on Employees table!

--AFTER UPDATE Trigger (Optional)
CREATE TRIGGER trg_AfterUpdate
ON Employees
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (EmpID, ActionType)
    SELECT EmpID, 'UPDATE' FROM inserted;
END;