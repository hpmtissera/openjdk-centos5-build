#!/usr/bin/env bash

echo -e "This script will build OpenJDK 11 for CentOS 5 x86_64\n"
echo -e "Note (FIXME): OpenJDK version 11.0.4+11 is hardcoded in the script\n"

# FIXME do this inside docker
wget -N https://github.com/apple/cups/releases/download/release-1.4.8/cups-1.4.8-source.tar.gz
wget -N https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
wget -N https://www.x.org/releases/individual/lib/libX11-1.6.7.tar.gz
wget -N https://www.x.org/releases/individual/lib/libXrandr-1.5.2.tar.gz
wget -N https://www.x.org/archive/individual/proto/randrproto-1.5.0.tar.gz
wget -N https://www.x.org/archive/individual/proto/xproto-7.0.31.tar.gz
wget -N https://github.com/freedesktop/xorg-macros/archive/util-macros-1.19.1.zip

cp ../../openjdk-11.0.4-logicvein_linux-x64.tar.gz .
# FIXME Take OpenJDK version number as a paramter
wget -N https://github.com/AdoptOpenJDK/openjdk11-upstream-binaries/releases/download/jdk-11.0.4%2B11/OpenJDK11U-sources_11.0.4_11.tar.gz

echo test
docker build -t openjdk-centos5-build .
docker run --volume "$(pwd):/opt/build" --cidfile=containerid  -u root openjdk-centos5-build sh -c "/opt/build/build-openjdk.sh"

CONTAINER_ID=$(cat containerid)
docker cp ${CONTAINER_ID}:/tmp/openjdk-11.0.4-logicvein_linux-x64.tar.gz ./
docker rm -f ${CONTAINER_ID}
rm containerid
rm -f cups-1.4.8-source.tar.gz \
      autoconf-2.69.tar.gz \
      libX11-1.6.7.tar.gz \
      libXrandr-1.5.2.tar.gz \
      randrproto-1.5.0.tar.gz \
      xproto-7.0.31.tar.gz \
      util-macros-1.19.1.zip
