# Kenya Census Capstone Project 🇰🇪

This capstone leverages Kenya’s 2019 Population & Housing Census to uncover county-level disparities across six critical dimensions—population scale, gender balance, household overcrowding, farming participation, crop diversity, and primary crop focus. Through **SQL-modeled views** and **Tableau dashboards**, we translate raw census data into actionable insights and recommendations.

---

## 🔍 Business Problem

Kenya’s 47 counties display stark contrasts in who lives where, how many people share a home,how many households are farming and the variety of crops being planted .How do we identify which counties need large-scale infrastructure (e.g. high-capacity water/sanitation) versus targeted agricultural interventions (e.g. diversification training, processing hubs)?

> **Key Question:**  
> How can we use these six metrics to identify service “hot-spots” and “cold-spots,” then guide data-driven resource allocation for maximum impact and equity?

I will present and analyze:
1. **Population Concentration** (Top 10 counties by total and gender-split)  
2. **Gender Imbalance** (counties with highest female-to-male and male-to-female ratios)  
3. **Household Overcrowding** (counties with average household size ≥ 5)  
4. **Farming Engagement** (Top 10 and Bottom 10 counties by % of households farming)  
5. **Crop Diversity** (counties with the widest vs. narrowest range of crops grown)  
6. **Primary Crop Specialization** (leading crop by county among the Top 10 farming regions)  

Each visualization will highlight key insights e.g., urban versus rural dynamics in farming, arid-zone overcrowding, and mono-crop vulnerabilities so that policymakers can prioritize **mass-impact interventions** in densely populated or highly agricultural areas and deploy **precision innovations** (e.g., modular water kiosks, crop-diversification programs, gender-tailored services) in more dispersed or specialized regions.  


## 📁 Datasets Used

