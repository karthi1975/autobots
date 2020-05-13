import time
import numpy as np
import cv2
import pyautogui
import pyaudio
import wave
import os
from datetime import datetime
from playsound import playsound
import threading

def play_function(name):
    playsound('john_wayne.wav')

fourcc = cv2.VideoWriter_fourcc(*"XVID") #you can use other codecs as well.
out = cv2.VideoWriter('output5.avi', fourcc, 20.0, (pyautogui.size()))
t_end = time.time() + 45

x = threading.Thread(target=play_function, args=(1,))
x.start()


while time.time() < t_end:
	img = pyautogui.screenshot()
	frame = np.array(img)
	frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

	out.write(frame)

cv2.destroyAllWindows()
out.release()



