FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=graphics,utility,compute

# Ensure CUDA environment is correctly set
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=$CUDA_HOME/bin:$PATH
ENV LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
ENV TORCH_CUDA_ARCH_LIST="8.6;8.9"

SHELL ["/bin/bash", "-c"]

# Install system dependencies including compilers
RUN apt-get update -q \
    && apt-get install -y \
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
    freeglut3-dev \
    freeglut3 \
    build-essential \
    cmake \
    ninja-build \
    gcc g++ \
    cuda-toolkit-11-8 \
    libcudnn8 libcudnn8-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone the repository and initialize submodules
WORKDIR /app
RUN git clone https://github.com/Entongsu/2d-gaussian-splatting.git
WORKDIR /app/2d-gaussian-splatting
RUN git submodule update --init --recursive --remote

# Install Python packages
ENV LANG=C.UTF-8
RUN pip install --upgrade pip setuptools wheel
RUN pip install torch==2.5.0 torchvision==0.20.0 torchaudio==2.5.0 --index-url https://download.pytorch.org/whl/cu118
RUN apt-get update && apt-get install -y cuda-runtime-11-8

# Build and install simple-knn
RUN pip install ninja
RUN pip install ./submodules/simple-knn

# Install diff-surfel-rasterization
RUN pip install ./submodules/diff-surfel-rasterization
