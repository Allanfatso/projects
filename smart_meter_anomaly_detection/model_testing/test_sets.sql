-- Control sample 1: Uses data from the Christmas and 
-- August Summer Bank Holidays to reflect both high
-- and low consumption patterns. This is a control
-- dataset which should not be flagged for anomalies
-- The dataset is grouped by acorn-group
-- Three  households from each acorn group will be selected
-- for the data which convey typical behaviours of their group and should have a mean that sit's closely
-- to the typical mean of the group's overall mean for that particular season and also for that day due to cyclical difference.

-- 6 groups x 3 homes = 18 households.



-- Seasonal control (Christmas and August Bank Holiday)


/*
select count(*) from control_sample_seasonal_raw;
"count"
3293048
*/

-- summer
"lcl_id"
"MAC002621"
"MAC002614"
"MAC001166"

-- extract xmas data
CREATE TEMP TABLE xmas_raw AS
SELECT *
FROM all_data
WHERE date_time BETWEEN '2012-12-20 00:00:00'
                    AND '2012-12-26 23:59:59'
  AND EXTRACT(YEAR FROM date_time) <> 2013
  AND hourly_mean_reading BETWEEN 0.021 AND 1.911
  AND acorn_group <> 'GROUP-UNKNOWN'
  AND weather IS NOT NULL;

-- each group mean
CREATE TEMP TABLE grp_overall AS
SELECT acorn_group,
       AVG(hourly_mean_reading) AS grp_mean
FROM xmas_raw
GROUP BY acorn_group;

-- group day of week
CREATE TEMP TABLE grp_dow AS
SELECT acorn_group,
       EXTRACT(ISODOW FROM date_time)::int AS dow,
       AVG(hourly_mean_reading)    AS grp_dow_mean
FROM xmas_raw
GROUP BY acorn_group, dow;

-- group hour of day
CREATE TEMP TABLE grp_hour AS
SELECT acorn_group,
       EXTRACT(HOUR FROM date_time)::int AS hr,
       AVG(hourly_mean_reading)       AS grp_hr_mean
FROM xmas_raw
GROUP BY acorn_group, hr;

-- household overall
CREATE TEMP TABLE lcl_overall AS
SELECT acorn_group,
       lcl_id,
       AVG(hourly_mean_reading) AS lcl_mean
FROM xmas_raw
GROUP BY acorn_group, lcl_id;

-- household day of week
CREATE TEMP TABLE lcl_dow AS
SELECT acorn_group,
       lcl_id,
       EXTRACT(ISODOW FROM date_time)::int AS dow,
       AVG(hourly_mean_reading)       AS lcl_dow_mean
FROM xmas_raw
GROUP BY acorn_group, lcl_id, dow;

-- hour of day mean
CREATE TEMP TABLE lcl_hour AS
SELECT acorn_group,
       lcl_id,
       EXTRACT(HOUR FROM date_time)::int AS hr,
       AVG(hourly_mean_reading)       AS lcl_hr_mean
FROM xmas_raw
GROUP BY acorn_group, lcl_id, hr;



-- day of week diviation
CREATE TEMP TABLE diff_dow AS
SELECT l.acorn_group,
       l.lcl_id,
       AVG(ABS(l.lcl_dow_mean - g.grp_dow_mean)) AS diff_dow
FROM lcl_dow l
JOIN grp_dow g
  ON l.acorn_group = g.acorn_group
 AND l.dow         = g.dow
GROUP BY l.acorn_group, l.lcl_id;

-- hour of day deviation
CREATE TEMP TABLE diff_hr AS
SELECT l.acorn_group,
       l.lcl_id,
       AVG(ABS(l.lcl_hr_mean - g.grp_hr_mean)) AS diff_hr
FROM lcl_hour l
JOIN grp_hour g
  ON l.acorn_group = g.acorn_group
 AND l.hr          = g.hr
GROUP BY l.acorn_group, l.lcl_id;


-- household overall deviation
CREATE TEMP TABLE diff_overall AS
SELECT
  o.acorn_group,
  o.lcl_id,
  ABS(o.lcl_mean - g.grp_mean) AS diff_overall
FROM lcl_overall o
JOIN grp_overall g
  ON g.acorn_group = o.acorn_group;






-- group rank
WITH ranked AS (
  SELECT
    d.acorn_group,
    d.lcl_id,
    d.diff_overall,
    dw.diff_dow,
    hr.diff_hr,
    (d.diff_overall + dw.diff_dow + hr.diff_hr) / 3.0 AS avg_diff,
    ROW_NUMBER() OVER (
      PARTITION BY d.acorn_group
      ORDER BY (d.diff_overall + dw.diff_dow + hr.diff_hr) / 3.0
    ) AS rn
  FROM diff_overall d
  JOIN diff_dow    dw USING (acorn_group, lcl_id)
  JOIN diff_hr    hr USING (acorn_group, lcl_id)
)
SELECT
  acorn_group,
  lcl_id,
  diff_overall,
  diff_dow,
  diff_hr,
  avg_diff
