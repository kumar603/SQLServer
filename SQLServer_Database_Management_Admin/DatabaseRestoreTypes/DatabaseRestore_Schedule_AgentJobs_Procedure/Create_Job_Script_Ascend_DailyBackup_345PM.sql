-- =============================================
-- Step 1: Use msdb for job creation
-- =============================================
USE msdb;
GO

-- =============================================
-- Step 2: Drop existing job and schedule if they exist
-- =============================================
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'Ascend_DailyBackup')
BEGIN
    EXEC sp_delete_job @job_name = N'Ascend_DailyBackup';
    PRINT 'Dropped old job Ascend_DailyBackup';
END
GO

IF EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name = N'Daily_345PM')
BEGIN
    EXEC sp_delete_schedule @schedule_name = N'Daily_345PM';
    PRINT 'Dropped old schedule Daily_345PM';
END
GO

-- =============================================
-- Step 3: Create the new job
-- =============================================
EXEC sp_add_job 
    @job_name = N'Ascend_DailyBackup',
    @enabled = 1,
    @description = N'Backup Ascend database daily at 3:45 PM IST to shared folder';

-- =============================================
-- Step 4: Add job step with dynamic filename
-- =============================================
EXEC sp_add_jobstep
    @job_name = N'Ascend_DailyBackup',
    @step_name = N'Backup Ascend',
    @subsystem = N'TSQL',
    @command = N'
        DECLARE @FileName NVARCHAR(300);
        SET @FileName = ''C:\Users\kiran\OneDrive - KiranJuvvanapudi\SQLServer\Databases\Backups\Ascend\Ascend_''
                        + CONVERT(VARCHAR(8), GETDATE(), 112) + ''.bak'';

        BACKUP DATABASE Ascend
        TO DISK = @FileName
        WITH INIT, COMPRESSION, STATS = 10;',
    @database_name = N'master';

-- =============================================
-- Step 5: Create daily schedule at 3:45 PM IST
-- =============================================
EXEC sp_add_schedule 
    @schedule_name = N'Daily_345PM',
    @enabled = 1,
    @freq_type = 4,        -- Daily
    @freq_interval = 1,    -- Every day
    @active_start_time = 154500; -- 15:45:00 (3:45 PM)

-- =============================================
-- Step 6: Attach schedule to job
-- =============================================
EXEC sp_attach_schedule 
    @job_name = N'Ascend_DailyBackup',
    @schedule_name = N'Daily_345PM';

-- =============================================
-- Step 7: Register job with SQL Server Agent
-- =============================================
EXEC sp_add_jobserver 
    @job_name = N'Ascend_DailyBackup';
GO