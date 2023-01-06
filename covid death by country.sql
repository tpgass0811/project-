
Select *
From [project ].dbo.CovidVaccinations$
order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From [project ].dbo.CovidDeaths$
Where continent is not null 
order by 1,2

 --Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [project ].dbo.CovidDeaths$
Where location like '%states%'
and continent is not null 
order by 1,2

-- Countries with Highest Infection Rate compared to Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [project ].dbo.CovidDeaths$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- Showing contintents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [project ].dbo.CovidDeaths$
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [project ].dbo.CovidDeaths$ dea
Join [project ]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

