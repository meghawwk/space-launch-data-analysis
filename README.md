# Space Launch Data Analysis (1957 – April 2026)

**Tools:** SQL (SQLite), Python (Pandas), Tableau Public (dashboard build, see TABLEAU_GUIDE.md)
**Data:** Jonathan McDowell's GCAT launch catalog (public): 7,052 orbital launch attempts, 1957 to 24 Apr 2026.

## Business questions
1. How has launch volume and reliability changed over time?
2. Which countries and launch vehicles carry the load?
3. How much has SpaceX changed the market?

## Method
1. `clean_and_load.py`: parse raw GCAT TSVs, keep orbital launches, flag success/failure from launch codes (OS / OF), map agency and launch site to country, load to SQLite.
2. `sql/analysis.sql`: 8 queries using CTEs, window functions (LAG, SUM OVER PARTITION), conditional aggregation, HAVING.
3. `run_sql.py`: runs the queries and exports clean CSVs to `tableau_exports/` for Tableau.
4. `build_dashboard.py`: builds the HTML dashboard preview.

## Key findings
- **Volume:** 325 launches in 2025, the record year and 3.8x the 85 in 2015.
- **Reliability:** success rate rose from 36.5% in the 1950s and 82.8% in the 1960s to roughly 93-95% from the 1970s on; all-time 92.6%.
- **Who launches:** the US held 84.6% of 1950s launches, the USSR 74.4% of 1970s launches. In the 2020s the US has 47.5% and China 30.7%.
- **SpaceX:** from 2.8% of launches in 2010 to 52.7% in 2024 and 51.4% in 2025 (167 of 325).
- **Vehicles:** the Falcon 9 family has 628 launches at a 99.5% success rate, the highest among the 10 busiest families. The R-7 (Soyuz) family leads on volume with 1,925.

## Data quality notes and limitations
- 2026 is a partial year (to 24 Apr), flagged in the data and excluded from rate comparisons.
- Country is the launch provider's country; USSR and Russia are combined. Arianespace launches from Kourou appear under France. Rocket Lab appears as New Zealand.
- 16 launches coded "Other" count as neither success nor failure.
- Success rates for countries with few launches (Iran, the Koreas) are noisy.
