import pyaudio
import wave
import os
from datetime import datetime
from playsound import playsound
import threading
import time




def soundrecord_function():
	# datetime object containing current date and time
	now = datetime.now()
	print("now =", now)

	# mm_dd_YY_H_M_S
	dt_string = now.strftime("%m_%d_%Y_%H_%M_%S")

	defaultframes = 512


	recorded_frames = []
	device_info = {}
	useloopback = False
	recordtime = 5

	#Use module
	p = pyaudio.PyAudio()

	#Get input or default
	#device_id = 4

	#Get device info
	try:
	    device_info = p.get_device_info_by_index(5)
	except IOError:
	    device_info = p.get_device_info_by_index(default_device_index)
	    print ("Selection not available, using default.")

	#Choose between loopback or standard mode
	is_input = device_info["maxInputChannels"] > 0
	is_wasapi = (p.get_host_api_info_by_index(device_info["hostApi"])["name"]).find("WASAPI") != -1
	if is_input:
	    print ("Selection is input using standard mode.\n")
	else:
	    if is_wasapi:
	        useloopback = True;
	        print ( "Selection is output. Using loopback mode.\n")
	    else:
	        print ("Selection is input and does not support loopback mode. Quitting.\n")
	        exit()


	recordtime = 10
	#Open stream
	channelcount = device_info["maxInputChannels"] if (device_info["maxOutputChannels"] < device_info["maxInputChannels"]) else device_info["maxOutputChannels"]
	stream = p.open(format = pyaudio.paInt16,
	                channels = channelcount,
	                rate = int(device_info["defaultSampleRate"]),
	                input = True,
	                frames_per_buffer = defaultframes,
	                input_device_index = device_info["index"],
	                as_loopback = useloopback)


	print("Starting...")

	for i in range(0, int(int(device_info["defaultSampleRate"]) / defaultframes * recordtime)):
	    recorded_frames.append(stream.read(defaultframes))
	    # print (".")


	#Stop Recording

	stream.stop_stream()
	stream.close()

	#Close module
	p.terminate()

	filename = "soundout5"+dt_string+".wav"
	waveFile = wave.open(filename, 'wb')
	waveFile.setnchannels(channelcount)
	waveFile.setsampwidth(p.get_sample_size(pyaudio.paInt16))
	waveFile.setframerate(int(device_info["defaultSampleRate"]))
	waveFile.writeframes(b''.join(recorded_frames))
	waveFile.close()
	print ("End.")


# def play_function(name):
#     playsound('john_wayne.wav')


# x = threading.Thread(target=play_function, args=(1,))
# x.start()
# time.sleep(1.0)
soundrecord_function()