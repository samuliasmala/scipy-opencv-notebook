FROM jupyter/scipy-notebook:137a295ff71b
MAINTAINER Samuli Asmala <samuli.asmala@gmail.com>

# Change me if you want to build with a different version of OpenCV
ENV OPENCV_VERSION 3.4.3

# Change to root
USER root

# Install OpenCV dependencies that are not already there
RUN apt-get update && apt-get install -y \
	cmake \
	libgtk2.0-dev \
	libavcodec-dev \
	libavformat-dev \
	libswscale-dev

ENV OPENCV_CONTRIB_GIT_DIR=/opt/opencv_contrib
ENV OPENCV_GIT_DIR=/opt/opencv
ENV OPENCV_BUILD_DIR=/tmp/opencv/build

RUN echo 'Prepare OpenCV extra modules' && \
	git clone https://github.com/opencv/opencv_contrib.git $OPENCV_CONTRIB_GIT_DIR && \
	cd $OPENCV_CONTRIB_GIT_DIR && \
	git checkout $OPENCV_VERSION && \
	echo 'Prepare OpenCV' && \
	git clone https://github.com/opencv/opencv.git $OPENCV_GIT_DIR && \
	cd $OPENCV_GIT_DIR && \
	git checkout $OPENCV_VERSION && \
	echo 'Prepare build (Python directories specified in the parent image)' && \
	mkdir -p $OPENCV_BUILD_DIR && \
	cd $OPENCV_BUILD_DIR && \
	cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D OPENCV_EXTRA_MODULES_PATH=$OPENCV_CONTRIB_GIT_DIR/modules \
	-D PYTHON3_EXECUTABLE=/opt/conda/bin/python3.6 \
	-D PYTHON3_LIBRARY=/opt/conda/lib/libpython3.6m.so \
	-D PYTHON3_INCLUDE_DIR=/opt/conda/include/python3.6m \
	-D PYTHON3_NUMPY_INCLUDE_DIRS=/opt/conda/lib/python3.6/site-packages/numpy/core/include \
	-D PYTHON3_PACKAGES_PATH=/opt/conda/lib/python3.6/site-packages \
	$OPENCV_GIT_DIR && \
	echo 'Install' && \
	make -j $(nproc) && make install && ldconfig && \

# Back to the default directory
WORKDIR /home/$NB_USER/work

# Switch back to notebook user
USER $NB_USER
