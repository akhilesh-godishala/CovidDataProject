SELECT continent,location,date,total_cases,new_cases,total_deaths,population
 FROM PortfolioProject.coviddeaths1
 where continent !=''
 order by 2,3;
 
 -- Identifying daily death rate i.e total cases vs total deaths
 -- Shows Likelihood of dying if you have contracted the virus in your country
 SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_rate_affected
 FROM PortfolioProject.coviddeaths1
 where location like '%India%' and continent !=''
 order by 1,2;
 
 -- total cases vs total population
 -- shows what percentage of the population has got covid
  SELECT location,date,total_cases,population,(total_cases/population)*100 as PerecentPopulationInfected
 FROM PortfolioProject.coviddeaths1
 where location like '%India%' and continent !=''
 order by 1,2;

  -- Displaying countries with highest Infection rates
SELECT location,population,max(total_cases)as HighestInfected,
(max(total_cases)/max(population))*100 as InfectionRate
FROM PortfolioProject.coviddeaths1
 where continent !=''
group by location,population
order by InfectionRate desc;

-- displaying countries with highest death count 
SELECT location, max(total_deaths)as TotalDeaths
FROM PortfolioProject.coviddeaths1
where continent !=''
group by location
order by TotalDeaths desc;

-- if you look at the data columns where continent is empty fro those records location value is the continent name
-- displaying continents with highest death count 
SELECT Location, max(total_deaths)as TotalDeaths
FROM PortfolioProject.coviddeaths1
where continent =''
group by Location
order by TotalDeaths desc;

SELECT Continent, max(total_deaths)as TotalDeaths
FROM PortfolioProject.coviddeaths1
where continent !=''
group by Continent
order by TotalDeaths desc;

-- Global Numbers

Select date, sum(new_cases) as total_cases , sum(new_deaths) as total_deaths,
(sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
from PortfolioProject.coviddeaths1
where continent!='' 
group by date
order by 1,2;

-- Global overall stats

Select sum(new_cases) as total_cases , sum(new_deaths) as total_deaths,
(sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
from PortfolioProject.coviddeaths1
where continent!='' ;

-- Identifying vaccinations till date location wise
SELECT dea.continent,dea.location,dea.date,dea.population,
cast(new_vaccinations as SIGNED INTEGER) as new_vaccinations, 
sum(cast(new_vaccinations as SIGNED INTEGER)) over(partition by dea.location order by dea.date) as vaccines_till_date
FROM PortfolioProject.coviddeaths1 dea
join PortfolioProject.covidvaccinations1 vac 
on dea.location=vac.location and dea.date=vac.date
where dea.continent!=''
order by 2,3;

-- Select percentage of people vaccinated vs population 
with cte as 
(SELECT dea.continent,dea.location,dea.date,dea.population,
cast(new_vaccinations as SIGNED INTEGER) as new_vaccinations, 
sum(cast(new_vaccinations as SIGNED INTEGER)) over(partition by dea.location order by dea.date) as vaccines_till_date
FROM PortfolioProject.coviddeaths1 dea
join PortfolioProject.covidvaccinations1 vac 
on dea.location=vac.location and dea.date=vac.date
where dea.continent!=''
order by 2,3)
Select *,(vaccines_till_date/population)* 100 as vaccination_perecntage from cte ;

-- creating a view for later visualization

create view  VaccinationsTillDate as
SELECT dea.continent,dea.location,dea.date,dea.population,
cast(new_vaccinations as SIGNED INTEGER) as new_vaccinations, 
sum(cast(new_vaccinations as SIGNED INTEGER)) over(partition by dea.location order by dea.date) as vaccines_till_date
FROM PortfolioProject.coviddeaths1 dea
join PortfolioProject.covidvaccinations1 vac 
on dea.location=vac.location and dea.date=vac.date
where dea.continent!='';

Select * from VaccinationsTillDate;











 
 
 
 
 
 