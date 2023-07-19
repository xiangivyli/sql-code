-- Check the whole table

SELECT *
FROM [PortfolioProject].[dbo].[CovidDeathsCountry]
ORDER BY date;

-- Check special rows where location is not country
SELECT *
FROM [PortfolioProject].[dbo].[CovidDeathsCountry]
WHERE continent IS NULL
ORDER BY total_deaths;

-- Step1.1: Delete rows where total_deaths or continent is null

DELETE FROM [PortfolioProject].[dbo].[CovidDeathsCountry]
WHERE total_deaths IS NULL OR continent IS NULL;

-- Step1.2: Delete columns that are not used in the final version

ALTER TABLE [PortfolioProject].[dbo].[CovidDeathsCountry]
DROP COLUMN continent;

-- Step2: Alter datatype

ALTER TABLE [PortfolioProject].[dbo].[CovidDeathsCountry]
ALTER COLUMN total_deaths BIGINT;

-- Step3: Add columns world_deaths 

ALTER TABLE [PortfolioProject].[dbo].[CovidDeathsCountry]
ADD world_deaths BIGINT;

UPDATE [PortfolioProject].[dbo].[CovidDeathsCountry]
SET world_deaths = subquery.sum_deaths
FROM (
    SELECT date, SUM(total_deaths) AS sum_deaths
    FROM [PortfolioProject].[dbo].[CovidDeathsCountry]
    GROUP BY date
) AS subquery
WHERE [PortfolioProject].[dbo].[CovidDeathsCountry].date = subquery.date;


-- Double check if there is redundant data
SELECT *
FROM [PortfolioProject].[dbo].[CovidDeathsCountry]
ORDER BY date;


