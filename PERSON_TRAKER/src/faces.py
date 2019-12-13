

import numpy as np
import cv2
import subprocess
import time
import os
import math
import face_recognition

class Faces:

  def __init__(self):
    self.faces = []

  def load_face (self, image):
    faces = face_recognition.face_encodings(image)
    for face in faces:
      self.faces.append(face)

  def get_faces (self, image):
    image = image[:, :, ::-1]
    return face_recognition.face_locations(image)

  def get_landmarks(self, image):
    image = image[:, :, ::-1]
    return face_recognition.face_landmarks(image)
    
  def detect_face (self, image, face_locations):
    face_encodings = face_recognition.face_encodings(image, face_locations)
    for face_encoding,face_location in zip(face_encodings, face_locations):
      matches = face_recognition.compare_faces(self.faces, face_encoding)
      recognized = True
      for match in matches:
        recognized = recognized and match
      if recognized:
        return face_location
    return None
    
  def draw (self, image, face_locations, match=None):
    for (top, right, bottom, left) in face_locations:
      if (top, right, bottom, left) == match:
        cv2.rectangle(image, (left, top), (right, bottom), (0, 255, 0), 2)
      else:
        cv2.rectangle(image, (left, top), (right, bottom), (0, 0, 255), 2)
    return image

  def draw_landmarks (self, image, landmarks):
    for landmark_group in landmarks:
      for landmark in landmark_group.values():
        cv2.polylines(image,  np.array([landmark], np.int32),  False,  (0, 255, 0),  1)
    return image

if __name__ == '__main__':
  cap = cv2.VideoCapture(0)
  _, frame = cap.read()
  height, width = frame.shape[:2]
  height = int(height/2)
  width = int(width/2)
  frame = cv2.resize(frame, (width, height))

  faces = Faces()
  for i in range(1):
    _, frame = cap.read()
    faces.load_face(frame)
    time.sleep(1)

  while(True):
    start = time.time()
    _, frame = cap.read()
    frame = cv2.resize(frame, (width, height))

    locations = faces.get_faces(frame)
    face_landmarks_list = faces.get_landmarks(frame)
    match = faces.detect_face(frame, locations)
    
    image = faces.draw_landmarks(frame, face_landmarks_list)
    cv2.imshow('faces', faces.draw(image ,locations, match))
    
    end = time.time()
    print ("Elapsed: {:6f} seconds".format(end - start))
    if cv2.waitKey(1) & 0xFF == ord('q'):
      break

  cap.release()
  cv2.destroyAllWindows()