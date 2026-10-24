-- Space Launch Analysis | source: GCAT (J. McDowell) orbital launches, 1957 - 24 Apr 2026
-- NOTE: 2026 is a partial year (data ends 24 Apr 2026) -> flagged, excluded from rate comparisons.

-- Q1. Launches per year: volume, outcomes, success rate, year-over-year growth
-- name: launches_by_year
WITH yearly AS (
    SELECT launch_year,
           COUNT(*)                                        AS launches,
           SUM(outcome = 'Success')                        AS successes,
           SUM(outcome = 'Failure')                        AS failures
    FROM orbital_launches
    GROUP BY launch_year
)
SELECT launch_year, launches, successes, failures,
       ROUND(100.0 * successes / launches, 1)                          AS success_rate_pct,
       launches - LAG(launches) OVER (ORDER BY launch_year)            AS yoy_change,
       CASE WHEN launch_year = 2026 THEN 1 ELSE 0 END                  AS is_partial_year
FROM yearly
ORDER BY launch_year;

-- Q2. Launches and reliability by country (all-time)
-- name: launches_by_country
SELECT country,
       COUNT(*)                                           AS launches,
       SUM(outcome = 'Success')                           AS successes,
       ROUND(100.0 * SUM(outcome = 'Success') / COUNT(*), 1) AS success_rate_pct,
       MIN(launch_year)                                   AS first_launch_year,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM orbital_launches), 1) AS share_of_all_pct
FROM orbital_launches
GROUP BY country
ORDER BY launches DESC;

-- Q3. Country share of launches by decade (shows the shift in who launches)
-- name: country_share_by_decade
WITH d AS (
    SELECT (launch_year / 10) * 10 AS decade, country, COUNT(*) AS launches
    FROM orbital_launches
    GROUP BY decade, country
)
SELECT decade, country, launches,
       ROUND(100.0 * launches / SUM(launches) OVER (PARTITION BY decade), 1) AS share_of_decade_pct
FROM d
ORDER BY decade, launches DESC;

-- Q4. Launch vehicle families: workload and reliability (min 25 launches)
-- name: top_vehicle_families
SELECT lv_family,
       COUNT(*)                                           AS launches,
       SUM(outcome = 'Success')                           AS successes,
       ROUND(100.0 * SUM(outcome = 'Success') / COUNT(*), 1) AS success_rate_pct,
       MIN(launch_year)                                   AS first_year,
       MAX(launch_year)                                   AS last_year
FROM orbital_launches
GROUP BY lv_family
HAVING COUNT(*) >= 25
ORDER BY launches DESC;

-- Q5. Busiest launch sites
-- name: top_launch_sites
SELECT COALESCE(site_name, launch_site)                   AS launch_site,
       COUNT(*)                                           AS launches,
       ROUND(100.0 * SUM(outcome = 'Success') / COUNT(*), 1) AS success_rate_pct,
       MIN(launch_year)                                   AS first_year,
       MAX(launch_year)                                   AS last_year
FROM orbital_launches
GROUP BY COALESCE(site_name, launch_site)
ORDER BY launches DESC
LIMIT 15;

-- Q6. The modern era: launches per year by country, 2015 onward
-- name: recent_launches_by_country
SELECT launch_year, country, COUNT(*) AS launches
FROM orbital_launches
WHERE launch_year >= 2015
GROUP BY launch_year, country
ORDER BY launch_year, launches DESC;

-- Q7. Success rate by decade (reliability improvement over time)
-- name: success_rate_by_decade
SELECT (launch_year / 10) * 10 AS decade,
       COUNT(*) AS launches,
       ROUND(100.0 * SUM(outcome = 'Success') / COUNT(*), 1) AS success_rate_pct
FROM orbital_launches
GROUP BY decade
ORDER BY decade;

-- Q8. SpaceX share of all orbital launches, per year since 2010 (agency code SPX)
-- name: spacex_share
SELECT launch_year,
       COUNT(*) AS total_launches,
       SUM(agency = 'SPX') AS spacex_launches,
       ROUND(100.0 * SUM(agency = 'SPX') / COUNT(*), 1) AS spacex_share_pct
FROM orbital_launches
WHERE launch_year >= 2010
GROUP BY launch_year
ORDER BY launch_year;
