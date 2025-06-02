/* Examining correlation within the features(determining if positive or negative correlations exist) 

will use postgres corr(x, y) function where x and y are the columns being compared.

It uses Pearson correlation which measures linear correlations
https://www.scribbr.com/statistics/pearson-correlation-coefficient/

I may use sp

*/

-- First checked the distribution of my data 

SELECT 
    (COUNT(*) FILTER (WHERE ABS(hourly_mean_reading) > 3) * 100.0 / COUNT(*)) AS outlier_percentage
FROM (select hourly_mean_reading from all_data);

/*
"outlier_percentage"
0.07499836996285662778

The data does not have a lot of outliars.
*/
--Skewness:
-- Measure the asymmetry of hourly_mean_readings.
SELECT 
    AVG(POWER(hourly_mean_reading, 3)) AS skewness
FROM (select hourly_mean_reading from all_data);
/*
"skewness"
0.1834748657292296740623022
slightly positively skewed showing little outliers. But not enough to
distort the shape

https://medium.com/@vipinnation/mastering-skewness-a-guide-to-handling-and-transforming-data-in-machine-learning-0a42773a026f#:~:text=Understanding%20Skewness&text=Skewness%20can%20manifest%20in%20two,few%20outliers%20on%20the%20right.

*/


-- Will use lo transformation to fix the right skewness of my data as recommended above
/*

As 0 values might affect this transformation i need to check them first



*/



-- Now i can check for correlation

SELECT 
  corr(hourly_mean_reading, weather) AS corr_reading_weather,
  corr(hourly_mean_reading, tariff) AS corr_reading_tariff
FROM (select hourly_mean_reading, weather, tariff from
all_views);



/*
output:
"corr_reading_weather"	"corr_reading_tariff"
-0.027086214159557285	0.00843134881360472

-- Shows that the values are nearly un-correlated showing that independent variables have
close to no impact on the dependent variable.

*/

