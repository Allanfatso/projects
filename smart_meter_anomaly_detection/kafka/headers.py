# dir with code ~/data/headers
# virtual environment created using
# python3 -m venv .venv (folder .venv contains py installation independent of 
# systems py)
# to activate it: source .venv/bin/activate
# shutil installed in that env for moving files
# the following script uses watchdog to listen for file changes


# no hangup nohup will be used to run the script in the background
# nohup python3 headers.py &
# to see whether it's running: ps aux | grep headers.py
# to stop it: kill <PID> (PID is the process id ps output)
# for script output: cat nohup.out



import os
import csv
import shutil 
import time
from datetime import datetime  # for timestamps

# dir to be monitored
monitor = "/home/confluent/data/headers"
# dir to save the processed file
spool_dir = "/home/confluent/data/unprocessed"
# dir to save the logs with failed files
log_file = "/home/confluent/data/headers/failed_files.txt"


# Old and new headers
old_headers = ['LCLid', 'stdorToU', 'DateTime', 'KWH/hh (per half hour)']
new_headers = ['LCL_ID', 'STD_OR_TOU', 'Date_Time', 'KWHperHR']

# processed files
processed_files = set()

# function that updates old headers to new headers

def transform_headers(filepath):
    with open(filepath, 'r', newline='') as infile:
        reader = csv.reader(infile)
        headers = next(reader)
        if not headers:
            print("no headers found, check log")
            return # if file is empty
        
        stripped_headers = [h.strip() for h in headers]
        if stripped_headers == old_headers:
            data = list(reader)  
            with open(filepath, 'w', newline='') as outfile:
                writer = csv.writer(outfile)
                writer.writerow(new_headers)
                writer.writerows(data)
            return True
        else:
            return False

interval = 300
def send_files_to_connector(interval):
    
    # Poll monitor dir every interval seconds for new CSVs to process.
    while True:
        csv_files = [f for f in os.listdir(monitor) if f.endswith('.csv')]

        for filename in csv_files:
            if filename not in processed_files:
                src_path = os.path.join(monitor, filename)
                success = transform_headers(src_path)

                if success:
                    # Move the file to SPOOL_DIR so Kafka’s spool connector can pick it up
                    dest_path = os.path.join(spool_dir, filename)
                    shutil.move(src_path, dest_path)
                    print(f"Success. Updated headers and moved: {filename}")
                else:
                    # Log the failure
                    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                    with open(log_file, 'a') as logf:
                        logf.write(f"{timestamp} | {filename} - HEADERS MISMATCH OR EMPTY\n")
                    print(f"Fail. Logged mismatch for: {filename}")
                processed_files.add(filename)

        
        time.sleep(interval)

if __name__ == "__main__":
    send_files_to_connector(interval)
    
    
    