use PortfolioProject;
select location,date,total_cases,new_cases,total_deaths,population
from coviddeaths
order by 1,2;


-- looking at total cases vs total deaths
select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where location like '%states%'
order by 1,2;

-- look at countries highest infection rate compared to population
Select location, population, MAX(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as HighestPercentagePopulationInfected
From coviddeaths
group by location, population
order by HighestPercentagePopulationInfected desc;


-- showing coutries with highest death count per population
Select location, max(total_deaths) as TotalDeathCount
From coviddeaths
Where continent is not null
Group by location, population
Order by TotalDeathCount desc;


-- showing the continent with highest death count
Select location, max(total_deaths) as TotalDeathCount
From coviddeaths
Where continent is not null
Group by location
Order by TotalDeathCount desc;

-- global numbers
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From coviddeaths
-- Where location like '%states%'
where continent is not null 
-- Group By date
order by 1,2;

-- Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From coviddeaths dea
Join covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not NULL
order by 2,3;
    
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From coviddeaths dea
Join covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;

-- use  CTE
With Pop_vs_Vac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From coviddeaths dea
Join covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3
)

Select *, (RollingPeopleVaccinated/Population)*100
From Pop_vs_Vac;


-- create view to store data for later visualization
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From coviddeaths dea
Join covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null;









