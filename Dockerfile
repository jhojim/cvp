# Use an official Python runtime as a parent image
FROM python:3.11.7-slim

RUN mkdir -p /usr/src

# setting up a working directory
WORKDIR /usr/src

RUN apt-get update

RUN pip install --upgrade pip

# Install production dependencies.
RUN pip install --upgrade pip setuptools
RUN pip install --upgrade pip setuptools
RUN pip install cmake==3.27.0
RUN apt-get clean && apt-get -y update && apt-get install -y build-essential cmake libopenblas-dev liblapack-dev libopenblas-dev liblapack-dev graphviz
RUN pip install dlib==19.24.2
RUN pip install numpy==1.24.3
RUN pip install opencv-python==4.8.0.74
RUN pip install opencv-python-headless==4.8.0.74
RUN pip install Werkzeug==2.3.6
RUN apt-get install wget
RUN wget https://huggingface.co/spaces/asdasdasdasd/Face-forgery-detection/resolve/ccfc24642e0210d4d885bc7b3dbc9a68ed948ad6/shape_predictor_68_face_landmarks.dat
RUN pip install graphviz
RUN pip install pydotplus

# installing python dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Make port 8888 available to the world outside this container
EXPOSE 8888

# Run Jupyter notebook when the container launches
CMD ["jupyter", "notebook", "--ip='*'", "--port=8888", "--no-browser", "--NotebookApp.token='123456789'", "--NotebookApp.password='123456789'", "--allow-root"]