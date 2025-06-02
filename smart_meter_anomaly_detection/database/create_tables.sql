
-- Table: Household_details
CREATE TABLE Household_details (
    LCL_ID VARCHAR(50) PRIMARY KEY,
    STD_OR_TOU VARCHAR(5) not null,
    ACORN VARCHAR(50) not null,
    ACORN_GROUP VARCHAR(255),
    ACORN_GROUP_Previous VARCHAR(255), --SCD Type 3,
    ACORN_GROUP_ChangedDate TIMESTAMP 
); 

-- Table: Tariffs
CREATE TABLE Tariffs (
    Date_Time TIMESTAMP not null UNIQUE,
    Tariff VARCHAR(25),
    Tariff_ID SERIAL PRIMARY KEY,
    Tariff_Previous VARCHAR(25), -- SCD Type 3
    Tariff_Changed_Date TIMESTAMP
);

-- Table: Bank_holidays
CREATE TABLE Dates_and_Holidays (
    Date_Time TIMESTAMP not null PRIMARY KEY,
    Holiday VARCHAR(25)
);

-- Table: Weather
CREATE TABLE Weather (
	visibility DECIMAL(10, 2) NOT NULL,
	windBearing INT NOT NULL,
	temperature DECIMAL(5, 2) NOT NULL,
	Date_Time TIMESTAMP NOT NULL,   
    dewPoint DECIMAL(5, 2) NOT NULL,
    pressure DECIMAL(7, 2),
    apparentTemperature DECIMAL(5, 2) NOT NULL,
    windSpeed DECIMAL(5, 2) NOT NULL,
    precipType VARCHAR(50),
    icon VARCHAR(50),
    humidity DECIMAL(3, 2)  NOT NULL,
    summary VARCHAR(255),
	Weather_ID SERIAL PRIMARY KEY,
    FOREIGN KEY (Date_Time) REFERENCES Dates_and_Holidays(Date_Time)
);


-- Parent table (unchanged):
CREATE TABLE Consumption_data (
    LCL_ID       VARCHAR(50) NOT NULL,
    STD_OR_TOU   VARCHAR(5)  NOT NULL,
    Date_Time    TIMESTAMP   NOT NULL,
    KWHperHR     DECIMAL(10, 6),
    Reading_ID   SERIAL,
    Tariff_ID    INT,
    FOREIGN KEY (LCL_ID) REFERENCES Household_details(LCL_ID),
    FOREIGN KEY (Tariff_ID) REFERENCES Tariffs(Tariff_ID),
    FOREIGN KEY (Date_Time) REFERENCES Dates_and_Holidays(Date_Time),
    CONSTRAINT datetime_format CHECK (
      to_char(Date_Time, 'DD/MM/YYYY HH24:MI:SS') = to_char(Date_Time, 'DD/MM/YYYY HH24:MI:SS')
    ),
    CONSTRAINT consumption_data_pk PRIMARY KEY (Reading_ID, Date_Time)
)
PARTITION BY RANGE (Date_Time);


-- altered for etl
ALTER TABLE Consumption_data 
ADD CONSTRAINT unique_lcl_id_datetime 
UNIQUE (LCL_ID, Date_Time);


-- 2011 partition
CREATE TABLE consumption_data_2011
  PARTITION OF consumption_data
  FOR VALUES FROM ('2011-01-01') TO ('2012-01-01')
  PARTITION BY RANGE (Date_Time);

-- 2012 partition 
CREATE TABLE consumption_data_2012
  PARTITION OF consumption_data
  FOR VALUES FROM ('2012-01-01') TO ('2013-01-01')
  PARTITION BY RANGE (Date_Time);

-- 2013 partition
CREATE TABLE consumption_data_2013
  PARTITION OF consumption_data
  FOR VALUES FROM ('2013-01-01') TO ('2014-01-01')
  PARTITION BY RANGE (Date_Time);

-- 2014 partition 
CREATE TABLE consumption_data_2014
  PARTITION OF consumption_data
  FOR VALUES FROM ('2014-01-01') TO ('2015-01-01')
  PARTITION BY RANGE (Date_Time);


