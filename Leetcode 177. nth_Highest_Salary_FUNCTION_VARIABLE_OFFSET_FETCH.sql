/*+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
In SQL, id is the primary key column for this table.
Each row of this table contains information about the salary of an employee.
 

Find the nth highest salary from the Employee table. If there is no nth highest salary, return null.

The result format is in the following example.*/
CREATE FUNCTION getNthHighestSalary(@N INT) RETURNS INT AS
BEGIN
    RETURN (
        SELECT DISTINCT salary
        FROM Employee
        ORDER BY salary DESC
        OFFSET (@N - 1) ROWS FETCH NEXT 1 ROWS ONLY
    );
END