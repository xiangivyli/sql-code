


/*Step 1, Create empty tables*/

-- 1a Table professor: create a table for the professors entity type, U means User Table
IF OBJECT_ID('professors', 'U') IS NULL
BEGIN
   CREATE TABLE professors(
     firstname text,
     lastname text
);
END

-- 1a1 Add a column: add the university_shortname column, N indicates a Unicode string literal
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'university_shortname' AND OBJECT_ID = Object_ID(N'professors'))
BEGIN
    ALTER TABLE professors
    ADD university_shortname text;
END;

-- 1a2 Change the column name
IF EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'professors'
    AND COLUMN_NAME = 'lastname'
)
BEGIN
    EXEC sp_rename 'professors.lastname', 'familyname', 'COLUMN';
END


--	1b Table universities: create a table for the universities entity type
IF OBJECT_ID('universities', 'U') IS NULL
BEGIN
    CREATE TABLE universities (
         university_shortname text,
         university text,
         university_city text
);
END

-- 1c Table affiliations: create a table for the relationship between professors and organisations
IF OBJECT_ID('affiliations', 'U') IS NULL
BEGIN
    CREATE TABLE affiliations (
	     firstname text,
		 familyname text,
		 organisation text,
		 [function] text
);
END

-- 1d Table organisations: create a table for the organisation entity type
IF OBJECT_ID('organisations', 'U') IS NULL
BEGIN
   CREATE TABLE organisations (
         organisation VARCHAR(256),
		 organisation_sector VARCHAR(128)
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


;WITH CTE AS (
  SELECT organisation, organisation_sector
         RN = ROW_NUMBER() OVER (PARTITION BY organisation, organisation_sector ORDER BY (SELECT NULL))
  FROM dbo.organisations
)
DELETE FROM CTE WHERE RN > 1;



/*Step 3, Drop the old table */
--DROP TABLE university_professors;

/*Step 4, Adjust constraints, datatype, unique, null, primary key */

-- 4a Datatype: Change the datatype for short_name to fix length at 3
ALTER TABLE professors
ALTER COLUMN university_shortname
CHAR(3);

ALTER TABLE universities
ALTER COLUMN university_shortname
CHAR(3);

ALTER TABLE organisations
ALTER COLUMN organisation
VARCHAR(256);

ALTER TABLE professors
ALTER COLUMN firstname
VARCHAR(68); 

ALTER TABLE professors
ALTER COLUMN familyname
VARCHAR(68); 

ALTER TABLE affiliations
ALTER COLUMN firstname
VARCHAR(68);

ALTER TABLE affiliations
ALTER COLUMN familyname
VARCHAR(68);


-- 4b nullable: Set not null columns
ALTER TABLE professors
ALTER COLUMN firstname text NOT NULL;

ALTER TABLE professors
ALTER COLUMN familyname text NOT NULL;

ALTER TABLE professors
ALTER COLUMN university_shortname CHAR(3) NOT NULL;

ALTER TABLE universities
ALTER COLUMN university_shortname CHAR(3) NOT NULL;

ALTER TABLE organisations
ALTER COLUMN organisation VARCHAR(256) NOT NULL;


-- 4c Unique: Set unique key for universities table
ALTER TABLE universities
ADD CONSTRAINT unishortnameunique UNIQUE (university_shortname);

-- Change the constraint name
ALTER TABLE universities
DROP CONSTRAINT unishortnameunique

ALTER TABLE universities
ADD CONSTRAINT uni_shortname_unique UNIQUE (university_shortname);

-- 4d Primary Key: Add primary key
ALTER TABLE universities
ADD CONSTRAINT PK_universities PRIMARY KEY (university_shortname);

EXEC sp_rename 'organisations.organisation', 'organisation_id', 'COLUMN';
ALTER TABLE organisations
ADD CONSTRAINT PK_orgaisations PRIMARY KEY(organisation_id);


-- 4e Surrogate Key: Add surrogate keys for professors
ALTER TABLE professors
ADD id INT IDENTITY(1,1) CONSTRAINT PK_professors PRIMARY KEY;

/*Step 5, foreign key, build relationship */

-- 1:N from professors to universities
ALTER TABLE professors
ADD CONSTRAINT professors_fkey FOREIGN KEY (university_shortname) REFERENCES universities (university_shortname);

-- N:M relationship from professors to organisations with affiliations table
ALTER TABLE affiliations
ADD professor_id INT,
    CONSTRAINT fk_affiliations_professors FOREIGN KEY (professor_id) REFERENCES professors(id);

-- populate professor_id in affiliations
UPDATE affiliations
SET professor_id = professors.id
FROM affiliations
JOIN professors ON affiliations.firstname = professors.firstname
                AND affiliations.familyname = professors.familyname;

--Drop firstname and family name because there has been ids
ALTER TABLE affiliations
DROP COLUMN firstname;

ALTER TABLE affiliations
DROP COLUMN familyname;

-- 
ALTER TABLE affiliations
ADD CONSTRAINT affiliations_fkey FOREIGN KEY (organisation_id) REFERENCES organisations(organisation_id);

-- Identify the correct constraint name
SELECT constraint_name, table_name, constraint_type
FROM INFORMATION_SCHEMA.table_constraints
WHERE constraint_type = 'FOREIGN KEY';

-- Drop the right forign key constraint
ALTER TABLE professors
DROP CONSTRAINT professors_universities_shortname_fkey;

-- Add a new foreign key constraint from professors to universities which ACTION deletion
ALTER TABLE professors
ADD CONSTRAINT professors_universities_shortname_fkey FOREIGN KEY (university_shortname) 
               REFERENCES universities (university_shortname) ON DELETE NO ACTION;

-- Check the referential integrity 
DELETE FROM professors
WHERE firstname = 'Alain';