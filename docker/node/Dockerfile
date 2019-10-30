# Control node dockerfile
#
# To build: 'docker build --tag node .'
#
# To launch: docker run --rm -it node /bin/bash
#
# This is intended to be used for testing of Homefarm deployment scripts.

FROM archlinux/base
RUN yes | pacman -Syu --needed ansible grep awk openssh boinc-nox && yes | pacman -Scc

