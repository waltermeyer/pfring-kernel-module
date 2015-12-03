# Dockerfile to compile pfring kernel module and install on CoreOS
# Last tested on CoreOS 835.8.0 (Stable)
#
# Modified from https://github.com/hookenz/coreos-nvidia
#
# To install on a host do:
# docker build -t waltermeyer/pfring-kernel-module .
# docker run -it --privileged waltermeyer/pfring-kernel-module
#

FROM debian:jessie
MAINTAINER Walter Meyer <wgmeyer@gmail.com>

# Setup environment
RUN apt-get -y update && apt-get -y install gcc-4.9 bc \
    wget git make dpkg-dev module-init-tools && \
    mkdir -p /usr/src/kernels && \
    mkdir -p /opt/pfring && \
    apt-get autoremove && apt-get clean && \
    update-alternatives --install  /usr/bin/gcc gcc /usr/bin/gcc-4.9 10

# Get pfring
RUN wget -P /opt/pfring http://ftp.ntua.gr/mirror/ntop/PF_RING/PF_RING-6.2.0.tar.gz

# Download kernel source
RUN cd /usr/src/kernels && \
    git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux

# Compilation prep
RUN cd /usr/src/kernels/linux && \
    git checkout -b stable v`uname -r | sed 's/-.*//'` && \
    zcat /proc/config.gz > .config && make modules_prepare
    sed -i "s/$(uname -r | sed 's/-.*//')/$(uname -r)/g" include/generated/utsrelease.h

# Compilation
RUN cd /opt/pfring && \
    tar xzvf PF_RING-6.2.0.tar.gz && \
    cd /opt/pfring/PF_RING-6.2.0/kernel && \
    mkdir -p /lib/modules/`uname -r`/ && \
    ln -s /usr/src/kernels/linux/ /lib/modules/`uname -r`/build && \
    make

# Install the module 
CMD ["modprobe", "pf_ring"]
