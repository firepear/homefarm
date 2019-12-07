# Control node dockerfile
#
# To build: 'docker build --tag node .'
#
# To launch: docker run --rm -it node /bin/bash
#
# This is intended to be used for testing of Homefarm deployment scripts.

FROM archlinux/base
ARG pkglist="base openssh wpa_supplicant lm_sensors python ansible sudo grep awk boinc-nox linux logrotate"
RUN yes | pacman -Syu --needed $pkglist && yes | pacman -Scc

