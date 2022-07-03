select * from [covid project]..CovidDeaths$

select * from [covid project]..CovidVaccinations$
order by 1,2

--select the data we are going to use 
select location , date ,total_cases,new_cases,total_deaths,population    from [covid project]..CovidDeaths$
order by 1,2

--looking total cases versus total deaths 

select location , date ,total_cases,total_deaths, (total_deaths/total_cases)*100 as percenage_deaths_total_cases   from [covid project]..CovidDeaths$
order by 1,2


--looking total cases versus total deaths  in a certain country (egypt )
select location , date ,total_cases,total_deaths, (total_deaths/total_cases)*100 as percenage_deaths_total_cases   from [covid project]..CovidDeaths$
where location like '%egypt%'
order by 1,2


--looking at total cases vs population 
--looking at the total cases vs population in a ceratins country 
select location , date ,total_cases,population, (total_cases/population)*100 as percenage_population_total_cases   from [covid project]..CovidDeaths$
where location like '%egypt%'

--looking for the countried with hightest rates in terms of population 
select location ,max(total_cases) as total_cases,max(population) as population , (max(total_cases)/max(population))*100 as percenage_population_total_cases   from [covid project]..CovidDeaths$
group by location , population
order by percenage_population_total_cases desc

--showing countries with highest deaths count with population 
select
location ,max(total_deaths) as highestcountdeaths,max(population) as population , (max(total_deaths)/max(population))*100 as percentofdiedtopopulation 
from [covid project]..CovidDeaths$
group by location , population
order by percentofdiedtopopulation desc



--showing highest count of deaths per location 

select location , max(cast(total_deaths as int))  as maxcountofdeaths
from [covid project]..CovidDeaths$
where continent is not null
group by location
order by maxcountofdeaths desc

--showing highest couont of deaths per continent 
--showing the continent with the highest deaths cases
select continent , max(cast(total_deaths as int))  as maxcountofdeaths
from [covid project]..CovidDeaths$
where continent is not null
group by continent
order by maxcountofdeaths desc

--global numbers of daily affected and died 

select date ,sum(cast(total_cases as int)) as totalcasesglobally,sum(cast(total_deaths as int)) as totaldeathsglobally,(sum(cast(total_deaths as int))/sum(total_cases))*100 as deathpercenglobally
from [covid project]..CovidDeaths$
where continent is not null 
group by date
order by totalcasesglobally desc

--global new cases and new deaths daily 

select date ,sum(cast(new_cases as int)) as totalnewcasesglobally,sum(cast(new_deaths as int)) as totalnewdeathsglobally,(sum(cast(new_deaths as int))/sum(new_cases))*100 as newdeathpercenglobally
from [covid project]..CovidDeaths$
where continent is not null 
group by date
order by date desc

---showing global number of total cases and total deaths and percen

select sum(cast(new_cases as int)) as totalnewcasesglobally,sum(cast(new_deaths as int)) as totalnewdeathsglobally,(sum(cast(new_deaths as int))/sum(new_cases))*100 as newdeathpercenglobally
from [covid project]..CovidDeaths$
where continent is not null 
--group by date
--order by date desc


--join deaths table with vaccination 
 
 select * from [covid project]..CovidVaccinations$ as vac
 join [covid project]..CovidDeaths$ as dea
 on vac.location=dea.location
 and vac.date=dea.date

 --shwoing the data will be used 

  select dea.continent, dea.location ,dea.date,vac.total_vaccinations as int
  from [covid project]..CovidVaccinations$ as vac
 join [covid project]..CovidDeaths$ as dea
 on vac.location=dea.location
 and vac.date=dea.date
 --group by location 

 --total population vs percentage of vacccinated (new vacinated ) 
  -- vacinated daily on a certain country 

 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
 from [covid project]..CovidDeaths$ as dea
 join [covid project]..CovidVaccinations$ as vac
 on dea.location=vac.location and dea.date=vac.date
 where dea.continent is not null and dea.location like '%cana%'
 order by 1,2,3

 --total vacinated per country 


  select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over(PARTITION by dea.location order by
  dea.location,dea.date) as totalvacinated ,--(sum(convert(int,vac.new_vaccinations)) over(PARTITION by dea.location order by
  dea.location,dea.date)/dea.population)*100 as average
 from [covid project]..CovidDeaths$ as dea
 join [covid project]..CovidVaccinations$ as vac
 on dea.location=vac.location and dea.date=vac.date
 where dea.continent is not null and vac.new_vaccinations is not null

 order by 1,2

 ---use with to give same result(average of people who are vaccinated on each country ) 
with support(continent,location,date,population,new_vaccinations,totalvacinated) as
(select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over(PARTITION by dea.location order by
  dea.location,dea.date) as totalvacinated 
 from [covid project]..CovidDeaths$ as dea
 join [covid project]..CovidVaccinations$ as vac
 on dea.location=vac.location and dea.date=vac.date
 where dea.continent is not null and vac.new_vaccinations is not null)
 select *,(totalvacinated/population)*100 as average from support

--create view of certian columns 

create view vaccinatedpop as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over(PARTITION by dea.location order by
  dea.location,dea.date) as totalvacinated 
 from [covid project]..CovidDeaths$ as dea
 join [covid project]..CovidVaccinations$ as vac
 on dea.location=vac.location and dea.date=vac.date
 where dea.continent is not null and vac.new_vaccinations is not null


 -- the created viewed table showing 
 select * from vaccinatedpop


 




 


























