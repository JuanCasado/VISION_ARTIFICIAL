
import numpy as np
import cv2
import subprocess
import time
import os
import math
from fast_yolo import FastYolo
from yolo import Yolo
from faces import Faces
from movement_manager import MovementManager
from markov_filter import MarkovFilter
from color_matcher import ColorMatcher

draw = True
resize_factor = 0.5

#Create frame captures and configure image size
cap = cv2.VideoCapture(0)
cv2.waitKey(200)
_, frame = cap.read()
height, width = frame.shape[:2]
height = int(height*resize_factor)
width = int(width*resize_factor)
center_x = width/2
center_y = height/2
dim_x = int(width*0.2)
dim_y = int(height*0.48)

def capture_image ():
  _, frame = cap.read()
  return cv2.resize(frame, (width, height))

def init(image):
  #Elements to create
  yolo = FastYolo((height, width), 4)
  movement = MovementManager()
  faces = Faces()
  m = MarkovFilter(width)

  #Create a new full yolo for better recognition
  init_yolo = Yolo((dim_y*2, dim_x*2), tiny = False)
  color_matcher = ColorMatcher()

  #Display image and wait to let user position
  cv2.imshow('image', image)
  cv2.waitKey(2000)
  count = 0
  while count < 3:
    frame = capture_image ()
    frame = frame[int(center_y-dim_y):int(center_y+dim_y), int(center_x-dim_x):int(center_x+dim_x)]
    cv2.imshow('image', frame)
    #Learn faces and color
    faces.load_face(frame)
    locations = faces.get_faces(frame)
    match = faces.detect_face(frame, locations)
    boxes, in_distances, confidences, classids = init_yolo.infer_image(frame)
    if len(boxes)>0:
      for box in boxes:
        color_matcher.add_color(frame, box)
      init_yolo.set_color_matcher(color_matcher)

      #Show learning progress
      frame = init_yolo.draw(frame, boxes, in_distances, confidences, classids)
      frame = faces.draw(frame, locations, match)
      cv2.imshow('image', frame)
      cv2.waitKey(1)
      count += 1

  #Return loaded elements
  yolo.set_color_matcher(color_matcher)
  return yolo, movement, faces, m



frame = capture_image()
yolo, movement, faces, m = init(frame)
while(True):
  start = time.time()
  frame = capture_image()

  #Get Person boxes
  boxes, in_distances, confidences, classids = yolo.infer_image(frame)
  for box, in_distance in zip(boxes, in_distances):
    if in_distance:
      m.add_box(box, 1.5)
    movement.add_box(frame, box)
    m.add_box(box)
  
  #Get Person faces
  locations = faces.get_faces(frame)
  for location in locations:
    movement.add_face(frame, location)
    m.add_face(location)
  
  #Match faces with target
  match = faces.detect_face(frame, locations)
  m.add_face(match, 1.5)

  #Calculate movement between frames for each previous box
  movements = movement.get_movement(frame)
  for move in movements:
    if move.movement != 0:
      m.add_movement(move.get_box())

  #Update filter
  m.update_filter()
  max_x = m.get_max()

  #Draw images
  if draw:
    m.draw()
    frame = faces.draw(frame,locations, match)
    frame = yolo.draw(frame, boxes, in_distances, confidences, classids)
    for move in movements:
      frame = move.draw(frame)
    cv2.line(frame, (max_x,0), (max_x,height), (255, 0, 255), 2, lineType=cv2.LINE_AA)
    cv2.imshow('image', frame)

  end = time.time()
  print ("Elapsed: {:6f} seconds".format(end - start))
  key = cv2.waitKey(1)
  if key==ord('q'):
    break
  elif key==ord('r'):
    _, frame = cap.read()
    frame = cv2.resize(frame, (width, height))
    yolo, movement, faces, m = init(frame)

cap.release()
cv2.destroyAllWindows()
