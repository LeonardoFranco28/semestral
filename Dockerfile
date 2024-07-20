# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set the working directory
WORKDIR /app

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    wget \
    git \
    bzip2 \
    build-essential \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    libssl-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda && \
    rm Miniconda3-latest-Linux-x86_64.sh

# Update PATH environment variable
ENV PATH=/opt/miniconda/bin:$PATH

# Create a new conda environment with Jupyter Lab
RUN conda create -n magenta -y python=3.7 jupyterlab

# Activate the conda environment and install Magenta
RUN /bin/bash -c "source activate magenta && \
    pip install magenta"

# Expose the Jupyter Lab port
EXPOSE 8888

# Start Jupyter Lab
CMD ["/bin/bash", "-c", "source activate magenta && jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root"]
