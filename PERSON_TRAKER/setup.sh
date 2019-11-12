virtualenv env --python=python3
source env/bin/activate

pip3 install numpy
pip3 install opencv-python

wget https://pjreddie.com/media/files/yolov3-tiny.weights
wget https://pjreddie.com/media/files/yolov3.weights
mv yolov3-tiny.weights yolov3-coco
mv yolov3.weights yolov3-coco