FROM ranked
WHERE rn <= 3
ORDER BY acorn_group, avg_diff;



-- summer
"lcl_id"
"MAC004581"
"MAC000993"
"MAC000161"
"MAC002647"
"MAC004649"
"MAC002485"
"MAC003220"
"MAC003592"
"MAC001371"
"MAC001112"
"MAC000867"
"MAC003215"
"MAC002464"
"MAC002993"
"MAC000944"
"MAC003967"
"MAC003666"
"MAC004444"

CREATE OR REPLACE VIEW control_sample_unseen_raw AS
Select * from (
SELECT
  *,
  0 AS anomaly
FROM all_data
WHERE
  EXTRACT(YEAR FROM date_time) <> 2013

  -- one contiguous week not used above:
  AND date_time BETWEEN '2012-12-20 00:00:00' AND '2012-12-26 23:00:00'

  AND hourly_mean_reading >  0
  AND hourly_mean_reading >= 0.021
  AND hourly_mean_reading <= 1.911
  AND acorn_group <> 'GROUP-UNKNOWN'
  AND weather      IS NOT NULL
 AND lcl_id IN (
  'MAC004581',
  'MAC000993',
  'MAC000161',
  'MAC002647',
  'MAC004649',
  'MAC002485',
  'MAC003220',
  'MAC003592',
  'MAC001371',
  'MAC001112',
  'MAC000867',
  'MAC003215',
  'MAC002464',
  'MAC002993',
  'MAC000944',
  'MAC003967',
  'MAC003666',
  'MAC004444'
)
union all
SELECT
  *,
  0 AS anomaly
FROM all_data
WHERE
  EXTRACT(YEAR FROM date_time) <> 2013

  -- one contiguous week not used above:
  AND date_time BETWEEN '2012-05-06 00:00:00' AND '2012-05-12 23:00:00'

  AND hourly_mean_reading >  0
  AND hourly_mean_reading >= 0.021
  AND hourly_mean_reading <= 1.911
  AND acorn_group <> 'GROUP-UNKNOWN'
  AND weather      IS NOT NULL  
  AND lcl_id IN (
  'MAC000176',
  'MAC004581',
  'MAC005203',
  'MAC001147',
  'MAC002647',
  'MAC002774',
  'MAC004872',
  'MAC001064',
  'MAC002249',
  'MAC002368',
  'MAC005023',
  'MAC000466',
  'MAC000412',
  'MAC001072',
  'MAC004818',
  'MAC001186',
  'MAC005542',
  'MAC004882'
)
  ) as t
ORDER BY date_time



-- for machine learning

CREATE or replace VIEW control_sample_unseen_raw_ml AS
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

FROM control_sample_unseen_raw
WHERE acorn_group <> 'GROUP-UNKNOWN';










-- Control sample 2: Uses data from unseen period
-- in 7 day period of 2012 outside of the trained
-- datasets so that the models are exposed to new
-- data.
-- The control sets should be normalized and be entirely
-- cleansed of anomalies.
-- It also extracts 3 households grouped by acorn group


-- 1) raw data for Aug–Sep 2012, excluding any reading_id in your final samples
CREATE TEMP TABLE ml_unknown_unseen_raw AS
SELECT
  d.*,
  0 AS anomaly
FROM all_data AS d
WHERE
  EXTRACT(YEAR FROM d.date_time) <> 2013
  AND d.date_time BETWEEN '2012-03-01 00:00:00'
                      AND '2012-09-30 23:59:59'
  AND d.hourly_mean_reading BETWEEN 0.021 AND 1.911
  AND d.acorn_group <> 'GROUP-UNKNOWN'
  AND d.weather IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM final_sample_10    f  WHERE f.reading_id = d.reading_id)
  AND NOT EXISTS (SELECT 1 FROM final_sample_10_if fi WHERE fi.reading_id = d.reading_id);

-- 2) group‐level means
CREATE TEMP TABLE ml_unknown_grp_overall AS
SELECT acorn_group,
       AVG(hourly_mean_reading) AS grp_mean
FROM ml_unknown_unseen_raw
GROUP BY acorn_group;

CREATE TEMP TABLE ml_unknown_grp_dow AS
SELECT acorn_group,
       EXTRACT(ISODOW FROM date_time)::int AS dow,
       AVG(hourly_mean_reading)          AS grp_dow_mean
FROM ml_unknown_unseen_raw
GROUP BY acorn_group, dow;

CREATE TEMP TABLE ml_unknown_grp_hour AS
SELECT acorn_group,
       EXTRACT(HOUR FROM date_time)::int AS hr,
       AVG(hourly_mean_reading)          AS grp_hr_mean
FROM ml_unknown_unseen_raw
GROUP BY acorn_group, hr;

-- 3) household‐level means
CREATE TEMP TABLE ml_lcl_overall AS
SELECT acorn_group,
       lcl_id,
       AVG(hourly_mean_reading) AS lcl_mean
