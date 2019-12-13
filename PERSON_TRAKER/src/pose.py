
import numpy as np
import cv2
import subprocess
import os
import time

class Pose:

  def __init__(self,
      image_size,
      mpi = True,
      threshold = 0.1):
    if mpi:
      protoFile = 'open-pose/mpi/pose_deploy_linevec_faster_4_stages.prototxt'
      weightsFile = 'open-pose/mpi/pose_iter_160000.caffemodel'
      self.points = 15
      self.pose_pairs = [[0,1], [1,2], [2,3], [3,4], [1,5], [5,6], [6,7], [1,14], [14,8], [8,9], [9,10], [14,11], [11,12], [12,13]]
    else:
      protoFile = 'open-pose/coco/pose_deploy_linevec.prototxt'
      weightsFile = 'open-pose/coco/pose_iter_440000.caffemodel'
      self.points = 18
      self.pose_pairs = [[1,0],[1,2],[1,5],[2,3],[3,4],[5,6],[6,7],[1,8],[8,9],[9,10],[1,11],[11,12],[12,13],[0,14],[0,15],[14,16],[15,17]]
    self.mpi = mpi
    self.net = cv2.dnn.readNetFromCaffe(protoFile, weightsFile)
    self.height = image_size[0]
    self.width = image_size[1]
    self.threshold = threshold

  def estimate_pose(self, image):
    inputBlob = cv2.dnn.blobFromImage(image, 1.0 / 255, (self.width, self.height), (0, 0, 0), swapRB=False, crop=False)
    self.net.setInput(inputBlob)
    output = self.net.forward()
    H = output.shape[2]
    W = output.shape[3]
    points = []
    for i in range(self.points):
        probMap = output[0, i, :, :]
        minVal, prob, minLoc, point = cv2.minMaxLoc(probMap)
        x = (self.width * point[0]) / W
        y = (self.height * point[1]) / H
        if prob > self.threshold:
          points.append((int(x), int(y)))
        else :
          points.append(None)
    return points

  def draw (self, image, points):
    for pair in self.pose_pairs:
      partA = pair[0]
      partB = pair[1]
      if points[partA] and points[partB]:
        cv2.line(image, points[partA], points[partB], (0, 255, 255), 3, lineType=cv2.LINE_AA)
        cv2.circle(image, points[partA], 8, (0, 0, 255), thickness=-1, lineType=cv2.FILLED)
        cv2.circle(image, points[partB], 8, (0, 0, 255), thickness=-1, lineType=cv2.FILLED)
    return image
  

if __name__ == '__main__':
  cap = cv2.VideoCapture(0)
  _, frame = cap.read()
  height, width = frame.shape[:2]
  height = int(height/2)
  width = int(width/2)
  frame = cv2.resize(frame, (width, height))

  pose = Pose((height, width))

  while(True):
    start = time.time()
    _, frame = cap.read()
    frame = cv2.resize(frame, (width, height))
    cv2.imshow('Output-Skeleton', pose.draw(frame,pose.estimate_pose(frame)))
    end = time.time()
    print ("Elapsed: {:6f} seconds".format(end - start))
    if cv2.waitKey(1) & 0xFF == ord('q'):
      break

  cap.release()
  cv2.destroyAllWindows()


