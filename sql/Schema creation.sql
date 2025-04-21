USE kenya_census;

-- Redoing the schema
DROP TABLE IF EXISTS crops, households, population, counties,subcounties,subcounty_lookup;

-- 1) Counties
CREATE TABLE counties (
  county_id   INT PRIMARY KEY AUTO_INCREMENT,
  county_name VARCHAR(100) NOT NULL
);

-- 2) Population
CREATE TABLE population (
  population_id          INT PRIMARY KEY AUTO_INCREMENT,
  county_id       INT NOT NULL,
  gender          VARCHAR(20),
  population_count INT,
  FOREIGN KEY (county_id) REFERENCES counties(county_id)
);

-- 3) Household Stats
CREATE TABLE household_stats (
  household_id               INT PRIMARY KEY AUTO_INCREMENT,
  county_id           INT NOT NULL,
  population_total    INT,
  number_of_households        INT,
  avg_household_size         DECIMAL(5,2),
  FOREIGN KEY (county_id) REFERENCES counties(county_id)
);

-- 4) Crops
CREATE TABLE crops (
  crop_id     INT PRIMARY KEY AUTO_INCREMENT,
  county_id   INT NOT NULL,
  crop_name   VARCHAR(50),
  crop_count  INT,
  FOREIGN KEY (county_id) REFERENCES counties(county_id)
);