-- Quarterly partitions for each year
-- For 2011: We define Q1, Q2, Q3, Q4, 

-- 2011

CREATE TABLE consumption_data_2011_q1
  PARTITION OF consumption_data_2011
  FOR VALUES FROM ('2011-01-01') TO ('2011-04-01');

CREATE TABLE consumption_data_2011_q2
  PARTITION OF consumption_data_2011
  FOR VALUES FROM ('2011-04-01') TO ('2011-07-01');

CREATE TABLE consumption_data_2011_q3
  PARTITION OF consumption_data_2011
  FOR VALUES FROM ('2011-07-01') TO ('2011-10-01');

CREATE TABLE consumption_data_2011_q4
  PARTITION OF consumption_data_2011
  FOR VALUES FROM ('2011-10-01') TO ('2012-01-01');

-- 2012

CREATE TABLE consumption_data_2012_q1
  PARTITION OF consumption_data_2012
  FOR VALUES FROM ('2012-01-01') TO ('2012-04-01');

-- Q2:
CREATE TABLE consumption_data_2012_q2
  PARTITION OF consumption_data_2012
  FOR VALUES FROM ('2012-04-01') TO ('2012-07-01');

-- Q3: 
CREATE TABLE consumption_data_2012_q3
  PARTITION OF consumption_data_2012
  FOR VALUES FROM ('2012-07-01') TO ('2012-10-01');

-- Q4:
CREATE TABLE consumption_data_2012_q4
  PARTITION OF consumption_data_2012
  FOR VALUES FROM ('2012-10-01') TO ('2013-01-01');


-- 2013
-- q1
CREATE TABLE consumption_data_2013_q1
  PARTITION OF consumption_data_2013
  FOR VALUES FROM ('2013-01-01') TO ('2013-04-01');

-- q2

CREATE TABLE consumption_data_2013_q2
  PARTITION OF consumption_data_2013
  FOR VALUES FROM ('2013-04-01') TO ('2013-07-01');

-- q3

CREATE TABLE consumption_data_2013_q3
  PARTITION OF consumption_data_2013
  FOR VALUES FROM ('2013-07-01') TO ('2013-10-01');

-- q4

CREATE TABLE consumption_data_2013_q4
  PARTITION OF consumption_data_2013
  FOR VALUES FROM ('2013-10-01') TO ('2014-01-01');

-- 2014
--q1
CREATE TABLE consumption_data_2014_q1
  PARTITION OF consumption_data_2014
  FOR VALUES FROM ('2014-01-01') TO ('2014-04-01');
-- q2
CREATE TABLE consumption_data_2014_q2
  PARTITION OF consumption_data_2014
  FOR VALUES FROM ('2014-04-01') TO ('2014-07-01');
-- q3
CREATE TABLE consumption_data_2014_q3
  PARTITION OF consumption_data_2014
  FOR VALUES FROM ('2014-07-01') TO ('2014-10-01');
-- q4
CREATE TABLE consumption_data_2014_q4
  PARTITION OF consumption_data_2014
  FOR VALUES FROM ('2014-10-01') TO ('2015-01-01');


/*not implemented*/
--Triggers for SCD
CREATE OR REPLACE FUNCTION scd3_update_tariff()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- If the new Tariff value differs from the old one, update the "previous" column
    IF NEW.Tariff IS DISTINCT FROM OLD.Tariff THEN
        NEW.Tariff_Previous = OLD.Tariff;
        NEW.Tariff_Changed_Date = NOW();
    END IF;

    RETURN NEW;
END;
$$;


CREATE OR REPLACE FUNCTION scd3_update_household()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    -- Only apply logic if ACORN_GROUP is actually changing
    IF NEW.ACORN_GROUP IS DISTINCT FROM OLD.ACORN_GROUP THEN
        -- Move old current ACORN_GROUP into the "previous" column
        NEW.ACORN_GROUP_Previous = OLD.ACORN_GROUP;
        
        -- Set the changed date to now (or use transaction_timestamp())
        NEW.ACORN_GROUP_ChangedDate = NOW();
    END IF;

    -- Return the modified NEW row to complete the update
    RETURN NEW;
END;
$$;







