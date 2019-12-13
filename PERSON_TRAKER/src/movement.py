
import numpy as np
import cv2
import subprocess
import time
import os
import math

class Movement:

  def __init__(self, image, box, iter):
    self.box = box
    x, y = abs(self.box[0]), abs(self.box[1])
    w, h = abs(self.box[2]), abs(self.box[3])
    cropped_image = image[y:y+h, x:x+w]
    self.cropped_image = cv2.cvtColor(cropped_image,cv2.COLOR_BGR2GRAY)
    self.iter = iter
    self.x = 0
    self.y = 0
    self.movement = 0

  def get_movement (self, image):
    x, y = abs(self.box[0]), abs(self.box[1])
    w, h = abs(self.box[2]), abs(self.box[3])
    cropped_image = image[y:y+h, x:x+w]
    cropped_image = cv2.cvtColor(cropped_image,cv2.COLOR_BGR2GRAY)
    flow = cv2.calcOpticalFlowFarneback(self.cropped_image, cropped_image, None, 0.5, 3, 15, 3, 5, 1.2, 0)
    x = 0
    y = 0
    count = 0
    for obj in flow:
      for vector in obj:
        x+=vector[0]
        y+=vector[1]
        count += 1
    self.x = x/count * 3
    self.y = y/count * 3
    magnitude = math.sqrt(math.pow(self.x,2) + math.pow(self.y,2))
    angle = math.atan2(self.x ,self.y)
    if magnitude > 1:
      if angle > math.pi/4 and angle < 3*math.pi/4:
        self.movement = 1
      elif angle < -math.pi/4 and angle > -3*math.pi/4:
        self.movement = -1
    else:
      self.movement = 0
    return self.movement

  def get_box (self):
    x, y = abs(self.box[0]), abs(self.box[1])
    w, h = abs(self.box[2]), abs(self.box[3])
    return (x+self.x, y, h, w*1.2)

  def draw (self, image):
    x, y = abs(self.box[0]), abs(self.box[1])
    w, h = abs(self.box[2]), abs(self.box[3])
    center = (int(x+w/2), int(y+h/2))
    if self.movement and ((self.x != 0) or (self.y != 0)):
      cv2.arrowedLine(image, center, (int(center[0]+self.x), int(center[1]+self.y)), (0, 255, 255), 2, line_type=cv2.LINE_AA)
      return image
    else:
      return image
