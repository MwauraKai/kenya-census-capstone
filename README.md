# Kenya Census Capstone Project 🇰🇪

This capstone project uses data from Kenya’s 2019 Population and Housing Census to uncover regional inequalities in service delivery. Through structured SQL analysis and visualizations, we aim to identify underserved counties and support smarter, more equitable development decisions in Kenya.

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

## 🧱 SQL Database Design

The data was normalized and modeled into relational tables using MySQL. Each table was populated with sample data to simulate relationships and perform meaningful queries.

📸 *Entity Relationship Diagram (ERD) and schema details available in the `/images` folder.*

---

## 🧠 SQL Queries

Using MySQL Workbench, we explored:
- Total population by gender per county
- Regions with poor housing infrastructure
- Agricultural diversity and food security risks
- Correlation between population density and household conditions

All SQL queries and table scripts can be found in the `/sql` folder.

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

