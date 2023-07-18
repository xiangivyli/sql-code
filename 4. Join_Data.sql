-- inner join
SELECT p1.country, p1.continent, prime_minister, president
FROM prime_ministers AS p1
INNER JOIN presidents AS p2
ON p1.country = p2.country;

-- inner join via USING
SELECT left_table.id AS L_id,
       left_table.val AS L_val,
       right_table.val AS R_val
FROM left_table
INNER JOIN right_table
USING (id);

-- JOIN prime_ministers to itself
SELECT p1.country AS country1, p2.country AS country2, p1.continent
FROM prime_ministers AS p1
INNER JOIN prime_ministers AS p2
ON p1.continent = p2.continent AND p1.country <> p2.country
LIMIT 14;

