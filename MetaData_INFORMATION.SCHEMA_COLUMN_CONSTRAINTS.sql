
/****** INFORMATION_SCHEMA.TABLES/COLUMNS/CONSTRAINTS ******/
-- Databases store metadata in tables

-- 1.list table schemas, included tables and table tppes
SELECT *
FROM INFORMATION_SCHEMA.TABLES;

-- 2.list column names and position, types, and other detailed info
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS;

-- 3.list constraints defined on tables
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS;

-- 4.list check constraints defined on tables
SELECT *
FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS;


-- 5.list details about the foreign key constraints and their relationships to primary key constraints
SELECT *
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS;


/****** EXPLORE ONE TABLE WITH INFORMATION_SCHEMA ******/

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CovidDeathsCountry'
 AND TABLE_SCHEMA = 'dbo';
