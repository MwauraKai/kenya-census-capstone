USE kenya_census;


--  Create staging table
CREATE TABLE staging_crops (
  county_name VARCHAR(100),
  crop_name   VARCHAR(50),
  crop_count  INT
);

-- Check to see any mismatch
SELECT s.county_name, COUNT(*) AS bad_rows
FROM staging_crops s
LEFT JOIN counties c
  ON LOWER(TRIM(s.county_name)) = LOWER(TRIM(c.county_name))
WHERE c.county_id IS NULL
GROUP BY s.county_name;

-- Fixing the bad rows
SET SQL_SAFE_UPDATES = 0;

-- Taita/Taveta → Taita Taveta
UPDATE staging_crops
   SET county_name = 'Taita Taveta'
 WHERE TRIM(county_name) = 'Taita/Taveta';

-- Tharaka-Nithi → Tharaka‑Nithi
UPDATE staging_crops
   SET county_name = 'Tharaka‑Nithi'
 WHERE TRIM(county_name) = 'Tharaka-Nithi';
 
 
 -- Push into final table
 INSERT INTO crops (county_id, crop_name, crop_count)
SELECT 
  c.county_id,
  s.crop_name,
  s.crop_count
FROM staging_crops s
JOIN counties c
  ON LOWER(TRIM(s.county_name)) = LOWER(TRIM(c.county_name));

DROP TABLE staging_crops;