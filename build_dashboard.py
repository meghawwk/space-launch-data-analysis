"""Step 3: build a self-contained HTML dashboard from the SQL exports (Chart.js)."""
import json, pandas as pd
E = "tableau_exports/"
y  = pd.read_csv(E+"launches_by_year.csv")
cd = pd.read_csv(E+"country_share_by_decade.csv")
sx = pd.read_csv(E+"spacex_share.csv"); sx = sx[sx.launch_year <= 2025]
vf = pd.read_csv(E+"top_vehicle_families.csv").head(10)
tot = int(y.launches.sum()); succ = int(y.successes.sum())
full = y[y.is_partial_year == 0]; best = full.loc[full.launches.idxmax()]
top5 = ["United States", "USSR / Russia", "China", "France", "Japan"]
cd["c"] = cd.country.where(cd.country.isin(top5), "Other")
cd = cd.groupby(["decade", "c"], as_index=False).launches.sum()
cd["pct"] = 100 * cd.launches / cd.groupby("decade").launches.transform("sum")
decs = sorted(cd.decade.unique())
D = {
 "years": [str(v) + ("*" if v == 2026 else "") for v in y.launch_year],
 "succ": y.successes.tolist(), "fail": y.failures.tolist(),
 "decades": [f"{d}s" for d in decs],
 "share": {c: [round(float(cd[(cd.decade == d) & (cd.c == c)].pct.sum()), 1) for d in decs] for c in top5 + ["Other"]},
 "sxy": sx.launch_year.tolist(), "sxp": sx.spacex_share_pct.tolist(),
 "vf": vf.lv_family.tolist(), "vl": vf.launches.tolist(), "vs": vf.success_rate_pct.tolist(),
}
kpi = [(f"{tot:,}", "orbital launch attempts, 1957 to Apr 2026"), (f"{100*succ/tot:.1f}%", "all-time success rate"),
       (f"{int(best.launches)}", f"launches in {int(best.launch_year)}, the record year"),
       (f"{sx.spacex_share_pct.iloc[-1]:.0f}%", "of 2025 launches were SpaceX")]
cards = "".join(f'<div class="k"><b>{a}</b><span>{b}</span></div>' for a, b in kpi)
with open("dashboard_template.html", "r", encoding="utf-8") as f:
    template = f.read()

html = template.replace("__DATA__", json.dumps(D)).replace("__CARDS__", cards)

with open("dashboard.html", "w", encoding="utf-8") as f:
    f.write(html)
    
print(len(html), "bytes")
