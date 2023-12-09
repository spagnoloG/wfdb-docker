# Wfdb-docker

### Setup of physionet database

```bash
cd ~/datasets/physionet
wget -r -N -c -np https://physionet.org/files/ltstdb/1.0.0/
```

### Setup of wfdb-docker


Locally build the docker image:

```bash
docker build -t wfdb-docker .
```

Run the docker image:

```bash
DATASET_DIR=~/datasets/physionet
docker run -it --rm -v $DATASET_DIR:/data wfdb-docker wfdb2mat -r /data/s2011 -f 0 -t 5
```

Or if you don't want to build the image locally, you can pull it from dockerhub:

```bash
DATASET_DIR=~/datasets/physionet
docker pull ghcr.io/spagnolog/wfdb-docker:main
docker run -it --rm  -v $DATASET_DIR:/data ghcr.io/spagnolog/wfdb-docker:main wfdb2mat -r /data/s20221 -f 0 -t 5
```
