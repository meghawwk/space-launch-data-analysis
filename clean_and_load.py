"""Step 1: clean GCAT launch data and load it into SQLite so we can analyse it with SQL."""
import sqlite3
import pandas as pd

def read_gcat(path):
    # GCAT TSVs: row 0 = header (starts with '#'), row 1 = 'Updated ...' comment
    df = pd.read_csv(path, sep="\t", skiprows=[1], dtype=str, encoding="latin-1")
    df.columns = [c.lstrip("#").strip() for c in df.columns]
    return df.apply(lambda s: s.str.strip())

launch = read_gcat("data/raw/launch.tsv")
orgs   = read_gcat("data/raw/orgs.tsv")
sites  = read_gcat("data/raw/sites.tsv")
lv     = read_gcat("data/raw/lv.tsv")

# Keep ORBITAL launches only (LaunchCode starts with 'O'); OS* = success, OF* = failure, OE = other
o = launch[launch["LaunchCode"].str.startswith("O")].copy()
o["launch_year"] = o["Launch_Date"].str[:4].astype(int)
o["outcome"] = o["LaunchCode"].str[:2].map({"OS": "Success", "OF": "Failure"}).fillna("Other")

# Country of launch provider: Agency -> orgs.StateCode
state = orgs.drop_duplicates("Code").set_index("Code")["StateCode"]
# compound agencies like 'JSC/MSFC' -> try each part; then fall back to the launch SITE's country
def agency_state(a):
    for part in str(a).split("/"):
        if part in state.index:
            return state[part]
    return None
o["provider_state"] = o["Agency"].map(agency_state)
# Launch site -> site name + country
site_map = sites.drop_duplicates("Site").set_index("Site")
o["site_name"]  = o["Launch_Site"].map(site_map["ShortName"])
o["site_state"] = o["Launch_Site"].map(site_map["StateCode"])

o["provider_state"] = o["provider_state"].fillna(o["site_state"]).fillna("UNK")

# Friendly country names (merge USSR + Russia for a continuous series)
names = {"US": "United States", "SU": "USSR / Russia", "RU": "USSR / Russia", "CN": "China",
         "F": "France", "J": "Japan", "IN": "India", "I": "Italy", "UK": "United Kingdom",
         "IL": "Israel", "BR": "Brazil", "D": "Germany", "AU": "Australia", "CYM": "Sea Launch (Cayman-flagged)", "I-ESA": "Europe (ESA)", "I-ELDO": "Europe (ELDO)", "IR": "Iran", "KR": "South Korea", "KP": "North Korea",
         "NZ": "New Zealand (Rocket Lab)", "XX": "Multinational", "UNK": "Unknown"}
o["country"] = o["provider_state"].map(names).fillna(o["provider_state"])

o = o.merge(lv[["LV_Name", "LV_Family", "LV_Manufacturer"]].drop_duplicates("LV_Name"),
            how="left", left_on="LV_Type", right_on="LV_Name")
o["LV_Family"] = o["LV_Family"].fillna(o["LV_Type"])

cols = ["Launch_Tag", "Launch_Date", "launch_year", "LV_Type", "LV_Family", "LV_Manufacturer",
        "Agency", "country", "Launch_Site", "site_name", "site_state", "LaunchCode", "outcome", "Category"]
o = o[cols].rename(columns=str.lower)
o.to_csv("data/processed/orbital_launches_clean.csv", index=False)

con = sqlite3.connect("data/processed/space.db")
o.to_sql("orbital_launches", con, if_exists="replace", index=False)
con.close()
print("rows:", len(o), "| years:", o.launch_year.min(), "-", o.launch_year.max())
print(o.outcome.value_counts().to_dict())
print("unknown country rows:", (o.country == "Unknown").sum())
print(o.country.value_counts().head(12).to_dict())
