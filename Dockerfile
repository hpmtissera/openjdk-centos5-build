FROM centos:5 AS openjdk-centos5-build

LABEL maintainer="hpmtissera@gmail.com"

ENV AUTOCONF="/usr/local/bin/autoconf"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

RUN mkdir -p /var/cache/yum/base
RUN mkdir -p /var/cache/yum/extras
RUN mkdir -p /var/cache/yum/updates
RUN mkdir -p /var/cache/yum/libselinux

RUN echo "http://vault.centos.org/5.11/os/x86_64/" > /var/cache/yum/base/mirrorlist.txt
RUN echo "http://vault.centos.org/5.11/extras/x86_64/" > /var/cache/yum/extras/mirrorlist.txt
RUN echo "http://vault.centos.org/5.11/updates/x86_64/" > /var/cache/yum/updates/mirrorlist.txt
RUN echo "http://vault.centos.org/5.11/os/x86_64/" > /var/cache/yum/libselinux/mirrorlist.txt
RUN echo "http://vault.centos.org/5.11/extras/x86_64/" > /var/cache/yum/libselinux/mirrorlist.txt
RUN echo "http://vault.centos.org/5.11/updates/x86_64/" > /var/cache/yum/libselinux/mirrorlist.txt

RUN yum upgrade perl-DBI
RUN yum update -y
RUN yum install -y wget
RUN yum install -y which
RUN yum install -y make
RUN yum install -y file
RUN yum install -y unzip
RUN yum install -y gcc
RUN yum install -y gcc-c++
RUN yum install -y bzip2
RUN yum install -y glibc-devel
RUN yum install -y fontconfig-devel
RUN yum install -y alsa-lib-devel
RUN yum install -y zip
RUN yum install -y libXtst-devel libXt-devel libXrender-devel libXrandr-devel libXi-devel
RUN yum install -y autoconf
RUN yum install -y automake

# RUN wget https://www.mercurial-scm.org/release/centos5/RPMS/x86_64/mercurial-4.9-1+2.7.14.x86_64.rpm
# RUN rpm -i mercurial-4.9-1+2.7.14.x86_64.rpm

WORKDIR /root
COPY deps/gcc-4.8.2.tar.gz /root
RUN tar -zxf gcc-4.8.2.tar.gz
WORKDIR gcc-4.8.2
RUN ./contrib/download_prerequisites
RUN ./configure
RUN make
RUN make install
RUN yum remove -y gcc
RUN ln -s /usr/local/bin/gcc /usr/bin/gcc

WORKDIR /root
COPY deps/autoconf-2.69.tar.gz /root
RUN tar -zxf autoconf-2.69.tar.gz
WORKDIR autoconf-2.69
RUN ./configure 
RUN make
RUN make install

WORKDIR /root
COPY deps/cups-1.4.8-source.tar.gz /root
RUN tar -zxf cups-1.4.8-source.tar.gz
WORKDIR cups-1.4.8
RUN ./configure 
RUN make
RUN make install

# FIXME Some of the following dependecies might be unnecessary to recompile. Need to test and remove unwanted steps.
WORKDIR /root
COPY deps/util-macros-1.19.1.zip /root
RUN unzip util-macros-1.19.1.zip
WORKDIR /root/xorg-macros-util-macros-1.19.1
RUN ./autogen.sh
RUN make
RUN make install

WORKDIR /root
COPY deps/xproto-7.0.31.tar.gz /root
RUN tar -zxf xproto-7.0.31.tar.gz
WORKDIR /root/xproto-7.0.31
RUN ./configure
RUN make 
RUN make install

WORKDIR /root
COPY deps/randrproto-1.5.0.tar.gz /root
RUN tar -zxf randrproto-1.5.0.tar.gz
WORKDIR /root/randrproto-1.5.0
RUN ./configure
RUN make
RUN make install

WORKDIR /root
COPY deps/libXrandr-1.5.2.tar.gz /root
RUN tar -zxf libXrandr-1.5.2.tar.gz
RUN cp -rf /root/libXrandr-1.5.2/include/X11/extensions/ /usr/include/X11/

WORKDIR /root
COPY deps/openjdk-11-linux-x64.tar.gz /root
RUN tar xzf openjdk-11-linux-x64.tar.gz -C /usr/local
RUN alternatives --install /usr/bin/java java /usr/local/openjdk-11.0.4/bin/java 2
RUN alternatives --set java /usr/local/openjdk-11.0.4/bin/java

WORKDIR /root
RUN rm -rf gcc-4.8.2.tar.gz
RUN rm -rf gcc-4.8.2
RUN rm -rf autoconf-2.69.tar.gz
RUN rm -rf autoconf-2.69
RUN rm -rf cups-1.4.8-source.tar.gz
RUN rm -rf cups-1.4.8
RUN rm -rf util-macros-1.19.1.zip
RUN rm -rf xorg-macros-util-macros-1.19.1
RUN rm -rf xproto-7.0.31.tar.gz
RUN rm -rf xproto-7.0.31
RUN rm -rf randrproto-1.5.0.tar.gz
RUN rm -rf randrproto-1.5.0
RUN rm -rf libXrandr-1.5.2.tar.gz
RUN rm -rf libXrandr-1.5.2
RUN rm -rf openjdk-11-linux-x64.tar.gz