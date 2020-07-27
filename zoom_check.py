import psutil
import time
# Iterate over all running process
from datetime import datetime



while True:
	for proc in psutil.process_iter():
	    try:
	        # Get process name & pid from process object.
	        processName = proc.name()
	        processID = proc.pid

	        if 'zoom' in processName:

	         print('Found : ',processName , ' ::: ', processID)
	         now = datetime.now()

	         current_time = now.strftime("%H:%M:%S")
	         print("Current Time =", current_time)
	    except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
	         pass
	print("Completed one iteration")         
	time.sleep(10)      
