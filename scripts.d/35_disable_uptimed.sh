#!/bin/bash

_op _chroot systemctl disable uptimed # disables the uptimed daemon from running in the background on boot; still allows manual start/stop
