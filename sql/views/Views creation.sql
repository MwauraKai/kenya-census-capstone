USE kenya_census;

-- Creating views
-- 1. Population by Gender & County 

CREATE OR REPLACE VIEW v_population_by_gender AS
SELECT
  c.county_name,                        
  p.gender,                              
  SUM(p.population_count) AS total_population  
FROM population p                        
JOIN counties c                          
  ON p.county_id = c.county_id           
GROUP BY
  c.county_name,
  p.gender;  
  


 -- 2. Household Stats by County
 CREATE OR REPLACE VIEW v_household_stats AS
SELECT
  c.county_name,
  h.population_total,
  h.number_of_households,
  h.avg_household_size
FROM household_stats h
JOIN counties c ON h.county_id = c.county_id;

-- 3.Crop Counts by County

CREATE OR REPLACE VIEW v_crops_by_county AS
SELECT
  c.county_name,
  cr.crop_name,
  SUM(cr.crop_count) AS total_households
FROM crops cr
JOIN counties c ON cr.county_id = c.county_id
GROUP BY c.county_name, cr.crop_name;


-- 4. Population to Household Ratio
-- Purpose: Shows average number of persons per household in each county.

CREATE OR REPLACE VIEW v_pop_per_household AS
SELECT
  c.county_name,
  ROUND(h.population_total / NULLIF(h.number_of_households,0),2) AS persons_per_household
FROM household_stats h
JOIN counties c ON h.county_id = c.county_id;

-- 5. Farming Participation Rate
-- Purpose: % of households engaged in “Farming” out of total households.

CREATE OR REPLACE VIEW v_farming_participation AS
SELECT
  c.county_name,
  f.crop_count AS farming_households,
  hs.number_of_households,
  ROUND(100 * f.crop_count / NULLIF(hs.number_of_households,0),1) AS pct_households_farming
FROM crops f
JOIN household_stats hs 
  ON f.county_id = hs.county_id
JOIN counties c 
  ON f.county_id = c.county_id
WHERE f.crop_name = 'Farming';

-- 6. Crop Diversity Index
-- Purpose: Counts how many different crops (excluding “Farming”) are grown per county

CREATE OR REPLACE VIEW v_crop_diversity AS
SELECT
  c.county_name,
  COUNT(DISTINCT cr.crop_name) AS crop_variety
FROM crops cr
JOIN counties c 
  ON cr.county_id = c.county_id
WHERE 
  cr.crop_name <> 'Farming'      -- exclude the total‑farming metric
  AND cr.crop_count  >  0        -- only crops with positive counts
GROUP BY c.county_name;

-- 7. Gender Ratio
-- Purpose: Ratio of Female-to-Male population per county.

CREATE OR REPLACE VIEW v_gender_ratio AS
SELECT
  p.county_name,
  ROUND(
    SUM(CASE WHEN p.gender = 'Female' THEN p.total_population ELSE 0 END)
    / NULLIF(SUM(CASE WHEN p.gender = 'Male'   THEN p.total_population ELSE 0 END), 0)
  , 2) AS female_to_male_ratio
FROM v_population_by_gender p
GROUP BY p.county_name;


-- 8. Primary Crop by County
-- Purpose: Finds the single most–widely grown crop in each county.

CREATE OR REPLACE VIEW v_primary_crop AS
SELECT
  x.county_name,
  x.crop_name,
  x.total_households
FROM (
  SELECT
    c.county_name,
    cr.crop_name,
    SUM(cr.crop_count) AS total_households,
    ROW_NUMBER() OVER (
      PARTITION BY cr.county_id
      ORDER BY SUM(cr.crop_count) DESC
    ) AS rn
  FROM crops cr
  JOIN counties c
    ON cr.county_id = c.county_id
  WHERE
    cr.crop_name <> 'Farming'   -- exclude the aggregate metric
    AND cr.crop_count  >  0     -- only consider crops actually grown
  GROUP BY
    c.county_name,
    cr.crop_name,
    cr.county_id
) x
WHERE x.rn = 1;


