FROM python:3.11

RUN mkdir -p /usr/src

WORKDIR /usr/src

RUN apt-get update && apt-get install -y \
  build-essential \
  cmake \
  gfortran \
  git \
  wget \
  curl \
  graphicsmagick \
  libgraphicsmagick1-dev \
  libatlas-base-dev \
  libavcodec-dev \
  libavformat-dev \
  libboost-all-dev \
  libgtk2.0-dev \
  libjpeg-dev \
  liblapack-dev \
  libswscale-dev \
  pkg-config \
  python3-dev \
  python3-numpy \
  software-properties-common \
  zip \
  && apt-get clean && rm -rf /tmp/* /var/tmp/*

RUN pip install --upgrade pip

RUN cd ~ && \
    mkdir -p dlib && \
    git clone -b 'v19.9' --single-branch https://github.com/davisking/dlib.git dlib/ && \
    cd  dlib/ && \
    python3 setup.py install --yes USE_AVX_INSTRUCTIONS

CMD ["/bin/bash"]

COPY ./ /usr/src

RUN pip3 install -r requirements.txt

ENV PYTHONPATH="$PYTHONPATH:/usr/src/cvp"

RUN python setup.py develop