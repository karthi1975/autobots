import time
import numpy as np
import cv2
import pyautogui


fourcc = cv2.VideoWriter_fourcc(*"XVID") #you can use other codecs as well.
out = cv2.VideoWriter('output.avi', fourcc, 20.0, (pyautogui.size()))
t_end = time.time() + 30
while time.time() < t_end:
#while(True):
	img = pyautogui.screenshot()
	frame = np.array(img)
	frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
	out.write(frame)
	#cv2.imshow("frame", frame)
	
	# if cv2.waitKey(1) == ord("q"):
	#  break


cv2.destroyAllWindows()
out.release()