#!/usr/bin/env bash

set -e

mv /opt/build/OpenJDK11U-sources_11.0.4_11.tar.gz /root
tar -zxf OpenJDK11U-sources_11.0.4_11.tar.gz
cd /root/openjdk-11.0.4+11-sources
chmod +x configure

# FIXME OpenJDK11 fail to parse ld --version, and throws a error during ./configure. As a hack Lines 151 - 167 in toolchain.m4 has been modified to 
# skip the version check.
cp /opt/build/toolchain.m4 make/autoconf/

sh ./configure --disable-warnings-as-errors --with-native-debug-symbols=none --with-debug-level=release --with-jvm-variants=server --enable-unlimited-crypto --without-version-opt --disable-manpages

cp -r /root/libXrandr-1.5.2/include/X11/extensions/ /usr/include/X11/
make JOBS=4 images

cd build/linux-x86_64-normal-server-release/images/jdk
rm -rf demo
#rm -rf jmods/*
#
#find . -name "src.zip" -exec rm -f {} \;

cd ..

mv jdk openjdk-11.0.4

tar -zcvf openjdk-11.0.4-linux-x64.tar.gz openjdk-11.0.4

mv openjdk-11.0.4-linux-x64.tar.gz /tmp
