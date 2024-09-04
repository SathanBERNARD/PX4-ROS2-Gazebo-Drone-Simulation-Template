import time
import typing
import threading

from gz.msgs10.image_pb2 import Image
from gz.transport13 import SubscribeOptions
from gz.transport13 import Node

import cv2
import numpy as np
import PIL 
from PIL import Image as PIL_Image


class GzCam:
  def __init__(self, topic_name, resolution):
    self._res = resolution
    self._node = Node() # gz node
    self._node.subscribe(Image, topic_name, self._cb)
    
    self._img = None
    self._condition = threading.Condition()        


  def _cb(self, image: Image) -> None:
    raw_image_data = image.data
    np_image = np.frombuffer(raw_image_data, dtype=np.uint8).reshape((self._res[1], self._res[0], 3))
    cv2_image = cv2.cvtColor(np_image, cv2.COLOR_RGB2BGR)    
    with self._condition:
      self._img = cv2_image
      self._condition.notify_all()


  def get_next_image(self, timeout=None):
    with self._condition:
      if self._img is None:
          self._condition.wait_for(lambda: self._img is not None, timeout=timeout)
      ret_img = self._img
      self._img = None
      return ret_img
      
      
      
if __name__ == "__main__":
  cam = GzCam("/camera", (1280,960))
  while True:
    img = cam.get_next_image()
    cv2.imshow('pic-display', img)
    cv2.waitKey(1)

