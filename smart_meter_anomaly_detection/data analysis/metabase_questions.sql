-- CREATE DATABASE metabase;

docker run -d -p 3000:3000 -e MB_DB_TYPE=postgres -e MB_DB_DBNAME=metabase -e MB_DB_PORT=5432 -e MB_DB_USER=postgres -e MB_DB_PASS=C@thyr1ch -e MB_DB_HOST=host.docker.internal --name metabase metabase/metabase


/*

Seasonal Trends (Time-of-Year Patterns)
Seasonality is a major driver of energy use – for example, winter heating demand often causes higher 
consumption in cold months​.
In this section, we'll examine trends by month/quarter and compare across years. Note: The data runs 
from Q4 2011 to Q1 2014, so 2011 and 2014 are partial years (only one quarter each).
Question: How does overall energy usage trend over time? (Identify seasonal peaks and troughs over the 
entire timeline.)

*/


-- Do any specific seasons or months show anomalies or trends over the years? 

-- run for every year.

SELECT 
    date_time::date AS date,
    SUM(hourly_mean_reading) AS total_kwh
FROM all_data
WHERE EXTRACT(MONTH FROM date_time) = 7 AND EXTRACT(YEAR FROM date_time) = 2013
GROUP BY date
ORDER BY date;

-- Question: Do any demographic groups respond differently to seasonal changes 
-- or tariff programs? (Cross-linking factors)


create MATERIALIZED view responsive_acorn_consumption as (
SELECT EXTRACT(MONTH FROM timestamp) AS month,
       AVG(energy_kwh) AS avg_kwh
FROM all_data
WHERE acorn_group = 'Affluent'
GROUP BY month
ORDER BY month);

-- Question: How did the high/low pricing events affect consumption for 
-- dynamic tariff customers? (If data available for rate periods)

create MATERIALIZED view pricing_consumption as (
SELECT tariff,  -- e.g., values: 'High', 'Normal', 'Low'
       AVG(hourly_mean_reading) AS avg_kwh
FROM all_data
WHERE tariff = 'Dynamic'  -- consider only dynamic tariff households
GROUP BY tariff_rate);



-- all data:
CREATE OR REPLACE VIEW all_data AS
select * from BI_all_views_2011_12_1st
UNION ALL
select * from BI_all_views_2012_14_2nd


-- Average daily consumption over time.

create MATERIALIZED view monthly_consumption_patterns as(
SELECT EXTRACT(YEAR FROM date_time) AS year,
       EXTRACT(MONTH FROM date_time) AS month,
       AVG(hourly_mean_reading) AS avg_kwh_per_hour
FROM
all_data-- use the unified dataset or subquery as above
GROUP BY year, month
ORDER BY month, year);

--- 


/*
Lot's of missing values for the above query ran this to check why

*/
SELECT EXTRACT(MONTH FROM date_time) AS month,
       COUNT(*) AS rows,
       COUNT(hourly_mean_reading) AS non_null_readings
FROM all_data
WHERE EXTRACT(YEAR FROM date_time) = 2013
GROUP BY month
ORDER BY month;




-- Average daily consumption over time (all households)
Create materialized view average_daily_consumption_over_time as(
SELECT date_trunc('week', date_time) AS week_start,
       AVG(hourly_mean_reading) AS avg_kwh_per_hour
FROM all_data
GROUP BY date_trunc('week', date_time)
ORDER BY week_start
);


-- Question: How does each quarter’s consumption compare across different years?

CREATE MATERIALIZED VIEW quarterly_average_consumption AS
(SELECT 
    EXTRACT(YEAR FROM date_time) AS year,
    EXTRACT(QUARTER FROM date_time) AS quarter,
    AVG(hourly_mean_reading) AS avg_kwh_per_hour
FROM all_data
GROUP BY year, quarter
ORDER BY quarter, year);



--  DEMOGRAPHIC PATTERNS ---

-- Question: Which ACORN groups use the most and least energy on average?
CREATE MATERIALIZED VIEW avg_acorn_consumption AS (
SELECT 
    acorn_group,
    AVG(hourly_mean_reading) AS avg_kwh_per_hour
FROM all_data
GROUP BY acorn_group
ORDER BY avg_kwh_per_hour DESC);


--  Do different demographics exhibit distinct seasonal patterns? 
-- (e.g. Do some groups' usage increase more in winter than others?)
CREATE MATERIALIZED VIEW seasonal_acorn_consumption AS
SELECT acorn_group, 'Winter' AS season, AVG(hourly_mean_reading) AS avg_kwh
FROM all_data
WHERE EXTRACT(MONTH FROM date_time) IN (12,1,2)
GROUP BY acorn_group
UNION ALL
SELECT acorn_group, 'Summer', AVG(hourly_mean_reading)
FROM all_data
WHERE EXTRACT(MONTH FROM date_time) IN (6,7,8)
GROUP BY acorn_group;


-- Question: How varied is consumption within each ACORN group? 
-- (Are there outlier households in certain demographics?)

CREATE MATERIALIZED VIEW variance_acorn_consumption AS
SELECT acorn_group,
       MIN(total_kwh) AS min_kwh,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_kwh) AS median_kwh,
       PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_kwh) AS p90_kwh,
       MAX(total_kwh) AS max_kwh
