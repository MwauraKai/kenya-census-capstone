USE kenya_census;


--  Create staging table
CREATE TABLE staging_household_stats (
  county_name       VARCHAR(100),
  population_total  INT,
  number_of_households      INT,
  avg_household_size       DECIMAL(5,2)
);

-- Check to see any mismatch

SELECT s.county_name, COUNT(*) AS bad_rows
FROM staging_household_stats s
LEFT JOIN counties c
  ON LOWER(TRIM(s.county_name)) = LOWER(TRIM(c.county_name))
WHERE c.county_id IS NULL
GROUP BY s.county_name;

-- Fixing the bad rows
SET SQL_SAFE_UPDATES = 0;

-- Kenya row is a total,removing it
DELETE FROM staging_household_stats
 WHERE TRIM(county_name) = 'Kenya';

-- Normalize the Remaining County Names

-- TanaRiver → Tana River
UPDATE staging_household_stats
   SET county_name = 'Tana River'
 WHERE TRIM(county_name) = 'TanaRiver';

-- Taita/Taveta → Taita Taveta
UPDATE staging_household_stats
   SET county_name = 'Taita Taveta'
 WHERE TRIM(county_name) = 'Taita/Taveta';

-- Tharaka-Nithi → Tharaka‑Nithi
UPDATE staging_household_stats
   SET county_name = 'Tharaka‑Nithi'
 WHERE TRIM(county_name) = 'Tharaka-Nithi';

-- WestPokot → West Pokot
UPDATE staging_household_stats
   SET county_name = 'West Pokot'
 WHERE TRIM(county_name) = 'WestPokot';

-- TransNzoia → Trans Nzoia
UPDATE staging_household_stats
   SET county_name = 'Trans Nzoia'
 WHERE TRIM(county_name) = 'TransNzoia';

-- UasinGishu → Uasin Gishu
UPDATE staging_household_stats
   SET county_name = 'Uasin Gishu'
 WHERE TRIM(county_name) = 'UasinGishu';

-- HomaBay → Homa Bay
UPDATE staging_household_stats
   SET county_name = 'Homa Bay'
 WHERE TRIM(county_name) = 'HomaBay';

-- NairobiCity → Nairobi
UPDATE staging_household_stats
   SET county_name = 'Nairobi'
 WHERE TRIM(county_name) = 'NairobiCity';

INSERT INTO household_stats (county_id, population_total, number_of_households, avg_household_size)
SELECT 
  c.county_id, 
  s.population_total, 
  s.number_of_households, 
  s.avg_household_size
FROM staging_household_stats s
JOIN counties c
  ON LOWER(TRIM(s.county_name)) = LOWER(TRIM(c.county_name));
