USE kenya_census;

 
-- 1. Create staging table
CREATE TABLE staging_population (
  county_name     VARCHAR(100),
  gender          VARCHAR(20),
  population_count INT
);

-- Check to see any mismatch
SELECT 
  s.county_name, 
  COUNT(*) AS bad_rows
FROM staging_population s
LEFT JOIN counties c
  ON LOWER(TRIM(s.county_name)) = LOWER(TRIM(c.county_name))
WHERE c.county_id IS NULL
GROUP BY s.county_name;

-- Fixing the bad rows

SET SQL_SAFE_UPDATES = 0;

-- 1) Replace slash with space for Taita Taveta
UPDATE staging_population
   SET county_name = 'Taita Taveta'
 WHERE county_name = 'Taita/Taveta';

-- 2) Match the exact hyphen style for Tharaka‑Nithi

UPDATE staging_population
   SET county_name = 'Tharaka‑Nithi'
 WHERE county_name = 'Tharaka-Nithi';

-- 3) Drop the " City" suffix for Nairobi
UPDATE staging_population
   SET county_name = 'Nairobi'
 WHERE county_name = 'Nairobi City';


-- 2. Push into final table
INSERT INTO population (county_id, gender, population_count)
SELECT c.county_id, s.gender, s.population_count
  FROM staging_population s
  JOIN counties c ON s.county_name = c.county_name;
 


-- 3.  Drop staging
DROP TABLE staging_population;
