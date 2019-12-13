virtualenv env --python=python3
source env/bin/activate

pip3 install numpy
pip3 install opencv-python
pip3 install Pillow
pip3 install matplotlib
pip install scipy
pip install filterpy
pip install numba
pip install scikit-image
pip install scikit-learn

mkdir yolov3-coco
wget https://pjreddie.com/media/files/yolov3-tiny.weights
wget https://pjreddie.com/media/files/yolov3.weights
wget https://www.dropbox.com/s/r2ingd0l3zt8hxs/frozen_east_text_detection.tar.gz?dl=1
mv yolov3-tiny.weights yolov3-coco
mv yolov3.weights yolov3-coco
mv frozen_east_text_detection.tar.gz east_text_detection
tar -xvzf east_text_detection/frozen_east_text_detection.tar.gz
rm -fr *.tar.gz