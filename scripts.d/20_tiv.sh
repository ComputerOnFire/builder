#!/bin/bash

git clone https://github.com/stefanhaustein/TerminalImageViewer.git
echo $(uname -m)
if uname -m | grep -q "aarch64" ; then
    CXX=aarch64-linux-gnu-g++ make -C TerminalImageViewer/src/main/cpp
    mv TerminalImageViewer/src/main/cpp/tiv mnt/img_root/usr/local/bin/
else
    CXX=arm-linux-gnueabihf-g++ make -C TerminalImageViewer/src/main/cpp
    mv TerminalImageViewer/src/main/cpp/tiv mnt/img_root/usr/local/bin/
fi