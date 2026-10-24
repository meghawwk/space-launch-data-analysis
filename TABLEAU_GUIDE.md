# Build the dashboard in Tableau Public (about 30 minutes)
Download Tableau Public (free). Connect to Text file and add these files from `tableau_exports/`.

1. **Launches per year** (launches_by_year.csv): Columns = launch_year; Rows = successes and failures (Measure Values, stacked bar). Exclude or annotate 2026 (is_partial_year = 1).
2. **Share by decade** (country_share_by_decade.csv): Columns = decade; Rows = SUM(share_of_decade_pct); Color = country. Use a filter to keep the top 5 countries.
3. **SpaceX share** (spacex_share.csv): line chart of spacex_share_pct by launch_year.
4. **Vehicle families** (top_vehicle_families.csv): horizontal bar of launches by lv_family, color by success_rate_pct.
5. Add 3 to 4 KPI text tiles (total launches, success rate, record year, SpaceX share).
6. Combine the sheets on one Dashboard, add a launch_year range filter that applies to relevant sheets, then File > Save to Tableau Public and paste the link on your resume and portfolio.
