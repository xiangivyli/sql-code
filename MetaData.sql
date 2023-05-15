
-- Databases store metadata in tables

-- list table schemas, included tables and table tppes
SELECT *
FROM INFORMATION_SCHEMA.TABLES;

-- list column names and position, types, and other detailed info
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS;

-- list constraints defined on tables
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS;

-- list check constraints defined on tables
SELECT *
FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS;


-- list details about the foreign key constraints and their relationships to primary key constraints
SELECT *
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS;