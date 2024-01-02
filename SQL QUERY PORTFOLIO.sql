SELECT * 
FROM CovidVaccinations$
WHERE continent IS NOT NULL
ORDER BY 3,4;

SELECT * FROM 
CovidData$
WHERE continent IS NOT NULL
ORDER BY 3,4;

SELECT  location, date, total_cases, new_cases, total_deaths, population, total_cases_per_million
FROM [dbo].[CovidData$]
WHERE continent IS NOT NULL
ORDER BY 1, 2;

SELECT  location, date, total_cases, total_deaths, total_cases_per_million, (total_deaths/total_cases) * 100 as totalpercentage
FROM [dbo].[CovidData$]
WHERE location like '%Africa%'
AND continent IS NOT NULL
ORDER BY 1, 2;

SELECT  location, date, total_cases, population, total_cases_per_million, (total_cases/population) * 100 as totalpopulationpercentage
FROM [dbo].[CovidData$]
WHERE location like '%Africa%'
AND continent IS NOT NULL
ORDER BY 1, 2;

SELECT  location, MAX(total_cases) as highestcount,  
MAX(total_deaths/total_cases) * 100 as highestpercentageinfectioncount
FROM [dbo].[CovidData$]
--WHERE location like '%Africa%'
GROUP BY location, population
ORDER BY  highestpercentageinfectioncount DESC;

SELECT  location,  MAX(cast(total_deaths as INT)) AS totaldeathcount
FROM [dbo].[CovidData$]
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY totaldeathcount DESC;

SELECT  continent, MAX(cast(total_deaths as INT)) AS totaldeathcount
FROM [dbo].[CovidData$]
WHERE continent IS  NOT NULL
GROUP BY  continent
ORDER BY totaldeathcount DESC;

SELECT  SUM(new_cases) AS totalCases, SUM(cast(new_deaths AS INT)) AS newDeaths, SUM(cast(new_deaths AS INT))/SUM(new_cases) * 100 as totalpercentage
FROM [dbo].[CovidData$]
--WHERE location like '%Africa%'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2;

SELECT * 
FROM [dbo].[CovidData$] dat
JOIN [dbo].[CovidVaccinations$] vac
	ON dat.location = vac.location
	AND dat.date = vac.date;

--USING CTEs: Common Table Expressions

WITH PopvsVacc (continent, location, date, population, new_vaccinations, roll_people_vaccinated)
as 
(
SELECT dat.continent, dat.location, dat.date, dat.population, vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dat.location order by dat.location, dat.date) 
	as roll_people_vaccinated
	--(roll_people_vaccinated/population) * 100
FROM [dbo].[CovidData$] dat
JOIN [dbo].[CovidVaccinations$] vac
	ON dat.location = vac.location
	AND dat.date = vac.date
WHERE dat.continent IS NOT NULL
--AND dat.location  like '%Albania%'
)

SELECT *, (roll_people_vaccinated/population)*100 
FROM  PopvsVacc;

CREATE VIEW PopvsVacc AS
SELECT dat.continent, dat.location, dat.date, dat.population, vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dat.location order by dat.location, dat.date) 
	as roll_people_vaccinated
	--(roll_people_vaccinated/population) * 100
FROM [dbo].[CovidData$] dat
JOIN [dbo].[CovidVaccinations$] vac
	ON dat.location = vac.location
	AND dat.date = vac.date
WHERE dat.continent IS NOT NULL


--USING TEMP-TABLES	
DROP TABLE IF EXISTS Population_Vaccinated_Percentage
CREATE TABLE Population_Vaccinated_Percentage
(continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations numeric,
	roll_people_vaccinated numeric
)

INSERT INTO  Population_Vaccinated_Percentage
SELECT dat.continent, dat.location, dat.date, dat.population, vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dat.location order by dat.location, dat.date) 
	as roll_people_vaccinated
	--(roll_people_vaccinated/population) * 100
FROM [dbo].[CovidData$] dat
JOIN [dbo].[CovidVaccinations$] vac
	ON dat.location = vac.location
	AND dat.date = vac.date
WHERE dat.continent IS NOT NULL

SELECT *, (roll_people_vaccinated/population)*100 
FROM  Population_Vaccinated_Percentage;
 
CREATE VIEW Population_Vaccinated_Percentage AS
SELECT dat.continent, dat.location, dat.date, dat.population, vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dat.location order by dat.location, dat.date) 
	as roll_people_vaccinated
	--(roll_people_vaccinated/population) * 100
FROM [dbo].[CovidData$] dat
JOIN [dbo].[CovidVaccinations$] vac
	ON dat.location = vac.location
	AND dat.date = vac.date
WHERE dat.continent IS NOT NULL

SELECT * 
FROM Population_Vaccinated_Percentage;


SELECT COUNT(*)
FROM [dbo].[CovidVaccinations$];

SELECT COUNT(*)
FROM [dbo].[CovidData$];