#!/bin/bash

source .env-build

docker build -f Dockerfile --rm --network host -t octavia-amphora:latest .

imagedir=`pwd`/image
mkdir -p $imagedir

docker run --rm --privileged --network host -v $imagedir:/image octavia-amphora \
    sh -c 'cd /octavia/diskimage-create && \
    export CLOUD_INIT_DATASOURCES="ConfigDrive" && \
    export DIB_CLOUD_INIT_DATASOURCES="ConfigDrive" && \
    export VERSION="'$VERSION'" && \
    export DISTRIBUTION="ubuntu-minimal" && \
    export DISTRIBUTION_RELEASE="'$DISTR'" && \
    export BRANCH="stable/$VERSION" && \

    # Legacy+Uefi bios boot support, adding haproxy logrotate,
    # adding disabling haproxy logging, installing mc
    export DIB_LOCAL_ELEMENTS="block-device-efi haproxy-logrotate disable-haproxy-logging mc" && \
    export DIB_LOCAL_ELEMENTS_PATH="/patch" && \

    bash diskimage-create.sh \
    -a amd64 \
    -b haproxy \
    -d $DISTRIBUTION_RELEASE \
    -g $BRANCH \
    -i $DISTRIBUTION \
    -o /image/octavia-amphora-haproxy-$DISTRIBUTION_RELEASE-$VERSION.qcow2 \
    -s 2 \
    -t qcow2'
