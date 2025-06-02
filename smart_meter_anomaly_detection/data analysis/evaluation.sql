--Unequal distribution of acorn_group means data is inherently flawed and acorn_group is not the best indicator.
SELECT acorn_group, COUNT(DISTINCT lcl_id) AS household_count
FROM all_data
GROUP BY acorn_group
ORDER BY household_count DESC;


-- target encoding
SELECT round(avg(hourly_mean_reading), 4), acorn_group
FROM all_data
GROUP BY acorn_group;
