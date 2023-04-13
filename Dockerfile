FROM ubuntu:rolling

ARG MIRROR=mirrors.tuna.tsinghua.edu.cn
ARG TZ=Asia/Shanghai
ARG HTTP_PROXY

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=${TZ} \
    HTTP_PROXY=${HTTP_PROXY} \
    HTTPS_PROXY=${HTTP_PROXY} \
    ALL_PROXY=${HTTP_PROXY} \
    http_proxy=${HTTP_PROXY} \
    https_proxy=${HTTP_PROXY} \
    all_proxy=${HTTP_PROXY} \
    no_proxy="localhost,10.*.*.*"

RUN sed -i "s/archive.ubuntu.com/${MIRROR}/g" /etc/apt/sources.list; \
    sed -i "s/security.ubuntu.com/${MIRROR}/g" /etc/apt/sources.list; \
    sed -i "s/ports.ubuntu.com/${MIRROR}/g" /etc/apt/sources.list; \
    apt-get update && \
    apt-get -y full-upgrade && \
    apt-get -y install tzdata

RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && \
    apt-get -y full-upgrade && \
    apt-get install -y --no-install-recommends \
    ack antlr3 autoconf automake autopoint binutils bison build-essential \
    bzip2 ccache cmake cpio curl device-tree-compiler fastjar flex gawk gettext \
    git gperf help2man intltool libelf-dev libglib2.0-dev libgmp3-dev libltdl-dev \
    libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libreadline-dev libssl-dev libtool lrzsz \
    mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf python2.7 python3 python3-pyelftools \
    libpython3-dev qemu-utils rsync scons squashfs-tools subversion swig texinfo uglifyjs upx-ucl unzip \
    vim wget xmlto xxd zlib1g-dev

RUN apt-get update && \
    apt-get -y full-upgrade && \
    apt-get install -y bash golang
