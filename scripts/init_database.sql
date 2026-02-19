/*
============================================================
Script Name  : init_database.sql

Description  : Creates database named 'DataWarehouse'
               after checking if it does not exists. 

               Creates the schemas for the data warehouse
               (bronze, silver, gold) after checking if it
               does not exists.
============================================================
*/

USE master;
GO
-- ============================================================
-- Create Database
-- ============================================================

IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    CREATE DATABASE DataWarehouse;
    PRINT 'Database successfully created';
END
ELSE
BEGIN
    PRINT 'Database already exists';
END

USE DataWarehouse;
GO
-- ============================================================
-- Create Schemas
-- ============================================================

-- Bronze Schema: Raw data as-is from source systems (CRM and ERP)
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
    PRINT 'Schema bronze created successfully';
END
ELSE
BEGIN
    PRINT 'Schema bronze already exists';
END
GO

-- Silver Schema: Cleaned and standardized data
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver');
    PRINT 'Schema silver created successfully';
END
ELSE
BEGIN
    PRINT 'Schema silver already exists';
END
GO

-- Gold Schema: Business-ready and aggregated data
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold');
    PRINT 'Schema gold created successfully';
END
ELSE
BEGIN
    PRINT 'Schema gold already exists';
END
GO
