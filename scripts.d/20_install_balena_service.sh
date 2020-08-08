#!/bin/bash

cat << EOF > mnt/img_root/etc/systemd/system/balena.service
[Unit]
Description=Balena Application Container Engine
Documentation=https://www.balena.io/engine/
After=network-online.target balena.socket firewalld.service
Wants=network-online.target
Requires=balena.socket

[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by balena
ExecStart=/usr/bin/balena-engine-daemon -H tcp://0.0.0.0:2375 -H unix:///var/run/balena-engine.sock
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=1048576
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of balena containers
Delegate=yes
# kill only the balena process, not all processes in the cgroup
KillMode=process
# restart the balena process if it exits prematurely
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
EOF