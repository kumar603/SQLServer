/*
Writer : Kiran
Date : 31-July-2025

A transaction is a logical unit of work that must be completed entirely or not at all. 
SQL Server uses transactions to maintain data integrity during insert/update/delete operations, 
especially when multiple statements are involved.

Atomicity > All operations in a transaction succeed or fail together.

Consistency > Data remains valid and consistent before and after the transaction.

Isolation > Transactions operate independently; intermediate changes are hidden.

Durability > Once committed, data changes persist—even during power failures/crashes. 

Transaction Control Keywords:

BEGIN TRANSACTION: Starts a new transaction
COMMIT: Saves all changes
ROLLBACK: Reverts all changes
SAVE TRAN: Creates a named savepoint (optional)

*/
 
use SQLIntermediateCompanyVault

--Sample Table Setup
 CREATE TABLE BankAccounts (
    AccountNo INT PRIMARY KEY,
    AccountHolder VARCHAR(100),
    Balence INT
);

INSERT INTO BankAccounts VALUES (1001, 'Kiran', 5000), (1002, 'Mark', 7000);

--Successful Transaction – Transfer Amount
BEGIN TRANSACTION;

UPDATE BankAccounts
SET Balence = Balence - 1000
WHERE AccountNo = 1001;

UPDATE BankAccounts
SET Balence = Balence + 1000
WHERE AccountNo = 1002;

COMMIT;
--Transfers ₹1000 from Kiran to Mark.

--Failed Transaction with Rollback
BEGIN TRANSACTION;

UPDATE BankAccounts
SET Balence = Balence - 10000  -- Overdraw, let's say limit is ₹5000
WHERE AccountNo = 1001;

-- Check condition and manually rollback
IF (SELECT Balence FROM BankAccounts WHERE AccountNo = 1001) < 0
BEGIN
    PRINT 'Insufficient funds. Rolling back...';
    ROLLBACK;
END
ELSE
BEGIN
    COMMIT;
END
--Ensures Kiran’s account cannot go negative.

--Using TRY...CATCH for Error Handling
BEGIN TRY
    BEGIN TRANSACTION;

    -- Intentional error: Update non-existent account
    UPDATE BankAccounts SET Balence = Balence + 500 WHERE AccountNo = 9999;

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Transaction failed: ' + ERROR_MESSAGE();
END CATCH