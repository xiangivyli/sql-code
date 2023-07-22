/*+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
In SQL, id is the primary key column for this table.
Each row of this table contains information about the salary of an employee.
Find the second highest salary from the Employee table. If there is no second highest salary, return null (return None in Pandas).*/

SELECT CASE
           WHEN COUNT(*) = 1 THEN
               NULL
           ELSE
               MIN(salary)
       END AS SecondHighestSalary
FROM
(SELECT DISTINCT TOP 2 salary FROM employee ORDER BY salary DESC) AS top2;
