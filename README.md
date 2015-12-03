# pfring-kernel-module

Dockerfile to compile pfring kernel module and install on CoreOS
Last tested on CoreOS 835.8.0 (Stable)
Modified from https://github.com/hookenz/coreos-nvidia

To install on a host do:

'''shell
docker build -t waltermeyer/pfring-kernel-module .
docker run -it --privileged waltermeyer/pfring-kernel-module
'''

This should be adaptable so that it works on other versions of CoreOS. 
However, you need to make sure to use the right gcc version (4.8, 4.9, etc.) depending
on what the CoreOS kernel was compiled with (cat /proc/version).