FROM (
    SELECT lcl_id, acorn_group, SUM(hourly_mean_reading) AS total_kwh
    FROM all_data
    GROUP BY lcl_id, acorn_group
) sub
GROUP BY acorn_group;




-- WEATHER IMPACTS ON CONSUMPTION ---

-- Question: How does energy consumption vary by weather category?
create MATERIALIZED view avg_weather_consumption as (
SELECT weather,
       AVG(hourly_mean_reading) AS avg_kwh_per_hour
FROM all_data
GROUP BY weather
ORDER BY avg_kwh_per_hour DESC);


-- Question: Is the weather-consumption relationship consistent across
-- different segments? (optional cross-analysis)

--- Tarrif Effects and Usage ---

-- Question: Do households on Dynamic tariffs use less energy 
-- overall than those on Standard tariffs?

create MATERIALIZED view tariff_consumption as (
SELECT tariff AS tariff_plan,
       AVG(hourly_mean_reading) AS avg_kwh_per_hour
FROM all_data
GROUP BY tariff
ORDER BY avg_kwh_per_hour DESC);

-- for 2013
create MATERIALIZED view thirteen_tariff_consumption as (
SELECT tariff AS tariff_plan,
       AVG(hourly_mean_reading) AS avg_kwh_per_hour
FROM all_data
where EXTRACT(Year from date_time) = 2013
GROUP BY tariff
ORDER BY avg_kwh_per_hour DESC);

-- Question: How do usage patterns differ by tariff type during peak 
-- vs off-peak hours?


create MATERIALIZED view tariff_consumption_peak_off_peak as (
SELECT EXTRACT(HOUR FROM date_time) AS hour_of_day,
       tariff AS tariff_plan,
       AVG(hourly_mean_reading) AS avg_kwh
FROM all_data
GROUP BY hour_of_day, tariff
ORDER BY hour_of_day);

-- 2013
create MATERIALIZED view thirteen_tariff_consumption_peak_off_peak as (
SELECT EXTRACT(HOUR FROM date_time) AS hour_of_day,
       tariff AS tariff_plan,
       AVG(hourly_mean_reading) AS avg_kwh
FROM all_data
where EXTRACT(Year from date_time) = 2013
GROUP BY hour_of_day, tariff
ORDER BY hour_of_day);

-- Question: Do tariff effects differ across demographic groups?

create MATERIALIZED view pricing_consumption as (
SELECT acorn_group AS acorn_category,
       tariff AS tariff_plan,
       AVG(hourly_mean_reading) AS avg_kwh
FROM all_data
GROUP BY acorn_group, tariff);

--2013
create MATERIALIZED view thirteen_pricing_consumption as (
SELECT acorn_group AS acorn_category,
       tariff AS tariff_plan,
       AVG(hourly_mean_reading) AS avg_kwh
FROM all_data
where EXTRACT(Year from date_time) = 2013
GROUP BY acorn_group, tariff);

-- Daily and Weekly Usage Patterns (Behavioral Trends) --

-- Question: What is the typical daily usage profile for a household?
--  (Hourly pattern in a day)

create MATERIALIZED view typical_household_consumption as (
SELECT EXTRACT(HOUR FROM date_time) AS hour_of_day,
       AVG(hourly_mean_reading) AS avg_kwh
FROM all_data
GROUP BY hour_of_day
ORDER BY hour_of_day);

-- Question: How do weekdays and weekends differ in energy usage?

create MATERIALIZED view day_type_consumption as (
SELECT EXTRACT(HOUR FROM date_time) AS hour_of_day,
       CASE 
         WHEN EXTRACT(DOW FROM date_time) IN (0,6) THEN 'Weekend'
         ELSE 'Weekday'
       END AS day_type,
       AVG(hourly_mean_reading) AS avg_kwh
FROM all_data
GROUP BY hour_of_day, day_type
ORDER BY hour_of_day);

-- Question: Which day of the week has the highest average consumption?

create MATERIALIZED view day_type_avg_consumption as (
SELECT EXTRACT(DOW FROM date_time) AS day_of_week,
       AVG(hourly_mean_reading)*24 AS avg_kwh_per_day
FROM all_data
GROUP BY day_of_week
ORDER BY avg_kwh_per_day DESC);

