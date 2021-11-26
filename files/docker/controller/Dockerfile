# Control node dockerfile
#
FROM archlinux
RUN yes | pacman -Syu --needed darkhttpd python ansible git openssh tar file awk vi mg keychain procps-ng coreutils iputils jq go
VOLUME ["/homefarm"]
WORKDIR /homefarm
