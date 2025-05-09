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

RUN wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
RUN bash Miniforge3-$(uname)-$(uname -m).sh -b -p "${HOME}/conda"
RUN chmod +x "${HOME}/conda/etc/profile.d/conda.sh"
RUN "${HOME}/conda/etc/profile.d/conda.sh"

ENV PATH="$PATH:/root/conda/condabin"

RUN conda create -y -c conda-forge -c bioconda -n snakemake snakemake=9.3.3

SHELL ["conda", "run", "-n", "snakemake", "/bin/bash", "-c"]

# Create directory for the pipeline
WORKDIR /pipeline

# Clone your pipeline from GitHub
RUN git clone https://github.com/CourcelleM/PPR_detection.git .

# Set the entrypoint
ENTRYPOINT ["snakemake"]
