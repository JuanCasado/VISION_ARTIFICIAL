
import numpy as np
import cv2
import subprocess
import os
from yolo import Yolo

class FastYolo:

  def __init__(self,
      image_size,
      rate = 6,
      min_confidence = 0.4,
      nms_threshold = 0.3,
      persons_only = True):
    self.yolo = Yolo(image_size, min_confidence = min_confidence, nms_threshold = nms_threshold, persons_only = persons_only, tiny = False)
    self.yolo_tiny = Yolo(image_size, min_confidence = min_confidence, nms_threshold = nms_threshold, persons_only = persons_only, tiny = True)
    self.iter = 0
    self.rate = rate

  def draw (self, image, boxes, color_distances, confidences, classids):
    if self.iter == 0:
      return self.yolo.draw(image, boxes, color_distances, confidences, classids)
    else:
      return self.yolo_tiny.draw(image, boxes, color_distances, confidences, classids)

  def generate_boxes_confidences_classids(self, outs):
    if self.iter == 0:
      return self.yolo.generate_boxes_confidences_classids(outs)
    else:
      return self.yolo_tiny.generate_boxes_confidences_classids(outs)

  def infer_image(self, image):
    self.iter = (self.iter+1) % self.rate
    if self.iter == 0:
      return self.yolo.infer_image(image)
    else:
      return self.yolo_tiny.infer_image(image)

  def set_color_matcher(self, color_matcher):
    self.yolo.set_color_matcher(color_matcher)
    self.yolo_tiny.set_color_matcher(color_matcher)