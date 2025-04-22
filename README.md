# Kenya Census Capstone Project 🇰🇪

This capstone project uses data from Kenya’s 2019 Population and Housing Census to uncover regional inequalities in service delivery. Through structured SQL analysis and visualizations, I aim to identify underserved counties and support smarter, more equitable development decisions in Kenya.

---

## 🔍 Business Problem

Despite ongoing development efforts, service delivery in Kenya remains uneven across counties. This project explores:
> **How can Kenya use census data to identify underserved regions and prioritize national development projects more effectively?**

We focus on key indicators like population distribution, housing conditions, and agricultural practices to highlight regions at risk of being left behind.

---

## 📁 Datasets Used

Data was sourced from [TidyTuesday (2021-01-19)](https://github.com/rfordatascience/tidytuesday/blob/master/data/2021/2021-01-19) and curated from the [rKenyaCensus package](https://github.com/Shelmith-Kariuki/rKenyaCensus).

| Dataset | Description |
|---------|-------------|
| `gender.csv` | Population by gender, county, and subcounty |
| `crops.csv` | Types of crops grown by households in different counties |
| `households.csv` | Household conditions: roofing, cooking fuels, toilets, water access, etc. |

---

## 🧱 Database Schema (ERD)

![Kenya Census ERD](./images/Kenya%20Census%20ER.drawio.png)

## 🔧 Workflow & SQL Queries

I executed the following steps myself to ensure data integrity and reproducibility:

1. **Data Reshaping (Excel → Power Query)**
   - Unpivoted `gender.csv` to long form (`gender_reshaped.csv`).
   - Unpivoted `crops.csv` (including “Farming”) to `crops_reshaped.csv`.

2. **Database Schema & Tables (MySQL)**
   - Designed four tables: `counties`, `population`, `household_stats`, `crops`.
   - Created staging tables for each dataset to load raw CSVs without FK constraints.

3. **Data Import & Cleaning**
   - Imported reshaped CSVs into staging tables via the MySQL Import Wizard.
   - Detected and corrected county naming mismatches (`Taita/Taveta` → `Taita Taveta`, etc.) using trimmed, case-insensitive `UPDATE`s.
   - Removed aggregate “Total” rows (e.g. `Kenya`) before loading.

4. **Final Data Loading**
   - Populated final tables using `INSERT … SELECT` with `JOIN` on `counties` to map names → `county_id`.
   - Verified record counts matched expectations (141 population rows, N household rows, M crop rows).

## 🛠️ 5. Views Creation

- **`v_population_by_gender`**  
  Summarizes population by gender for each county by joining `population` and `counties` and aggregating total counts.

- **`v_household_stats`**  
  Exposes key household metrics—total population, number of households, and average household size—by county.

- **`v_crops_by_county`**  
  Aggregates household counts for each crop type (including “Farming”) by county, enabling analysis of crop prevalence and farming participation.

- **`v_pop_per_household`**  
  Calculates the average number of persons per household in each county by dividing `population_total` by `number_of_households` and rounding to two decimals.

- **`v_farming_participation`**  
  Shows the number and percentage of households engaged in farming per county by comparing the “Farming” crop count against total households.

- **`v_crop_diversity`**  
  Counts the number of distinct crops grown per county (excluding “Farming” and zero‑count crops) to measure agricultural diversity.

- **`v_gender_ratio`**  
  Computes the female‑to‑male population ratio for each county by summing gendered populations and rounding to two decimals.

- **`v_primary_crop`**  
  Identifies the single most‑widely grown specific crop per county (excluding “Farming” and zero‑count crops) using a row‑number ranking.


All DDL, DML, and view definitions can be found in the `/sql` folder:


---

## 📊 Tableau Dashboard

We connected Tableau to MySQL and created interactive visualizations to:
- Compare population distribution by gender and region
- Identify high-density areas with poor housing access
- Highlight counties at risk of food insecurity

🎯 View the final dashboard here: **(Insert Tableau Public Link once ready)**

---

## 🚀 Key Insights

- Some high-population counties still lack access to basic infrastructure
- Gender imbalance in rural counties could affect labor and education planning
- Certain counties grow a narrow range of crops — a food security red flag

---

## 🧭 Next Steps

- Include education and employment indicators from other census volumes
- Add hospital and school facility data per county
- Compare historical census trends (e.g. 2009 vs 2019)
- Propose policy recommendations for high-risk counties

---

## 📌 Team / Author

- **Mary Ann Mwaura** – Data Analysis & Project Lead  
- Project submitted as part of final capstone for the General Data Analysis – SQL, Excel and BI Tools module.

