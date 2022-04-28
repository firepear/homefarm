# Control node dockerfile
#
FROM archlinux
RUN yes | pacman -Syu --needed darkhttpd python python-packaging ansible git openssh tar file awk vi mg keychain procps-ng coreutils iputils jq binutils
VOLUME ["/homefarm"]
WORKDIR /homefarm