-- Question: How do public holidays compare to normal weekdays 
-- in terms of usage patterns?
create MATERIALIZED view holiday_avg_consumption as (
SELECT EXTRACT(HOUR FROM date_time) AS hour_of_day,
       holiday,
       AVG(hourly_mean_reading) AS avg_kwh
FROM all_data
GROUP BY hour_of_day, holiday
ORDER BY hour_of_day);

-- is it the same for all the years?

create MATERIALIZED view holiday_avg_consumption_2011 as (
SELECT EXTRACT(HOUR FROM date_time) AS hour_of_day,
       holiday,
       AVG(hourly_mean_reading) AS avg_kwh
FROM all_data
where EXTRACT(YEAR FROM date_time) = '2011'
GROUP BY hour_of_day, holiday
ORDER BY hour_of_day);


create MATERIALIZED view holiday_avg_consumption_2012 as (
SELECT EXTRACT(HOUR FROM date_time) AS hour_of_day,
       holiday,
       AVG(hourly_mean_reading) AS avg_kwh
FROM all_data
where EXTRACT(YEAR FROM date_time) = '2012'
GROUP BY hour_of_day, holiday
ORDER BY hour_of_day);


create MATERIALIZED view holiday_avg_consumption_2013 as (
SELECT EXTRACT(HOUR FROM date_time) AS hour_of_day,
       holiday,
       AVG(hourly_mean_reading) AS avg_kwh
FROM all_data
where EXTRACT(YEAR FROM date_time) = '2013'
GROUP BY hour_of_day, holiday
ORDER BY hour_of_day);

create MATERIALIZED view holiday_avg_consumption_2014 as (
SELECT EXTRACT(HOUR FROM date_time) AS hour_of_day,
       holiday,
       AVG(hourly_mean_reading) AS avg_kwh
FROM all_data
where EXTRACT(YEAR FROM date_time) = '2014'
GROUP BY hour_of_day, holiday
ORDER BY hour_of_day);


-- Question: Are there any unusual daily patterns or anomalies in time-of-day usage?

-- Use heatmap.

-------     Household-Specific Outliers and Anomalies ----

-- Question: Which households are the highest energy consumers,
-- and which are the lowest?

create MATERIALIZED view household_consumption_highest as (
SELECT lcl_id,
       AVG(hourly_mean_reading) AS avg_kwh_per_hour
FROM all_data
GROUP BY lcl_id
ORDER BY avg_kwh_per_hour DESC
LIMIT 10);


-- Lowest consumer
create MATERIALIZED view household_consumption_lowest as (
SELECT lcl_id,
       AVG(hourly_mean_reading) AS avg_kwh_per_hour
FROM all_data
GROUP BY lcl_id
ORDER BY avg_kwh_per_hour ASC
LIMIT 10);

-- Question: Which households have the most volatile or irregular usage patterns?

create MATERIALIZED view household_volatile_consumers as (
SELECT lcl_id, acorn_group,
       STDDEV(hourly_mean_reading) / NULLIF(AVG(hourly_mean_reading), 0) AS coeff_var
FROM all_data
GROUP BY lcl_id, acorn_group
ORDER BY coeff_var DESC
LIMIT 10);

-- Question: Are there households with unusual seasonal behavior?




-- Question: What is the single highest hourly consumption recorded, 
-- and which household did it occur in?

create MATERIALIZED view highest_ever_consumption as (
SELECT lcl_id, reading_id, date_time, hourly_mean_reading, acorn_group
FROM all_data
ORDER BY hourly_mean_reading DESC
LIMIT 1);









-- How do different demographics react to weather conditions(hourly)

CREATE materialized VIEW acorn_weather_interaction AS
SELECT
    acorn_group,
    weather,
    EXTRACT(HOUR FROM date_time) AS hour,
    AVG(hourly_mean_reading) AS avg_consumption
FROM all_data
GROUP BY acorn_group, weather, hour
ORDER BY acorn_group, avg_consumption, hour DESC;

-- How do different demographics react to tariffs (hourly)

CREATE materialized VIEW acorn_tariff_interaction AS
SELECT tariff, acorn_group, EXTRACT(HOUR FROM date_time) AS hour,
       AVG(hourly_mean_reading) AS avg_kwh
FROM all_data
GROUP BY tariff, acorn_group, hour
ORDER BY acorn_group, tariff, hour;

-- 2013
CREATE materialized VIEW thirteen_acorn_tariff_interaction AS
SELECT tariff, acorn_group, EXTRACT(HOUR FROM date_time) AS hour,
       AVG(hourly_mean_reading) AS avg_kwh
FROM all_data
where EXTRACT(Year from date_time) = 2013
GROUP BY tariff, acorn_group, hour
ORDER BY acorn_group, tariff, hour;


