


/*Step 1, Create empty tables*/

-- Table professor: create a table for the professors entity type, U means User Table
IF OBJECT_ID('professors', 'U') IS NULL
BEGIN
   CREATE TABLE professors(
     firstname text,
     lastname text
);
END

-- Add a column: add the university_shortname column, N indicates a Unicode string literal
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'university_shortname' AND OBJECT_ID = Object_ID(N'professors'))
BEGIN
    ALTER TABLE professors
    ADD university_shortname text;
END;

-- Change the column name
IF EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'professors'
    AND COLUMN_NAME = 'lastname'
)
BEGIN
    EXEC sp_rename 'professors.lastname', 'familyname', 'COLUMN';
END


--	Table universities: create a table for the universities entity type
IF OBJECT_ID('universities', 'U') IS NULL
BEGIN
    CREATE TABLE universities (
         university_shortname text,
         university text,
         university_city text
);
END

/*Step 2, Migrate data from old table*/

-- Insert selected data (distinct)
INSERT INTO professors
SELECT DISTINCT firstname, 
                lastname, 
				university_shortname 
FROM university_professors;


INSERT INTO universities
SELECT DISTINCT university_shortname,
                university,
	            university_city
FROM university_professors;

/*Step 3, Drop the old table */
--DROP TABLE university_professors;

/*Step 4, Adjust datatype */


