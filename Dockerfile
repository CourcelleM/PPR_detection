# Use an Ubuntu base image
FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies including git
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    wget \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Snakemake
RUN pip3 install snakemake

# Create directory for the pipeline
WORKDIR /pipeline

# Clone your pipeline from GitHub
# Replace the URL with your GitHub repository URL
RUN git clone https://github.com/CourcelleM/PPR_detection.git .

# Set the entrypoint
ENTRYPOINT ["snakemake"]
