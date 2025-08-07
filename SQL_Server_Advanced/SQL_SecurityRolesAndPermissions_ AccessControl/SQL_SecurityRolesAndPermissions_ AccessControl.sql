/*
Writer  : Kiran
Date	: 07-August-2025
Lession : Advanced SQL Server : Security (Roles, Permissions) – Access Control

To control who can access what in a SQL Server environment and what actions they can perform, 
ensuring data confidentiality, integrity, and availability. 
Proper security helps prevent unauthorized access and protects sensitive data.

SQL Server Security Concepts
SQL Server security is based on principals and permissions:
Principal: An entity that can request SQL Server resources (e.g., users, roles, logins).
Securable: A resource (e.g., table, view, stored procedure).
Permission: The right to perform an action on a securable (e.g., SELECT, INSERT).

Authentication
Windows Authentication – Uses Active Directory accounts.
SQL Server Authentication – Uses SQL Server logins (username/pwd).

Authorization > Defines what an authenticated user can do.

Database Roles
Roles are collections of permissions that can be assigned to users.
Fixed Server Roles: e.g., sysadmin, securityadmin, serveradmin
Fixed Database Roles: e.g., db_owner, db_datareader, db_datawriter, db_ddladmin
User-Defined Roles: Custom roles defined per business needs.
*/
 --Create Login & User (SQL Authentication)
-- Create SQL Server Login
CREATE LOGIN AppUserLogin WITH PASSWORD = 'testpwd';

-- Create User in a specific database
USE EmployeesDB;
CREATE USER AppUser FOR LOGIN AppUserLogin;
--  Grant Permissions


-- Grant SELECT permission on a table
GRANT SELECT ON dbo.Employees TO AppUser;

-- Grant EXECUTE permission on a stored procedure
GRANT EXECUTE ON dbo.usp_GetEmployeeDetails TO AppUser;
--  Create Role & Assign Permissions


-- Create a role
CREATE ROLE HRRole;

-- Add user to the role
ALTER ROLE HRRole ADD MEMBER AppUser;

-- Grant role permissions
GRANT SELECT, INSERT, UPDATE ON dbo.Employees TO HRRole;

 --Deny or Revoke Permissions
-- Revoke SELECT permission
REVOKE SELECT ON dbo.Employees FROM AppUser;
-- Deny DELETE permission explicitly
DENY DELETE ON dbo.Employees TO AppUser;

 --View Permissions
-- View permissions for a user
SELECT * FROM fn_my_permissions(NULL, 'DATABASE');

-- List all database roles and their members sp_helprolemember;

--Project Scenario – Role-Based Access
--Assume in your EmployeesDB: HR needs full access to Employees.Accounts only needs SELECT on Salaries.

-- Create Roles
CREATE ROLE HRTeam;
CREATE ROLE AccountsTeam;

-- Add users to roles
ALTER ROLE HRTeam ADD MEMBER HRUser;
ALTER ROLE AccountsTeam ADD MEMBER AccountsUser;

-- Grant required access
GRANT SELECT, INSERT, UPDATE, DELETE ON Employees TO HRTeam;
GRANT SELECT ON Salaries TO AccountsTeam;

--Summary
--Authentication > Verifies identity (Windows / SQL login)

--Authorization > Controls access to resources

--Roles > Group of permissions assigned to users

--Permissions > SELECT, INSERT, UPDATE, DELETE, EXECUTE

--Security Model > Principal → Securable → Permissions

