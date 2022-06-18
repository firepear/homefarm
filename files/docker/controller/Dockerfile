# Control node dockerfile
#
FROM archlinux
RUN yes | pacman -Syu --needed darkhttpd python python-packaging ansible git openssh tar file awk vi mg keychain procps-ng coreutils iputils jq binutils go
VOLUME ["/homefarm"]
WORKDIR /homefarm
