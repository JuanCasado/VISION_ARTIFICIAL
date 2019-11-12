
import numpy as np
import cv2
import subprocess
import time
import os
import math
import face_recognition
from yolo import Yolo

cap = cv2.VideoCapture(0)
_, frame = cap.read()
height, width = frame.shape[:2]
height = int(height/2)
width = int(width/2)
frame = cv2.resize(frame, (width, height))

yolo = Yolo((height, width), tiny=True)

iter = 1
boxes = []
first_image_chunks = []
second_image_chunks = []

faces = []
for i in range(1):
  _, frame = cap.read()
  faces.append(face_recognition.face_encodings(frame)[0])
  time.sleep(1)

while(True):
  start = time.time()
  _, frame = cap.read()
  frame = cv2.resize(frame, (width, height))
  if iter%2:
    first_image_chunks = []
    boxes, confidences, classids = yolo.infer_image(frame)
    for box in boxes:
      x, y = abs(box[0]), abs(box[1])
      w, h = abs(box[2]), abs(box[3])
      cropped_image = frame[y:y+h, x:x+w]
      first_image_chunks.append(cv2.cvtColor(cropped_image,cv2.COLOR_BGR2GRAY))
  else:
    second_image_chunks = []
    for box in boxes:
      x, y = abs(box[0]), abs(box[1])
      w, h = abs(box[2]), abs(box[3])
      cropped_image = frame[y:y+h, x:x+w]
      second_image_chunks.append(cv2.cvtColor(cropped_image,cv2.COLOR_BGR2GRAY))
    for current, previous in zip(second_image_chunks, first_image_chunks):
      flow = cv2.calcOpticalFlowFarneback(previous,current, None, 0.5, 3, 15, 3, 5, 1.2, 0)
      x = 0
      y = 0
      for obj in flow:
        for vector in obj:
          x+=vector[0]
          y+=vector[1]
      magnitude = math.sqrt(math.pow(x,2) + math.pow(y,2))
      angle = math.atan2(x,y)
      if magnitude > 10000:
        if angle > math.pi/4 and angle < 3*math.pi/4:
          print("DERECHA")
        elif angle < -math.pi/4 and angle > -3*math.pi/4:
          print("IZQUIERDA")

  unknown_face_encoding = face_recognition.face_encodings(frame)
  if len(unknown_face_encoding)>0:
    results = False
    for face in faces:
      results = results or face_recognition.compare_faces([face], unknown_face_encoding[0])[0]
    if results == True:
      print("It's a picture of me!")

  cv2.imshow('frame', yolo.draw(frame, boxes, confidences, classids))

  iter += 1
  end = time.time()
  print ("Elapsed: {:6f} seconds".format(end - start))
  if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()