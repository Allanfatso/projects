-- To see if normalisation or scaling is needed
SELECT 
  MIN(hourly_mean_reading) AS min_value,
  MAX(hourly_mean_reading) AS max_value,
  AVG(hourly_mean_reading) AS avg_value,
  STDDEV(hourly_mean_reading) AS std_dev,
  VARIANCE(hourly_mean_reading) AS variance
FROM 
(
select hourly_mean_reading from BI_all_years_machine_learning 
)




/*output


"min_value"	"max_value"	"avg_value"	"std_dev"	"variance"
0	10.761	0.20912834162924077	0.29378608592403777	0.08631026428256611

max value may skew some values because the standard deviation is low meaning most values are closer to the average.

Given this data—where most values are very small but the maximum is much higher—min‑max 
scaling might compress most of the data near 0. Whilst, z‑score standardization will 
transform values relative to the mean and standard deviation, 
making it easier to detect points that lie many standard deviations away.


Min-max normalization has one fairly significant downside:
 it does not handle outliers very well. For example, if you
  have 99 values between 0 and 40, and one value is 100, then 
  the 99 values will all be transformed to a value between 0 and 0.4. 
  That data is just as squished as before! Take a look at the image below to see an example of this.
  https://www.codecademy.com/article/normalization





*/

-- Z-scaling



