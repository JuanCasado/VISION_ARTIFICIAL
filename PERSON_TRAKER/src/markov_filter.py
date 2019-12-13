
import numpy as np
import matplotlib.pyplot as plt
import time

class MarkovFilter:
  def __init__(self, size, variance_scale = 0.5):
    self.figure_index = 0
    self.empty_filter = np.repeat(1/size, size)
    self.space = np.linspace(1, size, size)
    self.filter = np.copy(self.empty_filter)
    self.acc = np.copy(self.empty_filter)
    self.iter = 0
    self.variance_scale = variance_scale
    self.first_draw = True

  def get_space(self):
    return np.copy(self.space)

  def draw (self):
    if self.first_draw:
      plt.ion()
      plt.show()
      plt.title('MarkovFilter')
      plt.ylabel('Bel(s)')
      plt.xlabel('pos')
      self.first_draw = False
    plt.clf()
    plt.plot(self.space, self.filter)
    plt.draw()
    plt.pause(0.0001)

  def _create_gaussian(self, center, dispersion, height=1):
    x = self.get_space()
    gaussian = np.exp(-((x-center)**2 / (2.0 * dispersion**2)))
    if height!=1:
      gaussian = gaussian*height
    return gaussian

  def add_gaussian(self, center, dispersion, height=1):
    gaussian = self._create_gaussian(center, dispersion, height)
    self.acc = np.add(self.acc, gaussian)

  def add_movement(self, box, height=1):
    x, y = box[0], box[1]
    w, h = box[2], box[3]
    center = x+w/2
    gaussian = self._create_gaussian(center, w*self.variance_scale, height)
    self.filter = np.add(self.filter, gaussian)

  def update_filter(self):
    self.acc = self._normalize(self.acc)
    if self.iter%6==0:
      self.filter = self._normalize(np.add(np.multiply(self.filter, 0.6), np.multiply(self.acc, 0.4)))
    else:
      self.filter = self._normalize(np.multiply(self.filter, self.acc))
    self.acc = self.empty_filter
    self.iter += 1

  def _normalize(self, data):
    integral = np.sum(data)
    if integral != 0:
      return data / integral
    else:
      return data

  def normalize_filter (self):
    self.filter = self._normalize(self.filter)

  def add_box (self, box, height=1):
    if box:
      x, y = box[0], box[1]
      w, h = box[2], box[3]
      center = x+w/2
      self.add_gaussian(center, w*self.variance_scale, height)

  def add_face (self, face, height=1):
    if face:
      (top, right, bottom, left) = face
      w = right-left
      center = left+w/2
      self.add_gaussian(center, w*self.variance_scale, height)

  def get_max (self):
    return np.argmax(self.filter)

if __name__ == '__main__':
  m = MarkovFilter(300)
  while (True):
    m.add_gaussian(40, 30)
    m.add_gaussian(100, 30)
    m.add_gaussian(70, 20)
    m.add_gaussian(95, 100)
    m.update_filter()
    m.draw()

    m.add_gaussian(30, 30)
    m.add_gaussian(95, 30)
    m.add_gaussian(80, 20)
    m.add_gaussian(105, 100)
    m.update_filter()
    m.draw()

    m.add_gaussian(35, 30)
    m.add_gaussian(100, 30)
    m.add_gaussian(60, 20)
    m.add_gaussian(90, 100)
    m.update_filter()
    m.draw()
