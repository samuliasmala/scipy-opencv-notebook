## asmala/scipy-opencv-notebook Docker image

All the fun of the [jupyter/scipy-notebook][jupyter-scipy-nb] Docker image, plus OpenCV 3.4.3, Python 3 bindings, and the OpenCV extra modules. Check out the [jupyter/scipy-notebook][jupyter-scipy-nb] for more information.

Note: OpenCV was built with only Python 3 bindings. Therefore, Python 2 notebooks cannot `import cv2`.

## Getting started

```
# Download image
docker pull asmala/scipy-opencv-notebook

# Quick start: create and start a container and remove it after its finished
docker run -it --rm -p 8888:8888 asmala/scipy-opencv-notebook

# More complicated command explained (full command below):
# -it                       attach terminal
# --name opencv             give name to the container for easier reference later
# --user $(id -u):$(id -g)  use your own user id and group id to get proper file permissions for the files created in shard volumes
# --group-add users         add your user id to group users to get access to some important folders within the image
# -v "$(pwd)":/home/jovyan/work     mount current working directory to Jupyter Notebook's working directory
# -p 8888:8888              map host port 8888 to be used for Jupyter Notebook
# asmala/scipy-opencv-notebook      specify the image to be used
# start-notebook.sh         image entry point
# --NotebookApp.custom_display_url='http://127.0.0.1:8888'      fix the terminal link
# --notebook-dir=/home/jovyan/work  specify the Jupyter working directory

docker run -it --name opencv --user $(id -u):$(id -g) --group-add users -v "$(pwd)":/home/jovyan/work -p 8888:8888  asmala/scipy-opencv-notebook start-notebook.sh --NotebookApp.custom_display_url='http://127.0.0.1:8888' --notebook-dir=/home/jovyan/work

# Connect to X11 if you want to run some graphics by adding following parameters to the command above:
-e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix

# Start the same container later
docker start -i opencv
```

See [jupyter/scipy-notebook][jupyter-scipy-nb] for optional `run` arguments.

Navigate to `localhost:8888` in any browser, and make your first Python 3 notebook! Here's a script to find a face in a picture that you upload:

```python
%matplotlib inline
import numpy as np
import matplotlib.pyplot as plt
import cv2

img = cv2.imread("your_uploaded_image.jpg")
img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
plt.imshow(img)		# shows face without box

# If you need to find directories of data files,
# open up a terminal window from the web interface and search from there
#	find /opt -iname *haar*
face_cascade = cv2.CascadeClassifier('/opt/opencv/data/haarcascades/haarcascade_frontalface_default.xml')

faces = face_cascade.detectMultiScale(img, 1.1, 3)
for (x,y,w,h) in faces:
    cv2.rectangle(img,(x,y),(x+w,y+h),(255,0,0),2)
    roi = img[y:y+h, x:x+w]

plt.imshow(img)		# shows the face with a box around it
```

### Doesn't this exist?

In a few places! But, I wanted to make my own for practice.

Thanks to the [jupyter/docker-stacks][jupyter-stacks] project and the Jupyter team, OpenCV, and Docker. Made for the University of Pittsburgh DesignHub.

[jupyter-scipy-nb]: https://github.com/jupyter/docker-stacks/tree/master/scipy-notebook
[jupyter-stacks]: https://github.com/jupyter/docker-stacks
