/*
--Pattern Design — Understanding SQL Server data types is crucial for designing reliable, 
		efficient, and consistent database Structures.
 

INT  > Whole numbers > 1, 100, -50

DECIMAL(p,s) > Fixed-point numeric values > 123.45 (p = precision, s = scale)

VARCHAR(n) > Variable-length text (max n chars) > 'John Doe'

CHAR(n) > Fixed-length text > 'Y', 'M'

BIT > Boolean values (1 or 0) > 1 (true), 0 (false)

DATE > Only the date > '2025-07-23'

DATETIME > Date + time > '2025-07-23 10:30:00'
*/

-- Creating a table using various data types
CREATE TABLE StudentDetails (
    StudentID INT PRIMARY KEY,               -- Integer identifier - Integer
    FullName VARCHAR(100),                   -- Student name - String Varchar
    DateofBirth DATE,                        -- Date of birth - Date
    Marks DECIMAL(5,2),                      -- Decimal with 2 places - DECIMAL
    Gender CHAR(1),                          -- M/F - CHAR
    IsPresent BIT,                           -- Boolean flag - BIT
    RegisteredOn DATETIME DEFAULT GETDATE()  -- Auto-set registration date - DATETIME
);
