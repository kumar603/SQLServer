/*
Writer  : Kiran
Date	: 07-August-2025
Lession : Advanced SQL Server : Database Backups - Disaster -  Restore Data

To ensure data is safe and can be restored in case of failure or corruption.
Understand type of backups, how to take and restore them for recovery.

Backups & Restore in SQL Server 
Why Backups Matter: Protects against data loss due to:
					Hardware failure
					Ransomware attacks
					Disaster (power failure, corruption, etc.)
Types of Backups:
Full Backup > Entire database (data). Foundation for all backups.
Differential > Only changes since last full backup.
Transaction Log > Backs up T-log, used for point-in-time recovery.
File/Filegroup > Backs up specific file/filegroups of the DB. Useful for large databases.
Copy-only > Special full backup without affecting backup sequence.

Restore Options: 
Restore Full Backup alone
Restore Full + Differential
Restore Full + T-Logs (with STOPAT) for point-in-time recoveries
*/

 --Code Example: SQL Server Backup and Restore
 --Full Database Backup

BACKUP DATABASE EmployeeApp
TO DISK = 'C:\SQLBackups\EmployeeApp_FULL.bak'
WITH FORMAT, INIT, NAME = 'Full Backup of EmployeeApp';

--Differential Backup
BACKUP DATABASE EmployeeApp
TO DISK = 'C:\SQLBackups\EmployeeApp_DIFF.bak'
WITH DIFFERENTIAL;

 --Transaction Log Backup
BACKUP LOG EmployeeApp
TO DISK = 'C:\SQLBackups\EmployeeApp_TLog.trn';

--Restore Full Backup (With NORECOVERY for subsequent restores)
RESTORE DATABASE EmployeeApp
FROM DISK = 'C:\SQLBackups\EmployeeApp_FULL.bak'
WITH NORECOVERY;

 --Restore Differential Backup
RESTORE DATABASE EmployeeApp
FROM DISK = 'C:\SQLBackups\EmployeeApp_DIFF.bak'
WITH RECOVERY;

--Point-in-Time Recovery using T-Log Backup
RESTORE LOG EmployeeApp
FROM DISK = 'C:\SQLBackups\EmployeeApp_TLog.trn'
WITH STOPAT = '2025-08-06 12:30:00', RECOVERY;


--Summary
--Key Points
--Use full backups regularly (daily/weekly).
--Use differential or T-log backups frequently (hourly/daily).
--Store backups off-site/cloud for disaster scenarios.
--Always test restore on a non-prod server to verify backup integrity.
--Automate backups using SQL Server Agent Jobs.