FROM ml_unknown_unseen_raw
GROUP BY acorn_group, lcl_id;

CREATE TEMP TABLE ml_lcl_dow AS
SELECT acorn_group,
       lcl_id,
       EXTRACT(ISODOW FROM date_time)::int AS dow,
       AVG(hourly_mean_reading)          AS lcl_dow_mean
FROM ml_unknown_unseen_raw
GROUP BY acorn_group, lcl_id, dow;

CREATE TEMP TABLE ml_lcl_hour AS
SELECT acorn_group,
       lcl_id,
       EXTRACT(HOUR FROM date_time)::int AS hr,
       AVG(hourly_mean_reading)          AS lcl_hr_mean
FROM ml_unknown_unseen_raw
GROUP BY acorn_group, lcl_id, hr;

-- 4) deviations
CREATE TEMP TABLE ml_diff_dow AS
SELECT l.acorn_group,
       l.lcl_id,
       AVG(ABS(l.lcl_dow_mean - g.grp_dow_mean)) AS diff_dow
FROM ml_lcl_dow l
JOIN ml_unknown_grp_dow g USING (acorn_group, dow)
GROUP BY l.acorn_group, l.lcl_id;

CREATE TEMP TABLE ml_diff_hr AS
SELECT l.acorn_group,
       l.lcl_id,
       AVG(ABS(l.lcl_hr_mean - g.grp_hr_mean)) AS diff_hr
FROM ml_lcl_hour l
JOIN ml_unknown_grp_hour g USING (acorn_group, hr)
GROUP BY l.acorn_group, l.lcl_id;

CREATE TEMP TABLE ml_diff_overall AS
SELECT o.acorn_group,
       o.lcl_id,
       ABS(o.lcl_mean - g.grp_mean) AS diff_overall
FROM ml_lcl_overall o
JOIN ml_unknown_grp_overall g USING (acorn_group);

-- 5) rank and pick top 3 per group
WITH ranked AS (
  SELECT
    d.acorn_group,
    d.lcl_id,
    d.diff_overall,
    dw.diff_dow,
    hr.diff_hr,
    (d.diff_overall + dw.diff_dow + hr.diff_hr) / 3.0 AS avg_diff,
    ROW_NUMBER() OVER (
      PARTITION BY d.acorn_group
      ORDER BY (d.diff_overall + dw.diff_dow + hr.diff_hr) / 3.0
    ) AS rn
  FROM ml_diff_overall d
  JOIN ml_diff_dow  dw USING (acorn_group, lcl_id)
  JOIN ml_diff_hr  hr USING (acorn_group, lcl_id)
  -- Ran to gather new data model does not know.
  /*WHERE d.lcl_id NOT IN (
    SELECT lcl_id FROM final_sample_10
    UNION
    SELECT lcl_id FROM final_sample_10_if
  )*/
)
SELECT
  acorn_group,
  lcl_id,
  diff_overall,
  diff_dow,
  diff_hr,
  avg_diff
FROM ranked
WHERE rn <= 3
ORDER BY acorn_group, avg_diff;




-- only these houholds are completely new to the dataset 
/*
"MAC003156"
"MAC005565"
"MAC001309"
"MAC001300"
"MAC002110"
*/
"MAC005017"
"MAC005013"
"MAC000264"
"MAC001706"
"MAC002647"
"MAC003977"
"MAC001465"
"MAC002327"
"MAC004872"
"MAC000127"
"MAC001397"
"MAC002462"
"MAC002077"
"MAC002248"
"MAC002579"
"MAC003957"
"MAC005174"
"MAC001446"


CREATE OR REPLACE VIEW ml_unknown_control_sample_unseen_raw AS
SELECT
  *,
  0 AS anomaly
FROM all_data
WHERE
  EXTRACT(YEAR FROM date_time) <> 2013

  -- one contiguous month not used above:
   AND date_time BETWEEN '2012-03-01 00:00:00'
                      AND '2012-09-30 23:59:59'

  AND hourly_mean_reading >  0
  AND hourly_mean_reading >= 0.021
  AND hourly_mean_reading <= 1.911
  AND acorn_group <> 'GROUP-UNKNOWN'
  AND weather      IS NOT NULL
  AND lcl_id in ('MAC003156', 'MAC005565', 'MAC001309', 'MAC001300', 'MAC002110',
  'MAC005017',
  'MAC005013',
  'MAC000264',
  'MAC001706',
  'MAC002647',
  'MAC003977',
  'MAC001465',
  'MAC002327',
  'MAC004872',
  'MAC000127',
  'MAC001397',
  'MAC002462',
  'MAC002077',
  'MAC002248',
  'MAC002579',
  'MAC003957',
  'MAC005174',
  'MAC001446')
ORDER BY date_time




-- for machine learning

CREATE or replace VIEW ml_unknown_control_sample_unseen_raw_10 AS
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

FROM ml_unknown_control_sample_unseen_raw
WHERE acorn_group <> 'GROUP-UNKNOWN';