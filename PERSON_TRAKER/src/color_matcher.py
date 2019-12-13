
import numpy as np
import cv2
import subprocess
import time
import os
import math

class ColorMatcher:

  def __init__ (self, max_distance = 0.2):
    self.b = 0
    self.g = 0
    self.r = 0
    self.count = 0
    self.color = []
    self.max_distance = max_distance

  def add_color (self, image, box):
    self.count += 1
    color = self.mean_color (image, box)
    self.b += color[0]
    self.g += color[1]
    self.r += color[2]
    self.color = (self.b/self.count, self.g/self.count, self.r/self.count)

    
  def mean_color (self, image, box):
    x, y = box[0], box[1]
    w, h = box[2], box[3]
    center_x = x+w/2
    center_y = y+h/2
    dim = min(w,h)/8
    cropped_image = image[int(center_y-dim):int(center_y+dim), int(center_x-dim):int(center_x+dim)]
    #cv2.imshow('crop', cropped_image)
    brightens = np.mean(cv2.cvtColor(cropped_image, cv2.COLOR_RGB2GRAY))
    b_chanel,g_chanel,r_chanel = cv2.split(cropped_image)
    image_size = len(b_chanel)*len(b_chanel[1])
    def mean_channel_high_contrast (chanel):
      nonlocal image_size, brightens
      acc = 0; count = 0
      for row in chanel:
        for pixel in row:
          if pixel >= brightens: acc += 1
      return acc/image_size
    return (mean_channel_high_contrast(b_chanel),
            mean_channel_high_contrast(g_chanel),
            mean_channel_high_contrast(r_chanel))

  def color_distance(self, image, box):
    color = self.mean_color(image, box)
    acc = 0
    for c1, c2 in zip(self.color, color):
      acc += math.pow(c1-c2,2)
    #print((color, self.color, math.sqrt(acc/len(self.color))))
    return math.sqrt(acc/len(self.color))

  def in_distance(self, image, box):
    return self.color_distance(image, box) < self.max_distance

  def draw(self, image, box, color=True):
    x, y = box[0], box[1]
    w, h = box[2], box[3]
    center_x = x+w/2
    center_y = y+h/2
    dim = min(w,h)/8
    if color:
      mean_color = self.mean_color (image, box)
      color = (int(mean_color[0]*255), int(mean_color[1]*255), int(mean_color[2]*255))
    else:
      color = (0, 255, 255)
    cv2.rectangle(image, (int(center_x-dim),int(center_y-dim)), (int(center_x+dim),int(center_y+dim)), color, 3)
    return image