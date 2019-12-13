
import numpy as np
import cv2
import subprocess
import time
import os
import math
import pytesseract

class TextRecognition:

  def __init__(self, image_size, confidence = 0.5, nms_threshold=0.4):
    self.net = cv2.dnn.readNet('./east_text_detection/frozen_east_text_detection.pb')
    self.height = image_size[0]
    self.width = image_size[1]
    self.outputLayers = []
    self.outputLayers.append("feature_fusion/Conv_7/Sigmoid")
    self.outputLayers.append("feature_fusion/concat_3")
    self.confidence = confidence
    self.nms_threshold = nms_threshold

  def decode(self, scores, geometry, scoreThresh):
    detections = []
    confidences = []
    height = scores.shape[2]
    width = scores.shape[3]
    for y in range(0, height):
      # Extract data from scores
      scoresData = scores[0][0][y]
      x0_data = geometry[0][0][y]
      x1_data = geometry[0][1][y]
      x2_data = geometry[0][2][y]
      x3_data = geometry[0][3][y]
      anglesData = geometry[0][4][y]
      for x in range(0, width):
        score = scoresData[x]
        # If score is lower than threshold score, move to next x
        if(score < scoreThresh):
          continue
        # Calculate offset
        offsetX = x * 4.0
        offsetY = y * 4.0
        angle = anglesData[x]
        # Calculate cos and sin of angle
        cosA = math.cos(angle)
        sinA = math.sin(angle)
        h = x0_data[x] + x2_data[x]
        w = x1_data[x] + x3_data[x]
        # Calculate offset
        offset = ([offsetX + cosA * x1_data[x] + sinA * x2_data[x], offsetY - sinA * x1_data[x] + cosA * x2_data[x]])
        # Find points for rectangle
        p1 = (-sinA * h + offset[0], -cosA * h + offset[1])
        p3 = (-cosA * w + offset[0],  sinA * w + offset[1])
        center = (0.5*(p1[0]+p3[0]), 0.5*(p1[1]+p3[1]))
        detections.append((center, (w,h), -1*angle * 180.0 / math.pi))
        confidences.append(float(score))
    # Return detections and confidences
    return [detections, confidences]

  def get_text (self, image):
    blob = cv2.dnn.blobFromImage(image, 1.0, (320, 320), (123.68, 116.78, 103.94), True, False)
    self.net.setInput(blob)
    outputLayers = ("feature_fusion/Conv_7/Sigmoid", "feature_fusion/concat_3")
    output = self.net.forward(outputLayers)
    scores = output[0]
    geometry = output[1]
    [boxes, confidences] = self.decode(scores, geometry, self.confidence)
    indices = cv2.dnn.NMSBoxesRotated(boxes, confidences, self.confidence,self.nms_threshold)
    for i in indices:
      box = boxes[i[0]]
      vertices = cv2.boxPoints(box)
      for j in range(4):
        vertices[j][0] *= self.width/320
        vertices[j][1] *= self.height/320
      for j in range(4):
        p1 = (vertices[j][0], vertices[j][1])
        p2 = (vertices[(j + 1) % 4][0], vertices[(j + 1) % 4][1])
        cv2.line(image, p1, p2, (0, 255, 0), 2, cv2.LINE_AA)

if __name__ == '__main__':
  cap = cv2.VideoCapture(0)
  _, frame = cap.read()
  height, width = frame.shape[:2]
  text = TextRecognition((height, width))

  while True:
    start = time.time()
    _, frame = cap.read()
    text.get_text (frame)
    t = pytesseract.image_to_string(frame)
    b = pytesseract.image_to_boxes(frame)
    print(b)
    print(t)
    cv2.imshow('image', frame)
    end = time.time()
    print ("Elapsed: {:6f} seconds".format(end - start))
    if cv2.waitKey(1)==ord('q'):
      break

  cap.release()
  cv2.destroyAllWindows()