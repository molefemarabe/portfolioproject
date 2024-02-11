--Looking at the Total Cases vs Total Deaths
--Shows the likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float)) * 100 as DeathPercentage
from coviddeaths
order by location, date

--Shows the likelihood of dying if you contract covid in South Africa
Select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float)) * 100 as DeathPercentage
from coviddeaths
where location = 'South Africa'
order by date

--Shows what percentage of the population has gotten Covid
Select location, date, total_cases, population, (cast(total_cases as float)/population * 100) as PopulationInfectedPercent
from coviddeaths
where location = 'South Africa'
and continent is not null
order by date

--Countries with the highest infection rates compared to their population
Select location, population, max(cast(total_cases as float)) as HighestInfectionCount, (max(cast(total_cases as float)/population)) * 100 as PopulationInfectedPercent
from coviddeaths
where continent is not null
Group by location, population
order by  PopulationInfectedPercent desc

--Countries with the highest death count
Select location, max(cast(total_deaths as float)) as TotalDeathCount
from coviddeaths
where continent is not null
Group by location
order by  TotalDeathCount desc

--Continents with the highest death count)
Select continent, max(cast(total_deaths as float)) as TotalDeathCount
from coviddeaths
where continent is not null
Group by continent
order by  TotalDeathCount desc

---------CONTINENT BREAKDOWN (HIGHEST DEATH COUNT)

--African Countries with the highest death count
Select location, max(cast(total_deaths as float)) as TotalDeathCount
from coviddeaths
where continent like 'Africa'
Group by location
order by  TotalDeathCount desc

--North American Countries with the highest death count
Select location, max(cast(total_deaths as float)) as TotalDeathCount
from coviddeaths
where continent like 'North America'
Group by location
order by  TotalDeathCount desc

--South American Countries with the highest death count
Select location, max(cast(total_deaths as float)) as TotalDeathCount
from coviddeaths
where continent like 'South America'
Group by location
order by  TotalDeathCount desc

--European Countries with the highest death count
Select location, max(cast(total_deaths as float)) as TotalDeathCount
from coviddeaths
where continent like 'Europe'
Group by location
order by  TotalDeathCount desc

--Asian Countries with the highest death count
Select location, max(cast(total_deaths as float)) as TotalDeathCount
from coviddeaths
where continent like 'Asia'
Group by location
order by  TotalDeathCount desc

--Oceanic Countries with the highest death count
Select location, max(cast(total_deaths as float)) as TotalDeathCount
from coviddeaths
where continent like 'Oceania'
Group by location
order by  TotalDeathCount desc

----------END OF CONTINENT BREAK DOWN

--Global numbers
select 
	date, sum(cast(new_cases as float)) as Total_Cases, 
	sum(cast(new_deaths as float)) as Total_Deaths, 
	(sum(cast(new_deaths as float))/sum(cast(new_cases as float))) * 100 as DeathPercentage
from coviddeaths
where continent is not null
group by date
order by 1,2

--Total death percentage acroos the world
select 
	 sum(cast(new_cases as float)) as Total_Cases, 
	sum(cast(new_deaths as float)) as Total_Deaths, 
	(sum(cast(new_deaths as float))/sum(cast(new_cases as float))) * 100 as DeathPercentage
from coviddeaths
where continent is not null
order by 1,2


--Shows the Total Population vs Vaccinations

--CTE
with PopulationVsVAccination (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) as
	(
	select deaths.continent, deaths.location, deaths.date, deaths.population, vacc.new_vaccinations,
		sum(cast(vacc.new_vaccinations as float)) over (partition by deaths.location order by deaths.location, deaths.date) as RollingPeopleVaccinated
	from coviddeaths deaths
	join covidvaccinations vacc
	on deaths.location = vacc.location
	and deaths.date = vacc.date
	where deaths.continent is not null
	)

select *, (RollingPeopleVaccinated/population) *100
from PopulationVsVAccination

--CREATING VIEW TO STORE DATA FOR VISUALIZATIONS

Create view PercentPopulationVAccinated as
Select deaths.continent, deaths.location, deaths.date, deaths.population, vacc.new_vaccinations,
		sum(cast(vacc.new_vaccinations as float)) over (partition by deaths.location order by deaths.location, deaths.date) as RollingPeopleVaccinated
	from coviddeaths deaths
	join covidvaccinations vacc
	on deaths.location = vacc.location
	and deaths.date = vacc.date
	where deaths.continent is not null
	