Data was sourced from [TidyTuesday (2021-01-19)](https://github.com/rfordatascience/tidytuesday/blob/master/data/2021/2021-01-19) and curated from the [rKenyaCensus package](https://github.com/Shelmith-Kariuki/rKenyaCensus).

| Dataset                | Description                                                                    |
|------------------------|--------------------------------------------------------------------------------|
| `gender_reshaped.csv`  | County‑level population counts broken down by gender (Male, Female, Intersex)  |
| `households.csv`       | County‑level household metrics: total population, number of households, and average household size |
| `crops_reshaped.csv`   | County‑level household participation in specific crops (Tea, Coffee, Avocado, etc.) and overall farming engagement |

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
   - Verified record counts matched expectations .

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

I used Tableau to create the visuals,you can see some of the visuals in the `/Dashboards` folder.

## Consolidated Insights from Key Visualizations

1. **Population Concentration**  
   - The **Top 10** most populous counties (Nairobi, Kiambu, Nakuru, Kakamega, Bungoma, Meru, Kilifi, Machakos, Kisii, Mombasa) account for **40.81 %** of Kenya’s 2019 population—revealing a heavy “long tail” where the remaining 60 % are spread across 37 counties.  
   - **Action:** Prioritize high-impact urban and peri-urban services in these ten, while planning broader rural outreach.

2. **Household Overcrowding**  
   - Counties with **average household size ≥ 5** are clustered in the **arid and semi-arid north**—peaking at **7** persons/household in Mandera and **6** in Wajir, Garissa, Marsabit, and Turkana.  
   - **Action:** Deploy communal water and sanitation hubs in the highest-crowding zones, then roll out modular village-level units across all ≥ 5 pph counties.

3. **Farming Participation Extremes**  
   - **Top 10** farming counties (Kitui 81.9 %, Bomet 81.3 %, Vihiga 79.3 %, Makueni 79.1 %, etc.) are **rural heartlands** where agriculture is nearly universal.  
   - **Bottom 10** split into **urban/peri-urban** (e.g. Nairobi 2.1 %, Mombasa 3.3 %) and **semi-arid** (e.g. Turkana 37.2 %, Isiolo 41.8 %) contexts.  
   - **Action:** In rural high-participation areas, focus on productivity and value-chain upgrades; in low-participation urban and dryland zones, promote urban-agriculture and drought-resilient farming.

4. **Crop Diversity within High-Farming Counties**  
   - Among the **Top 10 farming** counties, **Tharaka-Nithi** leads with **7** distinct crops, followed by **Kakamega** and **Bungoma** with **6**, while **Nyandarua** and **Mombasa** manage only **2–3**.  
   - **Action:** In counties with high farming rates but low crop variety, launch diversification programs (new seed varieties, training) to reduce monoculture risks; in multi-crop regions, invest in multi-commodity processing and market linkages.

   **Just for crop variety :**
      - In high-diversity counties, support **processing facilities** and **market linkages** for multiple crops—maximizing returns across the full portfolio rather than just a single commodity.  
      - In low-diversity counties, introduce **crop rotation training**, **access to diverse seed varieties**, and **demonstration plots** to encourage adoption of new crops.  
---
5. **Primary Crop Dominance**  
   - The Top 10 counties by primary-crop households show clear specialization:  
     - **Avocado** in Kisii (88 326) & Bungoma (73 765)  
     - **Khat (Miraa)** in Meru (85 023)  etc.
   - **Action:**  
    1. **Value‐Chain Hubs:**  
   - **Avocado:** Establish cold-chain and packing facilities in Kisii and Bungoma.  
   - **Mango:** Invest in drying and canning plants near Machakos and Makueni.  
    2. **Processing & Export:**  
   - **Tea & Coffee:** Expand auction and processing capacity in Nyamira, Kericho, Murang’a, and Nyeri to capture higher margins.  
    3. **Specialty Markets:**  
   - **Khat (Miraa):** Support regulated supply chains from Meru, including drying sheds and transport corridors to major urban markets.

6. **Gender Imbalance Hotspots**

**Counties with Female-Majority (> 1.05 F/M Ratio)**  
- **Siaya (1.11), Homa Bay (1.10), Busia (1.10), Kisii (1.09), Vihiga (1.08), Nyamira (1.08), Migori (1.08)etc**  
- These counties have **6–11% more women** than men.  

**Counties with Male-Majority (< 0.95 F/M Ratio)**  
- **Garissa (0.83), Wajir (0.88), Lamu (0.89), Marsabit (0.89), Isiolo (0.92), Turkana (0.94)**  
- Here, there are **6–17% more men** than women.

> **Insight:**  
> Gender imbalances align with regional patterns—strong female majorities in western/rift-valley counties with established social services, versus male-skewed populations in northern and coastal counties facing pastoral or migrant-labor dynamics.
 - **Action:**  
1. **Women’s Services in Female-Majority Counties**  
   - Scale up **maternal health clinics**, **women’s education programs**, and **microfinance** tailored for female entrepreneurs.  
2. **Men’s Engagement in Male-Majority Counties**  
   - Expand **male-targeted health screenings** (e.g. for occupational hazards), **vocational training**, and **livelihood diversification** to reduce out-migration for work.  

By integrating six critical lenses—**population concentration** (where people live), **gender balance** (who lives where), **household size** (how many share a home), **farming participation** (who relies on agriculture), **crop diversity** (the breadth of crops grown), and **primary crop specialization** (which crop dominates each county)—we gain a 360° view of Kenya’s development landscape. This holistic insight enables a two-track approach: **mass-impact interventions** in densely populated, high-need rural and peri-urban heartlands, and **precision innovations**—from gender-tailored services to climate-smart agriculture—in urban, semi-arid, and mono-crop regions.  

## Conclusion & Next Steps

This analysis has mapped Kenya’s human geography and agricultural landscape across six dimensions—population scale, gender balance, household size, farming engagement, crop diversity, and primary‐crop focus—to inform targeted, high‐impact interventions.  

**Looking ahead**, further data integration will deepen our insights and refine policy design:  
- **Health & Education Facilities**: geolocated school and clinic counts to align infrastructure with population density and gender needs.  
- **Water & Sanitation Access**: household‐level water source and toilet facility data to refine overcrowding and resource‐strain models.  
- **Economic Indicators**: county‐level employment, income, and poverty rates to tailor livelihood diversification programs.  
- **Historical Census Trends**: 2009 vs. 2019 comparisons to track progress or emerging gaps over time.  
- **Climate & Soil Data**: rainfall patterns, drought frequency, and soil fertility maps to optimize crop diversification and irrigation investments.  

By layering these datasets onto our existing six‐pillar framework, future analyses can deliver even more precise, equity‐driven development strategies—ensuring no county is left behind.  


---

## 📌 Author

- **Mary Ann Mwaura** – Data Analysis & Project Lead  
- Project submitted as part of final capstone for the General Data Analysis – SQL, Excel and BI Tools module.

