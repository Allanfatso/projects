CREATE TABLE IF NOT EXISTS public.anomalies_isolation_forest (
    anomaly_id SERIAL PRIMARY KEY,
    reading_id BIGINT NOT NULL,
    anomaly_label INTEGER NOT NULL,
    anomaly_score DECIMAL(10, 6),
    detection_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.anomalies_isolation_forest_testing (
    anomaly_id SERIAL PRIMARY KEY,
    reading_id BIGINT NOT NULL,
    anomaly_label INTEGER NOT NULL,
    anomaly_score DECIMAL(10, 6),
    detection_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS public.anomalies_auto_encoder_testing (
    anomaly_id SERIAL PRIMARY KEY,
    reading_id BIGINT NOT NULL,
    anomaly_label INTEGER NOT NULL,
    anomaly_score DECIMAL(10, 6),
    detection_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE INDEX idx_anomalies_reading_id ON anomalies_isolation_forest(reading_id);

CREATE TABLE IF NOT EXISTS public.anomalies_kmeans (
    anomaly_id SERIAL PRIMARY KEY,
    reading_id BIGINT NOT NULL,
    anomaly_label INTEGER NOT NULL,
    year INTEGER NOT NULL,
    detection_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_anomalies_reading_id ON anomalies_isolation_forest(reading_id);
-- view


CREATE TABLE IF NOT EXISTS public.anomalies_two_layered_kmeans_isolation_f (
    anomaly_id SERIAL PRIMARY KEY,
    reading_id BIGINT,
    anomaly_label INTEGER,
    anomaly_score DECIMAL(10, 6),
    detection_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_anomalies_reading_id_3 ON anomalies_two_layered_kmeans_isolation_f(reading_id);
-- view

create or replace view isolation_forest_2011 as SELECT v.*, a.anomaly_label, a.detection_time
FROM all_data v
JOIN anomalies_isolation_forest a ON v.reading_id = a.reading_id
WHERE a.anomaly_label = -1;

-- 
-- 2011

-- How do the anomalies vary day by day with different weather conditions

create materialized view isolation_forest_day_weather as
SELECT
    date_trunc('day', t.date_time) AS day,
    t.weather,
    COUNT(*) AS anomaly_count
FROM anomalies_isolation_forest s
inner join all_data t on t.reading_id = s.reading_id 
WHERE anomaly_label = -1
GROUP BY 1, weather
ORDER BY 1, weather;

-- How do anomaly vary with each tariff_type:
create materialized view isolation_forest_tariff_std as
SELECT
    t.tariff,
    t.std_or_tou,
    COUNT(s.*) AS anomaly_count
FROM anomalies_isolation_forest s
inner join all_data t on t.reading_id = s.reading_id 
WHERE s.anomaly_label = -1
GROUP BY tariff, std_or_tou
ORDER BY anomaly_count DESC;

-- How do anomalies vary when grouped by socio-demographic patterns
-- and weather conditions.

create materialized view isolation_forest_acorn_weather as
SELECT
    t.acorn_group,
    t.weather,
    COUNT(*) AS anomaly_count
FROM anomalies_isolation_forest s
inner join all_data t on t.reading_id = s.reading_id 
WHERE anomaly_label = -1
GROUP BY acorn_group, weather
ORDER BY anomaly_count DESC;




-- Do anomalies reflect previous observations of higher consumption in winter and lower in summer?

create MATERIALIZED VIEW isolation_forest_all_seasonality AS
SELECT
  CASE
    WHEN EXTRACT(MONTH FROM t.date_time) IN (12,  1,  2) THEN 'Winter'
    WHEN EXTRACT(MONTH FROM t.date_time) IN ( 3,  4,  5) THEN 'Spring'
    WHEN EXTRACT(MONTH FROM t.date_time) IN ( 6,  7,  8) THEN 'Summer'
    WHEN EXTRACT(MONTH FROM t.date_time) IN ( 9, 10, 11) THEN 'Autumn'
  END AS season,
  t.acorn_group,
  COUNT(*) AS anomaly_count
FROM public.anomalies_isolation_forest s
JOIN all_data                 t ON t.reading_id = s.reading_id
WHERE s.anomaly_label = -1
GROUP BY season, t.acorn_group
ORDER BY season, anomaly_count DESC;









-- Do volatile households get flagged for being anomolous
CREATE MATERIALIZED VIEW isolation_forest_volatile_households AS

WITH volatile_ids AS (
  SELECT
    lcl_id,
    STDDEV(hourly_mean_reading)
      / NULLIF(AVG(hourly_mean_reading), 0) AS coeff_var
  FROM all_data
  GROUP BY lcl_id
  ORDER BY coeff_var DESC
  LIMIT 10
),
volatile_readings AS (
  SELECT
    ad.lcl_id,
    ad.reading_id,
    ad.hourly_mean_reading
  FROM all_data AS ad
  JOIN volatile_ids AS vi
    ON ad.lcl_id = vi.lcl_id
)

SELECT
  vr.lcl_id,
  COALESCE(
    COUNT(*) FILTER (WHERE a.anomaly_label = -1),
    0
  ) AS anomalies_count,
  ROUND(AVG(vr.hourly_mean_reading), 2) AS avg_usage
FROM volatile_readings AS vr
LEFT JOIN public.anomalies_isolation_forest AS a
  ON a.reading_id = vr.reading_id
GROUP BY vr.lcl_id
ORDER BY anomalies_count DESC;








select count(*) from (
    select a.reading_id 
    from anomalies_kmeans a 
    inner join anomalies_isolation_forest b on
    a.reading_id = b.reading_id
) 
as t 
inner join anomalies_two_layered_kmeans_isolation_f s on 
t.reading_id = s.reading_id;