
import numpy as np
import cv2
import subprocess
import time
import os
from yolo_utils import infer_image

cap = cv2.VideoCapture(0)
labels = open('./yolov3-coco/coco-labels').read().strip().split('\n')


colors = np.random.randint(0, 255, size=(len(labels), 3), dtype='uint8')
net = cv2.dnn.readNetFromDarknet('./yolov3-coco/yolov3.cfg', './yolov3-coco/yolov3.weights')
layer_names = net.getLayerNames()
layer_names = [layer_names[i[0] - 1] for i in net.getUnconnectedOutLayers()]

count = 0

while(True):
  _, frame = cap.read()
  height, width = frame.shape[:2]
  height = int(height/2)
  width = int(width/2)
  frame = cv2.resize(frame, (width, height))

  if count == 0:
    frame, boxes, confidences, classids, idxs = infer_image(net, layer_names, height, width, frame, colors, labels)
    count += 1
  else:
    frame, boxes, confidences, classids, idxs = infer_image(net, layer_names, height, width, frame, colors, labels, boxes, confidences, classids, idxs, infer=False)
    count = (count + 1) % 6


  cv2.imshow('frame',frame)
  if cv2.waitKey(1) & 0xFF == ord('q'):
    break

cap.release()
cv2.destroyAllWindows()