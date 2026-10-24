# 🚀 Space Launch Data Analysis

An end-to-end data analytics project exploring global orbital launch trends, country contributions, launch vehicle performance, and mission success rates from 1957 to 2026.

## 📌 Project Overview

Space exploration has evolved significantly over the decades. This project analyzes historical orbital launch records to understand how launch activity has changed over time, which countries contribute the most launches, and how mission success rates have evolved.

The project combines Python, SQL, SQLite, and data visualization to transform raw launch records into meaningful insights.

## 🎯 Objectives

- Analyze global space launch trends over time.
- Compare launch activity across countries.
- Examine launch vehicle families and launch sites.
- Evaluate mission success rates by decade.
- Analyze SpaceX's launch activity and contribution.
- Present findings through interactive dashboards and visualizations.

## 🛠️ Tools & Technologies

- **Python** — Data cleaning and processing
- **Pandas** — Data manipulation and transformation
- **SQL** — Analytical queries and aggregations
- **SQLite** — Structured data storage
- **Tableau** — Data visualization and dashboarding
- **HTML & JavaScript** — Interactive web dashboard
- **CSV** — Data exchange and analysis exports

## 📊 Key Findings

- **7,052 launch records** were processed, covering 1957–2026.
- The USSR / Russia accounted for 3,283 launches, approximately 46.6% of the dataset.
- The United States recorded 2,274 launches, approximately 32.2%.
- China recorded 750 launches, approximately 10.6%.
- The R-7 vehicle family recorded 1,925 launches.
- Falcon 9 recorded 628 launches, with 625 successful launches and an observed success rate of approximately 99.5%.
- The recorded launch success rate increased from approximately 36.5% in the 1950s to around 95.2% in the 2020s.

*Note: The 2020s represent a partial decade, and 2026 is an incomplete year in the dataset. Results depend on the available source records and classification rules.*

## 📈 Dashboards

This project includes:
- A Tableau dashboard for visual exploration of launch data.
- An HTML dashboard presenting key trends and analytical results.

**Dashboard screenshots:** Add screenshots here so visitors can preview your visualizations directly from this repository.

## 📂 Project Structure

```text
space-launch-data-analysis/
├── data/
│   ├── raw/
│   └── processed/
├── sql/
│   └── analysis.sql
├── tableau_exports/
├── clean_and_load.py
├── run_sql.py
├── build_dashboard.py
├── dashboard.html
├── dashboard_template.html
├── TABLEAU_GUIDE.md
├── README.md
└── run_log.txt
```

## ⚙️ How to Run

### 1. Clone the repository

```bash
git clone https://github.com/meghawwk/space-launch-data-analysis.git
cd space-launch-data-analysis
```

### 2. Install the required Python packages

Check the imports in the project scripts and install any missing dependencies. For example:

```bash
pip install pandas
```

### 3. Process the raw data

```bash
python clean_and_load.py
```

### 4. Run the SQL analyses

```bash
python run_sql.py
```

### 5. Generate the HTML dashboard

```bash
python build_dashboard.py
```

Open `dashboard.html` in your web browser to view the dashboard.

*Ensure the raw data files and other required project files are available in their expected folders before running the scripts.*

## 💡 Skills Demonstrated

- Data cleaning and preprocessing
- Exploratory data analysis
- SQL querying and aggregation
- Relational data storage using SQLite
- Trend and performance analysis
- Data visualization and dashboard development
- Analytical storytelling

## 🔮 Future Improvements

- Add more detailed launch vehicle reliability analysis.
- Explore launch frequency trends by country and organization.
- Add filters for country, year, and vehicle family.
- Automate data updates and dashboard refreshes.
- Publish a live version of the web dashboard.

## 👩‍💻 Author

**Megha VK**

GitHub: [@meghawwk](https://github.com/meghawwk)

---

*Built to explore historical space launch data and turn records into actionable analytical insights.*
