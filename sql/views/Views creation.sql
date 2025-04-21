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
