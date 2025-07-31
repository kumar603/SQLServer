/*
Writer : Kiran
Date : 31-July-2025

SQL Server provides TRY...CATCH blocks to handle errors during runtime. 
This allows developers to trap, log, and react to issues like constraint violations, 
arithmetic errors, or invalid operations without crashing the application or procedure.

Error Info Functions inside CATCH:
 

ERROR_NUMBER() > Error code

ERROR_MESSAGE() > Error description

ERROR_LINE() > Line number of error

ERROR_PROCEDURE() > Stored procedure name

ERROR_SEVERITY() > Severity of the error

Familiarity with DML statements and transactions

*/
 
use SQLIntermediateCompanyVault

 --TRY CATCH Structure: 
 BEGIN TRY
    -- SQL statements that may cause error
END TRY
BEGIN CATCH
    -- Error handling logic
END CATCH

--Sample Error Without Handling
-- Will fail if EmpID already exists
INSERT INTO Employees (EmpID, Name, Department, Salary)
VALUES (1, 'Duplicate Test', 'IT', 50000);
--This will throw a primary key violation without a graceful exit.

--Using TRY  CATCH to Handle Insert Error
BEGIN TRY
    INSERT INTO Employees (EmpID, Name, Department, Salary)
    VALUES (1, 'Duplicate Test', 'IT', 50000);
    PRINT 'Insert successful';
END TRY
BEGIN CATCH
    PRINT 'Error Occurred: ' + ERROR_MESSAGE();
END CATCH;

--Use TRY CATCH With Transaction

BEGIN TRY
    BEGIN TRANSACTION;

    -- Error-prone action (invalid AccountNo)
    UPDATE BankAccounts
    SET Balence = Balence - 1000
    WHERE AccountNo = 9999;

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Transaction failed: ' + ERROR_MESSAGE();
END CATCH;

--Log Errors in Audit Table
CREATE TABLE ErrorLog (
    ErrorMsg VARCHAR(4000),
    ErrorTime DATETIME DEFAULT GETDATE()
);

BEGIN TRY
    -- Force error: divide by zero
    DECLARE @x INT = 1 / 0;
END TRY
BEGIN CATCH
    INSERT INTO ErrorLog (ErrorMsg)
    VALUES (ERROR_MESSAGE());
END CATCH;

SELECT * FROM ErrorLog;