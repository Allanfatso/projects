SELECT *
FROM
(
    SELECT * FROM BI_2011_q4_hourly
    UNION ALL
    SELECT * FROM BI_2012_q1_hourly
    UNION ALL
    SELECT * FROM BI_2012_q2_hourly 
    UNION ALL
    SELECT * FROM BI_2012_q3_hourly 
    UNION ALL
    SELECT * FROM BI_2012_q4_hourly
    UNION ALL
    SELECT * FROM BI_2013_q1_hourly
    UNION ALL
    SELECT * FROM BI_2013_q2_hourly
    UNION ALL
    SELECT * FROM BI_2013_q3_hourly
    UNION ALL
    SELECT * FROM BI_2013_q4_hourly
    UNION ALL
    SELECT * FROM BI_2014_q1_hourly 
) AS all_views LIMIT 500000


-- check for uniqueness for id

SELECT reading_id, COUNT(*)
FROM
(
	SELECT * FROM BI_2011_q4_hourly
    UNION ALL
    SELECT * FROM BI_2012_q1_hourly
    UNION ALL
    SELECT * FROM BI_2012_q2_hourly 
    UNION ALL
    SELECT * FROM BI_2012_q3_hourly 
    UNION ALL
    SELECT * FROM BI_2012_q4_hourly
    UNION ALL
    SELECT * FROM BI_2013_q1_hourly
    UNION ALL
    SELECT * FROM BI_2013_q2_hourly
    UNION ALL
    SELECT * FROM BI_2013_q3_hourly
    UNION ALL
    SELECT * FROM BI_2013_q4_hourly
    UNION ALL
    SELECT * FROM BI_2014_q1_hourly 
) as all_views
GROUP BY reading_id
HAVING COUNT(*) > 1;

-- Check value types for preciptype, acorn, acorn-group, weather, holiday
WITH all_views AS (
    SELECT * FROM BI_2011_q4_hourly
    UNION ALL
    SELECT * FROM BI_2012_q1_hourly
    UNION ALL
    SELECT * FROM BI_2012_q2_hourly 
    UNION ALL
    SELECT * FROM BI_2012_q3_hourly 
    UNION ALL
    SELECT * FROM BI_2012_q4_hourly
    UNION ALL
    SELECT * FROM BI_2013_q1_hourly
    UNION ALL
    SELECT * FROM BI_2013_q2_hourly
    UNION ALL
    SELECT * FROM BI_2013_q3_hourly
    UNION ALL
    SELECT * FROM BI_2013_q4_hourly
    UNION ALL
    SELECT * FROM BI_2014_q1_hourly 
)

SELECT 'preciptype' AS column_name, preciptype AS value FROM (SELECT DISTINCT preciptype FROM all_views) AS temp
UNION ALL
SELECT 'acorn' AS column_name, acorn AS value FROM (SELECT DISTINCT acorn FROM all_views) AS temp
UNION ALL
SELECT 'acorn_group' AS column_name, acorn_group AS value FROM (SELECT DISTINCT acorn_group FROM all_views) AS temp
UNION ALL
SELECT 'weather' AS column_name, weather AS value FROM (SELECT DISTINCT weather FROM all_views) AS temp
UNION ALL
SELECT 'holiday' AS column_name, holiday AS value FROM (SELECT DISTINCT holiday FROM all_views) AS temp;
