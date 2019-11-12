
import numpy as np
import cv2
import subprocess
import os

class Yolo:

  def __init__(self,
      image_size,
      min_confidence = 0.5,
      box_threshold = 0.3,
      tiny = True,
      persons_only = True,):
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
    self.box_threshold = box_threshold
    self.persons_only = persons_only
    self.labels = open(labels_src).read().strip().split('\n')
    self.colors = np.random.randint(0, 255, size=(len(self.labels), 3), dtype='uint8')
    self.net = cv2.dnn.readNetFromDarknet(config_src, weight_src)
    layer_names = self.net.getLayerNames()
    self.layer_names = [layer_names[i[0] - 1] for i in self.net.getUnconnectedOutLayers()]

  def draw (self, image, boxes, confidences, classids):
    box_indices = cv2.dnn.NMSBoxes(boxes, confidences, self.min_confidence, self.box_threshold)
    if len(box_indices) > 0:
      for i in box_indices.flatten():
        x, y = boxes[i][0], boxes[i][1]
        w, h = boxes[i][2], boxes[i][3]
        color = [int(c) for c in self.colors[classids[i]]]
        cv2.rectangle(image, (x, y), (x+w, y+h), color, 2)
        text = "{}: {:4f}".format(self.labels[classids[i]], confidences[i])
        cv2.putText(image, text, (x, y-5), cv2.FONT_HERSHEY_SIMPLEX, self.min_confidence, color, 2)
    return image

  def generate_boxes_confidences_classids(self, outs):
    boxes = []
    confidences = []
    classids = []
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
            boxes.append([x, y, int(box_width), int(box_height)])
            confidences.append(float(confidence))
            classids.append(class_id)
    return boxes, confidences, classids

  def infer_image(self, image):
    blob = cv2.dnn.blobFromImage(image, 1 / 255.0, (416, 416), swapRB=True, crop=False)
    self.net.setInput(blob)
    outs = self.net.forward(self.layer_names)
    
    return self.generate_boxes_confidences_classids(outs)
