#!/bin/bash

source lib.sh

INSTALL_PACKAGES=(
    avahi-daemon vim lshw iotop screen tmux # essentials
    docker-ce aufs-dkms- # docker
    # quicksynergy # dogi
    matchbox-keyboard # virtual keyboard
    mdadm initramfs-tools rsync # for RAID1
    elinks links lynx # text mode web browser
    hostapd dnsmasq # rpi access point
    dos2unix # for converting dos characters to unix in autorunonce
    nodejs # version 8.5.0-1nodesource1
    autossh
    python3-pip python3-dbus
    bluez minicom bluez-tools libbluetooth-dev # bluetooth hotspot
    avahi-autoipd # for usb0
    rng-tools # for ap bridge
    tor=0.3.5.10-1 #TODO bring back to upstream
    openvpn
    shadowsocks-libev proxychains4 # socks5 proxy
    jq # for parsing json / treehouses command
    net-tools # netstat
    iproute2 # ss command
    nmap # network mapping package
    htop
    speedtest-cli # speedtest.net
    libffi-dev # for building docker-compose using pip
    # python3-coral-enviro # Coral environmental board, disabled for arm64 builds
    bc # for memory command
    libusb-dev # for usb.sh
    dnsutils
    uptimed # for measuring rpi uptime
    pagekite # tunnels command
    sl
    mc ranger
    bats # unit testing
    libhdf5-dev libatlas-base-dev libqt4-test # opencv libjasper1
    imagemagick # tiv
    python3-bcrypt python3-nacl # fix slow pip
)

ARMHF_PACKAGES=( #packages which do not work on arm64
    quicksynergy
    libjasper1
)

if [[ ${INSTALL_PACKAGES:-} ]] ; then
    echo "Installing ${INSTALL_PACKAGES[*]}"
    _apt install "${INSTALL_PACKAGES[@]}" || die "Could not install ${INSTALL_PACKAGES[*]}"
    #if _apt install "${INSTALL_PACKAGES[@]}" | grep -q 'Unable to connect to '; then
        #_apt install "${INSTALL_PACKAGES[@]}" || die "Could not install ${INSTALL_PACKAGES[*]}"
    #fi
elif ! uname -m | grep -q "aarch64" && [[ ${ARMHF_PACKAGES:-} ]] ; then
    _apt install "${ARMHF_PACKAGES[@]}" || die "Could not install ${ARMHF_PACKAGES[*]}"
fi

_op _chroot apt-mark hold tor #TODO bring back to upstream
