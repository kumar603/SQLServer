/*
Writer  : Kiran
Date	: 07-August-2025
Lession : Advanced SQL Server :  Data Transformations – Pivot and Unpivoting Data

Transform rows into columns (pivot) or columns into rows (unpivot) to reshape 
your result set for reporting, summaries, or analytics.

PIVOT > Converts row values into columns. Useful when you want to create a cross-tabular report or summary.

UNPIVOT > Converts columns back into rows. Useful when normalizing denormalized data.

Summary
PIVOT: Turn values into columns – great for summaries.
UNPIVOT: Normalize multiple columns back into row format.
Best for reporting, analytics, and BI dashboards.

*/

-- Create Sales table
CREATE TABLE Sales (
    SalesID INT IDENTITY(1,1) PRIMARY KEY,
    Year INT NOT NULL,
    Product NVARCHAR(50) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL
);

-- Insert sample data
INSERT INTO Sales (Year, Product, Amount) VALUES
-- 2023 data
(2023, 'Camera', 12500.00),
(2023, 'Camera', 8750.00),
(2023, 'Camera', 15200.00),
(2023, 'Television', 6800.00),
(2023, 'Television', 9200.00),
(2023, 'Television', 11500.00),
(2023, 'Television', 4300.00),

-- 2024 data
(2024, 'Camera', 18900.00),
(2024, 'Camera', 13600.00),
(2024, 'Camera', 22100.00),
(2024, 'Television', 8900.00),
(2024, 'Television', 12400.00),
(2024, 'Television', 15600.00),
(2024, 'Television', 7100.00);

-- View original data
SELECT * FROM Sales ORDER BY Year, Product;

-- PIVOT Example: Convert rows to columns
SELECT * FROM (
    SELECT Year, Product, Amount 
    FROM Sales
) AS Source
PIVOT (
    SUM(Amount) FOR Product IN ([Camera], [Television])
) AS PivotResult;

-- UNPIVOT Example: Convert columns back to rows
SELECT Year, Product, Amount FROM (
    SELECT Year, Camera, Television FROM (
        SELECT * FROM (
            SELECT Year, Product, Amount 
            FROM Sales
        ) AS Source
        PIVOT (
            SUM(Amount) FOR Product IN ([Camera], [Television])
        ) AS Pivoted
    ) AS PivotedData
) AS UnpivotSource
UNPIVOT (
    Amount FOR Product IN (Camera, Television)
) AS UnpivotedResult
ORDER BY Year, Product;