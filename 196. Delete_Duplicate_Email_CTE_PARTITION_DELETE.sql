/* Delete all the duplicate emails, keeping only one unique email with the smallest id
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| email       | varchar |
+-------------+---------+
In SQL, id is the primary key column for this table.
Each row of this table contains an email. The emails will not contain uppercase letters.*/
WITH CTE AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) AS RN
  FROM Person
)
DELETE FROM CTE
WHERE RN > 1;

SELECT *
FROM Person