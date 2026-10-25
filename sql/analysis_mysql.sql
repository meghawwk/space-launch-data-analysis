-- SPACE LAUNCH ANALYSIS --
-- DATA: orbital_launches_clean.csv
-- NOTE: 2026 is partial yr.

-- ------PART 1: DATABASE AND TABLE --------
CREATE DATABASE IF NOT EXISTS space_launch_db;
use space_launch_db;

drop table if exists orbital_launches;
create table orbital_launches(
	launch_tag		varchar(20),
    launch_date		varchar(30),
    launch_year		int,
    lv_type			varchar(60),
    lv_family		varchar(40),
    lv_manufacturer varchar(40),
    agency			varchar(30),
    country			varchar(40),
    launch_site		varchar(20),
    site_name		varchar(40),
    site_state		varchar(10),
    launchcode		varchar(10),
    outcome			varchar(10),
    category		varchar(30)
);

-- ------PART 2: LOAD THE CSV ----------

set global local_infile=1;
load data local infile "C:/Users/Elitebook/OneDrive/Desktop/MEGHA/Space launch proj/space_launch_project/space-project/data/processed/orbital_launches_clean.csv"
into table orbital_launches
fields terminated by "," optionally enclosed by '"' 
lines terminated by "\n"
ignore 1 lines
(launch_tag, launch_date, launch_year, lv_type, lv_family, lv_manufacturer, agency, country,
 launch_site, @site_name, @site_state, launchcode, outcome, @category)
 SET site_name  = NULLIF(@site_name, ''),
    site_state = NULLIF(@site_state, ''),
    category   = TRIM(TRAILING '\r' FROM @category);
    
select count(*) as total_rows, min(launch_year) as first_year, max(launch_year) as last_year
from orbital_launches;

-- ------PART 3: ANALYSIS QUERIES -------

-- Q1. Launches per year: volume, outcomes, success rate, year-over-year change
-- ----------------------------------------------------------------------------
WITH yearly as(
	select launch_year,
		count(*)										   as launches,
        sum(case when outcome="Success" then 1 else 0 end) as successes,
        sum(case when outcome="Failure" then 1 else 0 end) as failures
	from orbital_launches
    group by launch_year
)
select launch_year, launches, successes, failures,
round(100.0 * successes/launches, 1) 					as success_rate_pct,
launches-LAG(launches) over (order by launch_year) 		as yoy_change,
case when launch_year=2026 then 1 else 0 end 			as is_partial_year
from yearly
order by launch_year;

-- Q2. Launches and reliability by country (all-time)
-- --------------------------------------------------
SELECT country,
count(*) 																		as launches,
sum(case when outcome="Success" then 1 else 0 end) 								as successes,
round(100.0 * sum(case when outcome="Success" then 1 else 0 end) / count(*), 1) as success_rate_pct,
min(launch_year) 																as first_launch_year,
round(100.0 * count(*) / (select count(*) from orbital_launches), 1) 			as share_of_all_pct
FROM orbital_launches
GROUP BY country
ORDER BY launches DESC;

-- Q3. Country share of launches by decade
-- ----------------------------------------
WITH d as (
select (launch_year DIV 10)*10 as decade, country, count(*) as launches
from orbital_launches
group by (launch_year DIV 10)*10, country
)
SELECT decade, country, launches,
round(100.0 * launches / sum(launches) over (partition by decade), 1) as share_of_decade_pct
FROM d 
ORDER BY decade, launches DESC;

-- Q4. Launch vehicle families: workload and reliability (min 25 launches)
-- -----------------------------------------------------------------------
SELECT lv_family,
count(*) as launches,
sum(case when outcome="Success" then 1 else 0 end) as successes,
round(100.0 * sum(case when outcome="Success" then 1 else 0 end) / count(*), 1) as success_rate_pct,
min(launch_year) as first_year,
max(launch_year) as last_year
FROM orbital_launches
GROUP BY lv_family
HAVING COUNT(*)>=25
ORDER BY launches DESC;

-- Q5. Busiest launch sites
-- ------------------------
SELECT coalesce(site_name, launch_site) as launch_site,
count(*) as launches,
round(100.0 * sum(case when outcome="Success" then 1 else 0 end) / count(*), 1) as success_rate_pct,
min(launch_year) as first_year,
max(launch_year) as last_year
FROM orbital_launches
GROUP BY coalesce(site_name, launch_site)
ORDER BY launches DESC
LIMIT 15;

-- Q6. The modern era: launches per year by country, 2015 onward
-- -------------------------------------------------------------
SELECT launch_year, country, count(*) as launches
FROM orbital_launches
WHERE launch_year>=2015
GROUP BY launch_year, country
ORDER BY launch_year, launches DESC;

-- Q7. Success rate by decade
-- --------------------------
SELECT (launch_year DIV 10) * 10 as decade,
count(*) as launches,
round(100.0 * sum(case when outcome="Success" then 1 else 0 end) / count(*), 1) as success_rate_pct
FROM orbital_launches
GROUP BY (launch_year DIV 10) *10
ORDER BY decade;

-- Q8. SpaceX share of all orbital launches per year since 2010 (agency code SPX)
-- -------------------------------------------------------------------------------
SELECT launch_year,
count(*) as total_launches,
sum(case when agency="SPX" then 1 else 0 end) as spacex_launches,
round(100.0 * sum(case when agency="SPX" then 1 else 0 end) / count(*), 1) as spacex_share_pct
FROM orbital_launches
WHERE launch_year>=2010
GROUP BY launch_year
ORDER BY launch_year;



