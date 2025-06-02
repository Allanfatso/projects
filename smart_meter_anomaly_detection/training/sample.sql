-- drop if you’ve run it before:

-- determining ceiling for half-hourly consumption:
SELECT
  PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY hourly_mean_reading) AS p95,
  PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY hourly_mean_reading) AS p99,
  MAX(hourly_mean_reading) AS max_reading
FROM all_data
WHERE weather = 'Freezing';


SELECT
  PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY hourly_mean_reading) AS p05,
  PERCENTILE_CONT(0.01) WITHIN GROUP (ORDER BY hourly_mean_reading) AS p01,
  MIN(hourly_mean_reading) AS min_reading
FROM all_data
WHERE weather = 'Hot';



/*
output:
0.941	1.911	9.484000

"p05"	"p01"	"min_reading"
0.021	0	0.000000
*/


CREATE MATERIALIZED VIEW base_filtered AS
SELECT
  *,
  EXTRACT(MONTH FROM date_time)::INT AS month,
  EXTRACT(HOUR  FROM date_time)::INT AS hour
FROM all_data
WHERE
  hourly_mean_reading > 0
  AND hourly_mean_reading <= 1.911
  AND hourly_mean_reading >= 0.021
  AND acorn_group <> 'GROUP-UNKNOWN'
  AND EXTRACT(YEAR FROM DATE_TIME) <> 2013
  AND weather IS NOT NULL;

-- index for speed
CREATE INDEX ON base_filtered(holiday);
CREATE INDEX ON base_filtered(month);
CREATE INDEX ON base_filtered(acorn_group);
CREATE INDEX ON base_filtered(hour);
CREATE INDEX ON base_filtered(tariff);
CREATE INDEX ON base_filtered(date_time);
CREATE INDEX ON base_filtered(weather);
CREATE UNIQUE INDEX ON base_filtered(reading_id);


-- ANALYZE base_filtered;






-- stratum quota for each holiday:
-- 3a) How many holiday rows did we get?






--stratification
CREATE TABLE tmp_joint_strata_10 AS
SELECT
  acorn_group,
  holiday,
  weather,
  std_or_tou,
  EXTRACT(HOUR FROM date_time) AS hour_of_day,
  EXTRACT(MONTH FROM date_time) AS month,
  COUNT(*) AS cnt,
  COUNT(*)::numeric / SUM(COUNT(*)) OVER () AS proportion,
  ROUND(
    (COUNT(*)::numeric / SUM(COUNT(*)) OVER ()) * 100000
  )::INT AS quota
FROM base_filtered
GROUP BY
  acorn_group, holiday, weather, std_or_tou, EXTRACT(HOUR FROM date_time), EXTRACT(MONTH FROM date_time);


/*

*/
/*
SELECT *
FROM tmp_joint_strata_10
WHERE quota = 0
ORDER BY cnt DESC;
*/

-- 0 quota was visible
UPDATE tmp_joint_strata_10
SET quota = 1
WHERE quota = 0;



CREATE TABLE numbered_rows_10 AS
SELECT
    bf.*,
    EXTRACT(HOUR FROM date_time) AS hour_of_day,
    ROW_NUMBER() OVER (
        PARTITION BY acorn_group, holiday, weather, std_or_tou, EXTRACT(HOUR FROM date_time),
        EXTRACT(MONTH FROM date_time)
        ORDER BY random()
    ) AS row_num
FROM base_filtered bf;




CREATE MATERIALIZED VIEW final_sample_10 AS
  SELECT nr.*
  FROM numbered_rows_10 nr
  JOIN tmp_joint_strata_10 js
    ON nr.acorn_group = js.acorn_group
  AND nr.holiday = js.holiday
  AND nr.weather = js.weather
  AND nr.std_or_tou = js.std_or_tou
  AND nr.hour_of_day = js.hour_of_day
  AND nr.month = js.month
WHERE nr.row_num <= js.quota;






/*
"acorn_group"	"cnt"
"Established Affluence"	16545233(33.79%)

"Low Income Living"	372652(0.76%)
"Luxury Lifestyles"	2439124(4.98%)
"Steadfast Communities"	7406908(15.13%)
"Stretched Society"	9036867(18.46%)
"Thriving Neighbourhoods"	13161343(26.88%)

*/



-- Sample Quality Check

