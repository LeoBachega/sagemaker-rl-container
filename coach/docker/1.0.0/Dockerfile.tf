ARG processor
ARG region
FROM 520713654638.dkr.ecr.$region.amazonaws.com/sagemaker-tensorflow-scriptmode:1.12.0-$processor-py3


RUN apt-get -y remove "^python*"

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        jq \
        libav-tools \
        libjpeg-dev \
        libxrender1 \
        python3.6-dev \
        python3-opengl \
        wget \
        xvfb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 10

# Install Redis.
RUN cd /tmp && \
    wget http://download.redis.io/redis-stable.tar.gz && \
    tar xvzf redis-stable.tar.gz && \
    cd redis-stable && \
    make && \
    make install

RUN pip install --no-cache-dir \
    annoy>=1.8.3 \
    Pillow>=7.1.0 \
    pillow>=6.2.0 \
    matplotlib>=2.0.2 \
    numpy>=1.14.5 \
    pandas>=0.22.0 \
    pygame>=1.9.3 \
    PyOpenGL>=3.1.0 \
    scipy>=0.19.0 \
    scikit-image>=0.13.0 \
    gym==0.12.5 \
    bokeh==1.0.4 \
    kubernetes==8.0.1 \
    redis>=2.10.6 \
    minio>=4.0.5 \
    pytest>=3.8.2 \
    psutil>=5.5.0 \
    pyglet==1.3.2 \
    tensorboard>=1.13.0 \
    rl-coach-slim==1.0.0 && \
    pip install --no-cache-dir --upgrade sagemaker-containers && \
    pip install --upgrade numpy

ENV COACH_BACKEND=tensorflow

# Copy workaround script for incorrect hostname
COPY lib/changehostname.c /
COPY lib/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

WORKDIR /opt/ml

# Starts framework
ENTRYPOINT ["bash", "-m", "start.sh"]
