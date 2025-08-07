/*
Writer  : Kiran
Date	: 07-August-2025
Lession : Advanced SQL Server : SQL Server Agent (Jobs, Alerts) – Automation

SQL Server Agent allows you to automate routine database tasks such as running backups, executing stored procedures, or sending alerts. 
It supports job scheduling and notification to ensure database health and maintenance without manual intervention.

SQL Server Agent is a component of SQL Server used for:
Jobs: A job is a series of actions SQL Server Agent performs.
Steps: Each job has one or more steps. A step might be a T-SQL command or SSIS package.
Schedules: Jobs can be scheduled to run automatically.
Alerts: These notify DBAs based on specific performance conditions or events (e.g., failed jobs, high CPU, login failures).

Common use cases:
Automatic backups
Sending email alerts on job failures
Rebuilding indexes during off-hours
Running ETL processes using SSIS

Prerequisites
SQL Server Agent should be running (Start it from SQL Server Services if stopped).
Sufficient permissions (SQLAgentOperatorRole or sysadmin).
Database Mail configuration (for alerts via email).
*/

--Practical Example: Create a Job to Backup a Database Daily

--Step-by-Step: > Start SQL Server Agent >  From SQL Server Management Studio > Object Explorer > SQL Server Agent > Right-click > Start

--Create a Job
USE msdb;
GO

EXEC sp_add_job
    @job_name = N'DailyDatabaseBackup',
    @enabled = 1;

--Add Job Step
EXEC sp_add_jobstep
    @job_name = N'DailyDatabaseBackup',
    @step_name = N'BackupStep',
    @subsystem = N'TSQL',
    @command = N'BACKUP DATABASE [EmployeeDB] TO DISK = N''C:\Backup\EmployeeDB.bak'' WITH INIT',
    @database_name = N'master';

--Add a Schedule
EXEC sp_add_schedule
    @schedule_name = N'DailyBackupSchedule',
    @freq_type = 4,  -- daily
    @active_start_time = 020000;  -- 2 AM

--Attach Schedule to Job
EXEC sp_attach_schedule
    @job_name = N'DailyDatabaseBackup',
    @schedule_name = N'DailyBackupSchedule';

--Add the Job to the SQL Server Agent
EXEC sp_add_jobserver
    @job_name = N'DailyDatabaseBackup';

--Setting Up Alerts (e.g., for Job Failure)
EXEC msdb.dbo.sp_add_alert
    @name = N'Backup Job Failed Alert',
    @message_id = 0,
    @severity = 16,
    @enabled = 1,
    @notification_message = N'The backup job has failed',
    @include_event_description_in = 1,
    @job_name = N'DailyDatabaseBackup';

-- Add an operator (must exist)
EXEC msdb.dbo.sp_add_notification
    @alert_name = N'Backup Job Failed Alert',
    @operator_name = N'DBAOperator',
    @notification_method = 1; -- Email

--Summary
--SQL Server Agent > Automates jobs like backups, data loads, and health checks. 
--Jobs & Steps > Define what the agent will do.
--Schedules > Define when the job will run.
--Alerts > Notify stakeholders when predefined conditions occur.

