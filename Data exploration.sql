


Select * From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select * From PortfolioProject ..CovidVaccinations
--order by 3,4

--select data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths,population 
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


--Look at Total Cases vs Total Deaths

--shows likelihood of dying if you are in states
Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2


--Looking at Total Cases vs Population
--what percentage of population got covid
Select location, date,population ,total_cases,(total_cases/population)*100 as PercentagePopulationInfected
From PortfolioProject..CovidDeaths
where continent is not null
--Where location like '%states%'
order by 1,2


--Looking at country with highest infection rate compared to population

Select location,population ,Max(total_cases) as HighestInfectionCount,Max((total_cases/population)*100) as 
PercentagePopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null
group by location, population
order by PercentagePopulationInfected desc

--showing countries with highest death count per population

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is  null
group by location
order by TotalDeathCount desc

--LET'S BREAK THING DOWN BY CONTINENT

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is  NOT null
group by continent
order by TotalDeathCount desc

--Showing the continent with highest Death count
select  sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by date
order by 1,2


--Looking at TOtal Population vs vaccination
with PopvsVac (Continent, Location, Date, Population,New_Vaccinations,RollingPeopleVaccinated)
as (
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated 
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by  2, 3
)
select *,(RollingPeopleVaccinated/Population)*100 from PopvsVac
--USE CTE above


--Temp Table

DROP Table IF exists #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated 
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by  2, 3

select *,(RollingPeopleVaccinated/Population)*100 from 
#PercentPopulationVaccinated


--creating view to store data for later visualization

Create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated 
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
--order by  2, 3




Select * 
from PercentPopulationVaccinated
