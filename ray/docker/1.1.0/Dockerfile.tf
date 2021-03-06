ARG processor
ARG region
ARG suffix

FROM 763104351884.dkr.ecr.$region.amazonaws.com/tensorflow-training:2.3.1-$processor-py37-$suffix

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        jq \
        ffmpeg \
        rsync \
        libjpeg-dev \
        libxrender1 \
        python3.6-dev \
        python3-opengl \
        wget \
        xvfb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

RUN pip install --no-cache-dir \
    Cython==0.29.21 \
    tabulate \
    tensorboardX \
    gputil \
    gym==0.18.0 \
    lz4 \
    opencv-python-headless \
    PyOpenGL==3.1.0 \
    pyyaml \
    ray==1.1.0 \
    ray[tune]==1.1.0 \
    ray[rllib]==1.1.0 \
    scipy \
    psutil \
    setproctitle \
    dm-tree \
    tensorflow-probability \
    tf_slim \
    sagemaker-tensorflow-training

# https://github.com/ray-project/ray/issues/11773
RUN pip install dataclasses

# https://github.com/aws/sagemaker-rl-container/issues/39
RUN pip install pyglet==1.4.10

# https://click.palletsprojects.com/en/7.x/python3/
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Copy workaround script for incorrect hostname
COPY lib/changehostname.c /

COPY lib/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Starts framework
ENTRYPOINT ["bash", "-m", "start.sh"]
