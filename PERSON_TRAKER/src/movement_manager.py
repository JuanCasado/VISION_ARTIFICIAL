

import numpy as np
import cv2
import subprocess
import time
import os
import math
from movement import Movement

class MovementManager:

  def __init__(self):
    self.iter = 0
    self.movements = []

  def add_box (self, image, box):
    self.movements.append(Movement(image, box, self.iter))

  def add_face (self, image, face):
    (top, right, bottom, left) = face
    self.movements.append(Movement(image, (left, top, right-left, bottom-top), self.iter))

  def get_movement (self, image):
    not_calculated_movements = []
    calculated_movements = []
    for movement in self.movements:
      if movement.iter < self.iter:
        movement.get_movement(image)
        calculated_movements.append(movement)
      else:
        not_calculated_movements.append(movement)
    self.movements = not_calculated_movements
    self.iter += 1
    return calculated_movements