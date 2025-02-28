# Use the official Python image as the base image
FROM scilus/scilus:1.6.0
ARG ASSET_FILE
COPY ${ASSET_FILE} /assets/

LABEL maintainer="Onset-Lab"

ENV NII2DCM_REVISION=0.2.0

WORKDIR /
RUN apt-get update && apt-get -y install git unzip dcm2niix wget dcmtk
RUN pip install dcm2bids

# Install nii2dcm
RUN python3 -m pip install --upgrade pip && \
    pip install git+https://github.com/onset-lab/nii2dcm.git@${NII2DCM_REVISION}

RUN mkdir /rbx
RUN wget https://zenodo.org/records/10103446/files/atlas.zip -O /atlas.zip && \
    unzip /atlas.zip -d /rbx && \
    rm /atlas.zip
RUN wget https://zenodo.org/records/10103446/files/config.zip -O /config.zip && \
    unzip /config.zip -d /rbx && \
    rm /config.zip

WORKDIR /
RUN wget https://github.com/nextflow-io/nextflow/releases/download/v21.10.6/nextflow-21.10.6-all
RUN mv nextflow-21.10.6-all /usr/local/bin/nextflow
RUN chmod +x /usr/local/bin/nextflow
RUN nextflow -v
RUN apt install -y rsync

WORKDIR /
RUN apt-get install -y git
RUN pip install git+https://github.com/Onset-lab/SurgeryFlow.git

WORKDIR /
