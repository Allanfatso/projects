import csv
from datetime import datetime, timedelta


START_DATE = datetime(2011, 11, 1, 0, 0, 0)
END_DATE   = datetime(2014, 2, 28, 23, 30, 0)
INTERVAL   = timedelta(minutes=30)  # half-hour increments


HOLIDAY_CSV = "C:/Users/racon/Downloads/Small_LCL_Data/uk_bank_holidays.csv"
OUTPUT_CSV = "C:/Users/racon/Downloads/Small_LCL_Data/ammended.csv"


def load_holidays(csv_file):
    """
    Reads the holiday CSV (with "Holiday" and "Type" columns),
    returning a dictionary { date_string_YYYYMMDD: holiday_name }.
    
    Example input row:
        Holiday,Type
        25/12/2012 00:00,Christmas Day
    
    We only store the date portion ('YYYY-MM-DD') as key.
    """
    holidays_dict = {}
    
    with open(csv_file, mode='r', newline='', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            # row["Holiday"] might look like "25/12/2012 00:00"
            # We parse it into a datetime, then keep only the date.
            h_str = row["Holiday"].strip()
            holiday_type = row["Type"].strip()
            
            dt = datetime.strptime(h_str, "%d/%m/%Y %H:%M")
            date_key = dt.strftime("%Y-%m-%d")

            holidays_dict[date_key] = holiday_type

    return holidays_dict


def generate_dates(start_dt, end_dt, interval):
    """
    Yields half-hour (or other interval) datetimes from start to end.
    """
    current = start_dt
    while current <= end_dt:
        yield current
        current += interval


def main():
    
    holiday_dict = load_holidays(HOLIDAY_CSV)
    

    with open(OUTPUT_CSV, mode='w', newline='', encoding='utf-8') as out_f:
        writer = csv.writer(out_f)
        writer.writerow(["DateTime", "Type"])
        
        for dt in generate_dates(START_DATE, END_DATE, INTERVAL):
            date_key = dt.strftime("%Y-%m-%d")

            if date_key in holiday_dict:
                day_type = holiday_dict[date_key]
            else:
                day_type = "normal day"
            

            dt_str = dt.strftime("%d/%m/%Y %H:%M:%S")
            
            # Write to CSV
            writer.writerow([dt_str, day_type])
    
    print("CSV generation complete:", OUTPUT_CSV)


if __name__ == "__main__":
    main()
