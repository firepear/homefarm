# Control node dockerfile
#
# To build: 'docker build --tag control .'
#
# To launch: docker run --rm -p 9099:80 -v /PATH/TO/homefarm:/homefarm -it control /bin/bash
#

FROM archlinux
RUN yes | pacman -Syu --needed darkhttpd python ansible git openssh tar file awk vi mg keychain procps-ng coreutils iputils jq go
VOLUME ["/homefarm"]
WORKDIR /homefarm
