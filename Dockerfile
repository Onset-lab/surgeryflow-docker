# Use the official Python image as the base image
FROM scilus/scilus:1.6.0
ARG ASSET_FILE
COPY ${ASSET_FILE} /assets/

LABEL maintainer="Onset-Lab"

ENV NII2DCM_REVISION=0.1.0

WORKDIR /
RUN apt-get update && apt-get -y install git unzip dcm2niix wget
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
RUN ls /rbx
WORKDIR /
