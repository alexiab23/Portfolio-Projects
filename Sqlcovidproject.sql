--Step 1: Import csv file into PostgreSql
Select * From public.coviddeaths
Where continent is not null

Select * From public.covidvaccinations

--Great! Now that both tables were imported correctly we can move on.

Select location, date, total_cases, new_cases, total_deaths, population
From public.coviddeaths
Where continent is not null


--Looking at total case vs total deaths

Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From public.coviddeaths
Where continent is not null


--Essentially what this is saying is that at line 29 for Afghanistan, when there were 40 covid cases but 1 person died, the death percentage was 2.5% or a 2.5% chance of dying
--Likelyhood of dying if you contract covid in your country
--Now let's look at America's data 

Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From public.coviddeaths
WHERE location LIKE '%States'and continent is not null


--Looking at total cases vs population to geta another understanding of how covid affected different countries
--Shows what percentage of population got covid

Select location, date, population, total_cases,(total_cases/population)*100 as PercentPopulationInfected
From public.coviddeaths
WHERE location LIKE '%States'and continent is not null


--Let's look at line 953 where there is 336,997,624 people in America and 94,556,155 was confirmed to have covid in August 31, 2022. That is some staggering numbers!

--What country has the highest infection rates compared to the population?
--BELOW WILL BE GRAPH 3

Select location, population, MAX (total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From public.coviddeaths
Where location not in ('High income', 'Upper middle income', 'Lower middle income', 'Low income')
Group by location, population
Order BY PercentPopulationInfected desc

--

--THIS WILL BE GRAPH 4

Select location, population, date, MAX (total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From public.coviddeaths
Where location not in ('High income', 'Upper middle income', 'Lower middle income', 'Low income')
Group by location, population, date
Order by PercentPopulationInfected desc

--Line 22 you can see Denmark having 56% of the population infected. That's more than half of the entire population!

--Now let us look at countries with the highest death count per population

Select location, MAX(total_deaths) as TotalDeathCount
From public.coviddeaths
Where location is not null 
Group by location
Order BY TotalDeathCount desc

--This will be Graph 2

Select location, SUM(new_deaths) as TotalDeathCount
From public.coviddeaths
Where continent is null 
And location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income', 'International')
Group by location
Order BY TotalDeathCount desc


--Let's look at the data from the continent's perspective

Select continent, MAX(total_deaths) as TotalDeathCount
From public.coviddeaths
Where continent is not null
Group by continent 
Order BY TotalDeathCount desc

--Calculate gobal numbers

Select date, SUM(new_cases)-- as TotalDeathCount
From public.coviddeaths
Where continent is not null
Group by date 
Order By date

--lets do total cases and total deaths per day

Select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 
SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From public.coviddeaths
Where continent is not null
Group by date 
Order By date

--Line 23 is where the numbers starts to display 100 cases across the world and having just 1 death at the time which then led to the deathpercentage across the globe to be just 1%


--Lets look at how many people had covid across the world altogether and how many people died from this. 
--This will be FIRST GRAPH 1!

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 
SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From public.coviddeaths
Where continent is not null

--Now let us get more advanced and include the covid vaccinations table. We will do a JOIN on both tables

Select * From public.coviddeaths dea
INNER JOIN public.covidvaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date

--Perfect! Now we will look at toal population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
From public.coviddeaths dea
INNER JOIN public.covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null 
Order By 2,3

--Now let us specify a country and see when vaccinations became available -> like canada for example
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
From public.coviddeaths dea
INNER JOIN public.covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null and dea.location LIKE 'Can%'
Order By 2,3

--lets get even more advanced -> this will then start adding how many people got vaccinated on a whole as the days pass by 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION by dea.location )
From public.coviddeaths dea
INNER JOIN public.covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null 
Order By 2,3

--Lets look at the country of Jamaica

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION by dea.location )
From public.coviddeaths dea
INNER JOIN public.covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null and dea.location LIKE 'Jama%'
Order By 2,3

--

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
, --(RollingPeopleVaccinated/dea.population)*100
From public.coviddeaths dea
INNER JOIN public.covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null and dea.location LIKE 'Jama%'
Order By 2,3

-- USE CTE (seeing how much percent of the population is vaccinated)

With PopvsVac (Continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION by dea.location ORDER by dea.location, dea.date) 
	as RollingPeopleVaccinated
From public.coviddeaths dea
INNER JOIN public.covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac

--TEMPORARY TABLE -- EDIT OUT

Create Table PercentPopulationVaccinated (
Continent text,
Location text,
Date date,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO PercentPopulationVaccinated (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
Select public.coviddeaths.continent, public.coviddeaths.location, public.coviddeaths.date, public.coviddeaths.population, public.covidvaccinations.new_vaccinations,
	SUM(public.covidvaccinations.new_vaccinations) OVER (PARTITION by public.coviddeaths.location ORDER by public.coviddeaths.location, public.coviddeaths.date) 
	as RollingPeopleVaccinated
From public.coviddeaths 
INNER JOIN public.covidvaccinations 
	ON public.coviddeaths.location = public.covidvaccinations.location
	AND public.coviddeaths.date = public.covidvaccinations.date
Where public.coviddeaths.continent is not null 

Select *, (RollingPeopleVaccinated/population)*100
From PercentPopulationVaccinated


Select * From public.percentpopulationvaccinated


--End of edit out segment

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION by dea.location Order by dea.location, dea.date) 
	as RollingPeopleVaccinated
From public.coviddeaths dea
INNER JOIN public.covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null 
Order By 2,3



