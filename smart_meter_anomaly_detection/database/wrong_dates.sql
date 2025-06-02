UPDATE Dates_and_Holidays
SET holiday = 
CASE
    -- Boxing Day
    WHEN date_time::date = '2011-12-26' THEN 'Boxing Day'
    WHEN date_time::date = '2012-12-26' THEN 'Boxing Day'
    WHEN date_time::date = '2013-12-26' THEN 'Boxing Day'
    WHEN date_time::date = '2014-12-26' THEN 'Boxing Day'



    -- Christmas Day
    WHEN date_time::date = '2011-12-25' THEN 'Christmas Day'
    WHEN date_time::date = '2012-12-25' THEN 'Christmas Day'
    WHEN date_time::date = '2013-12-25' THEN 'Christmas Day'
    WHEN date_time::date = '2014-12-25' THEN 'Christmas Day'

    -- New Year’s Day
    WHEN date_time::date = '2012-01-01' THEN 'New Year Day'
    WHEN date_time::date = '2013-01-01' THEN 'New Year Day'
    WHEN date_time::date = '2014-01-01' THEN 'New Year Day'

    -- Good Friday
    WHEN date_time::date = '2012-04-06' THEN 'Good Friday'
    WHEN date_time::date = '2013-03-29' THEN 'Good Friday'


    -- Easter Monday
    WHEN date_time::date = '2012-04-09' THEN 'Easter Monday'
    WHEN date_time::date = '2013-04-01' THEN 'Easter Monday'

    -- Early May bank holiday
    WHEN date_time::date = '2012-05-07' THEN 'Early May bank holiday'
    WHEN date_time::date = '2013-05-06' THEN 'Early May bank holiday'

    -- Spring bank holiday
    WHEN date_time::date = '2012-06-04' THEN 'Spring bank holiday'
    WHEN date_time::date = '2013-05-27' THEN 'Spring bank holiday'

    -- Summer bank holiday
    WHEN date_time::date = '2012-08-27' THEN 'Summer bank holiday'
    WHEN date_time::date = '2013-08-26' THEN 'Summer bank holiday'

    -- Queen’s Diamond Jubilee
    WHEN date_time::date = '2012-06-05' THEN 'Queen Diamond Jubilee'
    WHEN date_time::date = '2013-06-05' THEN 'Queen Diamond Jubilee'

    -- Default: Normal Day
    ELSE 'normal day'
END
WHERE holiday = 'normal day';
