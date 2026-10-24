"""Step 2: run every query in sql/analysis.sql and export CSVs for Tableau."""
import re, sqlite3, pandas as pd
con = sqlite3.connect("data/processed/space.db")
text = open("sql/analysis.sql").read()
for block in re.split(r"\n(?=-- Q\d)", text)[1:]:
    name = re.search(r"-- name: (\w+)", block).group(1)
    df = pd.read_sql_query(block, con)
    df.to_csv(f"tableau_exports/{name}.csv", index=False)
    print(f"\n=== {name} ({len(df)} rows) ===")
    print(df.head(12).to_string(index=False))
