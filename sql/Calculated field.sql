-- Sum of the top 3 counties
SELECT
  SUM(total_population) AS top3_pop
FROM v_population_by_gender
WHERE county_name IN ('Nairobi','Kiambu','Nakuru');

-- Total population across all counties
SELECT
  SUM(total_population) AS kenya_pop
FROM v_population_by_gender;

SELECT 
  ROUND(
    SUM(CASE 
          WHEN county_name IN ('Nairobi','Kiambu','Nakuru') 
          THEN total_population 
          ELSE 0 
        END)
    / SUM(total_population) * 100
  , 2) AS top3_pct
FROM v_population_by_gender;

-- top 10 
SELECT
  SUM(total_population) AS top10_pop
FROM v_population_by_gender
WHERE county_name IN ('Nairobi','Kiambu','Nakuru','Kakamega','Bungoma','Meru','Kilifi','Machakos','Kisii','Mombasa');

SELECT 
  ROUND(
    SUM(CASE 
          WHEN county_name IN ('Nairobi','Kiambu','Nakuru','Kakamega','Bungoma','Meru','Kilifi','Machakos','Kisii','Mombasa') 
          THEN total_population 
          ELSE 0 
        END)
    / SUM(total_population) * 100
  , 2) AS top3_pct
FROM v_population_by_gender;