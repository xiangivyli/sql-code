


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

-- Table affiliations: create a table for the relationship between professors and organisations
IF OBJECT_ID('affiliations', 'U') IS NULL
BEGIN
    CREATE TABLE affiliations (
	     firstname text,
		 familyname text,
		 organisation text,
		 [function] text
);
END

-- Table organisations: create a table for the organisation entity type
IF OBJECT_ID('organisations', 'U') IS NULL
BEGIN
   CREATE TABLE organisations (
         organisation text,
		 organisation_sector text
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

INSERT INTO organisations
SELECT DISTINCT organization,
                organization_sector
FROM university_professors; 

INSERT INTO affiliations
SELECT DISTINCT firstname,
                lastname,
				organization,
				[function]
FROM university_professors; 

/*Step 3, Drop the old table */
--DROP TABLE university_professors;

/*Step 4, Adjust constrants, datatype, unique, null */

-- Change the datatype for short_name to fix length at 3
ALTER TABLE professors
ALTER COLUMN university_shortname
CHAR(3);

ALTER TABLE universities
ALTER COLUMN university_shortname
CHAR(3);

-- Change the first name to 64 maximum
ALTER TABLE professors
ALTER COLUMN firstname
VARCHAR(64);

-- Set not null columns
ALTER TABLE professors
ALTER COLUMN firstname text NOT NULL;

ALTER TABLE professors
ALTER COLUMN familyname text NOT NULL;

ALTER TABLE professors
ALTER COLUMN university_shortname CHAR(3) NOT NULL;

ALTER TABLE universities
ALTER COLUMN university_shortname CHAR(3) NOT NULL;


-- Set unique key for universities table
ALTER TABLE universities
ADD CONSTRAINT unishortnameunique UNIQUE (university_shortname);

-- Change the constraint name
ALTER TABLE universities
DROP CONSTRAINT unishortnameunique

ALTER TABLE universities
ADD CONSTRAINT uni_shortname_unique UNIQUE (university_shortname);