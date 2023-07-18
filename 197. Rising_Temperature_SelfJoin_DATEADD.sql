/*Write an SQL query to find all dates' Id with higher temperatures compared to its previous dates (yesterday).
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the primary key for this table.
This table contains information about the temperature on a certain day.*/
SELECT t.id
FROM Weather AS t
JOIN Weather AS y 
ON DATEADD(day, -1, t.recordDate) = y.recordDate
WHERE t.temperature > y.temperature;