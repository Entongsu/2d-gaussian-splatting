FROM nvidia/cudagl:11.8.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute
SHELL ["/bin/bash", "-c"]

RUN apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    software-properties-common \
    ffmpeg \
    unzip \
    lsb-release \
    vim \
    git \
    wget \
    htop \
    byobu \
    python3-dev \
    python3-pip \
    freeglut3-dev\
    freeglut3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Install python package
ENV LANG C.UTF-8
RUN pip3 nstall torch==2.5.0 torchvision==0.20.0 torchaudio==2.5.0 --index-url https://download.pytorch.org/whl/cu118
RUN pip3 install submodules/simple-knn
RUN pip3 install diff-surfel-rasterization
