
import numpy as np
import cv2
import subprocess
import time
import os
import math
from fast_yolo import FastYolo
from sort import *

draw = True
resize_factor = 0.5

#Create frame captures and configure image size
cap = cv2.VideoCapture(0)
cv2.waitKey(200)
_, frame = cap.read()
height, width = frame.shape[:2]
height = int(height*resize_factor)
width = int(width*resize_factor)

def capture_image ():
  _, frame = cap.read()
  return cv2.resize(frame, (width, height))

yolo = FastYolo((height, width))
tracker = Sort() 

while(True):
  start = time.time()
  frame = capture_image()

  #Get Person boxes
  detections = []
  boxes,in_distances,confidences,classids = yolo.infer_image(frame)
  for box, confidence in zip(boxes, confidences):
    x, y = abs(box[0]), abs(box[1])
    w, h = abs(box[2]), abs(box[3])
    detections.append([x, y, x+w, y+h, confidence])
    in_distances.append(False)

  track_ids = tracker.update(np.array(detections))
  print(track_ids)
  
  if draw:
    frame = yolo.draw(frame, boxes, in_distances, confidences, classids)
    for id in track_ids:
      text = "ID: {}".format(id[4])
      cv2.putText(frame, text, (x, y+20), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0,0,255), 2)
    cv2.imshow('image', frame)

  end = time.time()
  print ("Elapsed: {:6f} seconds".format(end - start))
  key = cv2.waitKey(1)
  if key==ord('q'):
    break

cap.release()
cv2.destroyAllWindows()