-- original proportions:
/*
SELECT acorn_group, holiday, weather, tariff, std_or_tou, extract(hour from date_time) as hour_of_day,
       COUNT(*) AS cnt,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 3) AS original_pct
FROM base_filtered
GROUP BY acorn_group, holiday, weather, tariff, std_or_tou, hour_of_day
ORDER BY cnt DESC;


-- sample proportions
SELECT acorn_group, holiday, weather, tariff, std_or_tou, hour_of_day,
       COUNT(*) AS cnt_sample,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 3) AS sample_pct
FROM final_sample
GROUP BY acorn_group, holiday, weather, tariff, std_or_tou, hour_of_day
ORDER BY cnt_sample DESC;


-- measurements and tests

-- Sample Data Stats
SELECT AVG(hourly_mean_reading) AS mean_consumption_sample,
       STDDEV(hourly_mean_reading) AS std_consumption_sample
FROM final_sample;

-- Original Data Stats
SELECT AVG(hourly_mean_reading) AS mean_consumption,
       STDDEV(hourly_mean_reading) AS std_consumption
FROM base_filtered;



-- Skewness:
-- 1. How many rows, and what’s the mean?
CREATE TEMP TABLE stats AS
SELECT
  COUNT(*)                AS n,
  AVG(hourly_mean_reading) AS mean
FROM final_sample;

-- 2. Sum of squared deviations and cubed deviations
CREATE TEMP TABLE dev_moments AS
SELECT
  SUM( POWER(hourly_mean_reading - stats.mean, 2) ) AS sum_sq_dev,
  SUM( POWER(hourly_mean_reading - stats.mean, 3) ) AS sum_cu_dev
FROM final_sample
CROSS JOIN stats;

-- 3. Sample skewness: G₁ = [n²/((n–1)(n–2))] × [ (M₃/M₀) / (M₂/M₀)^(3/2) ]
SELECT
  (stats.n * stats.n)
    / ((stats.n - 1) * (stats.n - 2))
  * (
      (dev_moments.sum_cu_dev / stats.n)
      / POWER(dev_moments.sum_sq_dev / stats.n, 1.5)
    ) AS sample_skewness
FROM stats, dev_moments;
-- https://medium.com/@vipinnation/mastering-skewness-a-guide-to-handling-and-transforming-data-in-machine-learning-0a42773a026f#:~:text=Understanding%20Skewness&text=Skewness%20can%20manifest%20in%20two,few%20outliers%20on%20the%20right

-- "sample_skewness"
-- 2.916568485612513735861300912679

*/


-- Transformed sample


CREATE MATERIALIZED VIEW final_sample_ml_10 AS
SELECT 
    date_time,
    lcl_id,

    -- Binary encoding for std_or_tou
    CASE WHEN std_or_tou = 'Std' THEN 0 ELSE 1 END AS std_or_tou,

    -- One-Hot Encoding for acorn_group
    CASE WHEN acorn_group = 'Established Affluence'   THEN 1 ELSE 0 END AS acorn_group_affluence,
    CASE WHEN acorn_group = 'Steadfast Communities'  THEN 1 ELSE 0 END AS acorn_group_steadfast,
    CASE WHEN acorn_group = 'Thriving Neighbourhoods' THEN 1 ELSE 0 END AS acorn_group_thriving,
    CASE WHEN acorn_group = 'Stretched Society'       THEN 1 ELSE 0 END AS acorn_group_stretched,
    -- dropped Low Income Living as dummy trap
    CASE WHEN acorn_group = 'Luxury Lifestyles'       THEN 1 ELSE 0 END AS acorn_group_low_luxury,

    -- One-Hot for holiday
    CASE WHEN holiday = 'New Year Day'             THEN 1 ELSE 0 END AS holiday_new_year,
    CASE WHEN holiday = 'Good Friday'              THEN 1 ELSE 0 END AS holiday_good_friday,
    CASE WHEN holiday = 'Easter Monday'            THEN 1 ELSE 0 END AS holiday_easter_monday,
    CASE WHEN holiday = 'Christmas Day'            THEN 1 ELSE 0 END AS holiday_christmas,
    CASE WHEN holiday = 'Boxing Day'               THEN 1 ELSE 0 END AS holiday_boxing,
    CASE WHEN holiday in ('Early May bank holiday', 'Spring bank holiday', 'Queen Diamond Jubilee', 'Summer bank holiday')   THEN 1 ELSE 0 END AS holiday_bank,
  
    -- Raw reading
    CAST(ROUND(hourly_mean_reading, 4) AS double precision) 
      AS hourly_mean_reading,

    -- *** your new log-transformed column ***
    LN(hourly_mean_reading + 1e-3) 
      AS hourly_mean_reading_log,

    -- keep your ID
    Reading_ID,

    -- Weather as ordinal
    CASE
      WHEN weather = 'Freezing' THEN 1
      WHEN weather = 'Cold'    THEN 2
      WHEN weather = 'Chilly'  THEN 3
      WHEN weather = 'Cool'    THEN 4
      WHEN weather = 'Mild'    THEN 5
      WHEN weather = 'Warm'    THEN 6
      WHEN weather = 'Hot'     THEN 7
      ELSE 8
    END AS weather,

    -- Cyclical time features
    CAST(SIN(2 * PI() * EXTRACT(HOUR FROM date_time)  / 24) AS double precision) AS hour_sin,
    CAST(COS(2 * PI() * EXTRACT(HOUR FROM date_time)  / 24) AS double precision) AS hour_cos,
    CAST(SIN(2 * PI() * EXTRACT(DOW  FROM date_time)  / 7) AS double precision) AS day_sin,
    CAST(COS(2 * PI() * EXTRACT(DOW  FROM date_time)  / 7) AS double precision) AS day_cos,
    CAST(SIN(2 * PI() * EXTRACT(MONTH FROM date_time) / 12) AS double precision) AS month_sin,
    CAST(COS(2 * PI() * EXTRACT(MONTH FROM date_time) / 12) AS double precision) AS month_cos,

    -- handy raw time parts
    EXTRACT(HOUR  FROM date_time) AS hour,
    EXTRACT(MONTH FROM date_time) AS month,
    EXTRACT(DOW   FROM date_time) AS day

FROM final_sample_10
WHERE acorn_group <> 'GROUP-UNKNOWN'; -- issue here




