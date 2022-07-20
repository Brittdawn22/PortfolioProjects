Select *
From PortfolioProject1..CovidDeaths
Where continent is not null
Order by 3, 4

----Select *
----From PortfolioProject1..CovidVaccinations
----Order by 3, 4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject1..CovidDeaths
Order by 1, 2

Select Location, date, total_cases, population, (total_deaths/ total_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
Where location like '%states%'
Order by 1, 2

Select Location, population, Max(total_cases) as HighestInfectionAccount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject1..CovidDeaths
Group by Location, population
Order by PercentPopulationInfected desc

Select continent, MAX(Cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject1..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc

Select SUM(new_cases), SUM(Cast(new_deaths as int)), SUM(Cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
Where continent is not null
group by date
Order by 1, 2

 Select *
 From PortfolioProject1.. CovidDeaths dea
 Join PortfolioProject1..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date


 Select dea.continent, dea.location,dea.date, dea.population, dea.new_vaccinations,SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as VaccinationTotal, VaccinationTotal/ population) * 100
 From PortfolioProject1.. CovidDeaths dea
 Join PortfolioProject1..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
 order by 2,3

With PopvsVac (Continent, Location, Date, Population, New_vaccinations, VaccinationTotal)
as
(
 Select dea.continent, dea.location,dea.date, dea.population, dea.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as VaccinationTotal
 From PortfolioProject1.. CovidDeaths dea
 Join PortfolioProject1..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
 )
 Select*, (VaccinationTotal/ Population)* 100
 From PopvsVac

--TEMP TABLE
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
VaccinationTotal numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location,dea.date, dea.population, dea.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as VaccinationTotal
 From PortfolioProject1.. CovidDeaths dea
 Join PortfolioProject1..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 --Where dea.continent is not null
 Order by 2,3

 Select *,(VaccinationTotal/Population) *100
 From #PercentPopulationVaccinated

 Create View PercentPopulationVaccinated as
 Select dea.continent, dea.location,dea.date, dea.population, dea.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as VaccinationTotal
 From PortfolioProject1.. CovidDeaths dea
 Join PortfolioProject1..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
 --Order by 2,3


