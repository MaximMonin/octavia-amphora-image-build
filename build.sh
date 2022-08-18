#!/bin/bash

docker build -f Dockerfile --rm --network host -t octavia-amphora:latest .

imagedir=`pwd`/image
mkdir -p $imagedir

docker run --rm --privileged --network host -v $imagedir:/image octavia-amphora \
    sh -c 'cd /octavia/diskimage-create && \
    export CLOUD_INIT_DATASOURCES="ConfigDrive, OpenStack" && \
    export DIB_CLOUD_INIT_DATASOURCES="ConfigDrive, OpenStack" && \
    export VERSION="yoga" && \
    export DISTRIBUTION="ubuntu-minimal" && \
    export DISTRIBUTION_RELEASE="focal" && \
    export BRANCH="stable/$VERSION" && \
    bash diskimage-create.sh \
    -a amd64 \
    -b haproxy \
    -d $DISTRIBUTION_RELEASE \
    -g $BRANCH \
    -i $DISTRIBUTION \
    -o /image/octavia-amphora-haproxy-$VERSION.qcow2 \
    -s 2 \
    -t qcow2'
