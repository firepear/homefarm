# Control node dockerfile
#
# To build: docker build --tag control .
#
# To launch: docker run --rm -p 9090:80 -v /PATH/TO/homefarm:/homefarm -it control /bin/bash
#

FROM archlinux/base
RUN yes | pacman -Syu
RUN yes | pacman -S --needed darkhttpd python boinctui ansible
EXPOSE 80
VOLUME ["/homefarm"]
WORKDIR /homefarm
