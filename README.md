# PPR Detection Pipeline

This repository contains a Snakemake workflow for detecting and assembling Peste des Petits Ruminants (PPR) sequences.

## Quickstart (with Docker)

1️⃣ **Clone this repository:**

```bash
git clone https://github.com/CourcelleM/PPR_detection.git
cd PPR_detection
````

2️⃣ **Build the Snakemake Docker image:**

```bash
sudo docker build -t snakemake_docker .
```

3️⃣ **Run the pipeline:**

From the root of the repository, run:

```bash
sudo docker run -v $(pwd):/workflow -it snakemake_docker snakemake --use-conda --cores 2
```
This will execute the workflow inside the Docker container, using 2 CPU cores and Conda environments as defined in the workflow.

📝 **Notes**
All files (inputs, outputs, configs) are accessible because the current directory is mounted into /workflow inside the container.

Make sure your data and config files are in place before running.
You can adjust --cores based on your machine’s resources.

