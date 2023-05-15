


/*Step 1, Create 4 empty tables*/

-- Create a table for the professors entity type
CREATE TABLE professors (
 firstname text,
 lastname text
);

-- Add the university_shortname column
ALTER TABLE professors
ADD university_shortname text;

-- Change the column name
EXEC sp_rename 'professors.lastname', 'familyname', 'COLUMN';


-- Create a table for the universities entity type
CREATE TABLE universities (
    university_shortname text,
    university text,
    university_city text
);

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

/*Step 3, Drop the old table*/
DROP TABLE university_professors;

