
import numpy as np
import cv2
import subprocess
import os

class Yolo:

  def __init__(self,
      image_size,
      min_confidence = 0.4,
      nms_threshold = 0.3,
      tiny = True,
      persons_only = True):
    if tiny:
      config_src = './yolov3-coco/yolov3-tiny.cfg'
      weight_src = './yolov3-coco/yolov3-tiny.weights'
    else:
      config_src = './yolov3-coco/yolov3.cfg'
      weight_src = './yolov3-coco/yolov3.weights'
    labels_src = './yolov3-coco/coco-labels'
    self.height = image_size[0]
    self.width = image_size[1]
    self.min_confidence = min_confidence
    self.nms_threshold = nms_threshold
    self.persons_only = persons_only
    self.labels = open(labels_src).read().strip().split('\n')
    self.color_matcher = None
    self.net = cv2.dnn.readNetFromDarknet(config_src, weight_src)
    layer_names = self.net.getLayerNames()
    self.layer_names = [layer_names[i[0] - 1] for i in self.net.getUnconnectedOutLayers()]

  def draw (self, image, boxes, color_distances, confidences, classids):
    for box, color_distance, class_id, confidence in zip(boxes, color_distances, classids, confidences):
      x, y = abs(box[0]), abs(box[1])
      w, h = abs(box[2]), abs(box[3])
      if color_distance:
        color = (0, 255, 0)
      else:
        color = (0, 0, 255)
      cv2.rectangle(image, (x, y), (x+w, y+h), color, 3)
      text = "{}: {:4f}".format(self.labels[class_id], confidence)
      cv2.putText(image, text, (x, y-5), cv2.FONT_HERSHEY_SIMPLEX, self.min_confidence, color, 2)
      if self.color_matcher:
        image = self.color_matcher.draw(image, box)
    return image

  def set_color_matcher (self, color_matcher):
    self.color_matcher = color_matcher

  def generate_boxes_confidences_classids(self, outs, image):
    boxes = []
    confidences = []
    classids = []
    color_distances = []
    for out in outs:
      for detection in out:
        scores = detection[5:]
        class_id = np.argmax(scores)
        if (not self.persons_only) or (class_id==0):
          confidence = scores[class_id]
          if confidence > self.min_confidence:
            box = detection[0:4] * np.array([self.width, self.height, self.width, self.height])
            centerX, centerY, box_width, box_height = box.astype('int')
            x = int(centerX - (box_width / 2))
            y = int(centerY - (box_height / 2))
            new_box = [x, y, int(box_width), int(box_height)]
            boxes.append(new_box)
            confidences.append(float(confidence))
            classids.append(class_id)
            if self.color_matcher:
              color_distances.append(self.color_matcher.in_distance(image, new_box))
            else:
              color_distances.append(0)
    indices = cv2.dnn.NMSBoxes(boxes, confidences, self.min_confidence, self.nms_threshold)
    final_boxes = []
    final_confidences = []
    final_classids = []
    final_color_distances = []
    for i in indices:
      final_boxes.append(boxes[i[0]])
      final_confidences.append(confidences[i[0]])
      final_classids.append(classids[i[0]])
      if self.color_matcher:
        final_color_distances.append(color_distances[i[0]])
      else:
        final_color_distances.append(0)
    return final_boxes, final_color_distances , final_confidences, final_classids

  def infer_image(self, image):
    blob = cv2.dnn.blobFromImage(image, 1 / 255.0, (416, 416), swapRB=True, crop=False)
    self.net.setInput(blob)
    outs = self.net.forward(self.layer_names)
    return self.generate_boxes_confidences_classids(outs, image)
