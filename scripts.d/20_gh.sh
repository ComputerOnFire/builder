#!/bin/bash

if [[uname -m | grep -q "aarch64"]];then
    wget -N https://github.com/cli/cli/releases/download/v0.10.0/gh_0.10.0_linux_arm64.deb -P mnt/img_root/
    _op _chroot apt install ./gh_0.10.0_linux_arm64.deb -y
elif [[uname -m | grep -q "armv7l"];then
    git clone https://github.com/cli/cli.git gh-cli
    env GOOS=linux GOARCH=arm GOOARM=7 make -C gh-cli
    mv gh-cli/bin/gh mnt/img_root/usr/local/bin/
else
    git clone https://github.com/cli/cli.git gh-cli
    env GOOS=linux GOARCH=arm GOOARM=6 make -C gh-cli
    mv gh-cli/bin/gh mnt/img_root/usr/local/bin/
fi