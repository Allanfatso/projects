EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    date_trunc('week', c.date_time) AS week_start,
    SUM(c.kwhperhr)                AS total_kwh,
    AVG(c.kwhperhr)                AS avg_kwh,
    COUNT(*)                       AS row_count
FROM consumption_data c
WHERE c.date_time >= '2012-01-01'
  AND c.date_time <  '2014-01-01'
GROUP BY date_trunc('week', c.date_time)
ORDER BY week_start;


-- To clean up and optimize but with downtime.
VACUUM FULL VERBOSE ANALYZE;