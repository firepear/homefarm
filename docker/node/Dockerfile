# Control node dockerfile
#
# To build: 'docker build --tag node .'
#
# To launch: docker run --rm -it node /bin/bash
#
# This is intended to be used for testing of Homefarm deployment scripts.

FROM archlinux/base
ARG pkgs="base openssh wpa_supplicant openntpd lm_sensors python ansible sudo grep awk boinc-nox linux"
RUN yes | pacman -Syu --needed ${pkgs} && yes | pacman -Scc

