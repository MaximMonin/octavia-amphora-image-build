FROM ubuntu:jammy

COPY requirements.txt /
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y python3-pip python3-virtualenv kpartx qemu-utils git debootstrap sudo lsb-release curl gdisk dosfstools && \
    pip install -r requirements.txt

RUN git clone https://github.com/openstack/octavia
COPY /patch /patch
