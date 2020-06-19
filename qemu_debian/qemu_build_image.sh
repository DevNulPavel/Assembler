#! /usr/bin/env bash

# Load i386 image:
# https://www.debian.org/distrib/netinst

qemu-img create debian.img 5G
qemu-system-i386 -hda debian.img -cdrom ~/Downloads/debian-10.4.0-i386-netinst.iso -boot d -m 1024