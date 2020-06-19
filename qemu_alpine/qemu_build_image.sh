#! /usr/bin/env bash

# Load i386 image:
# https://linuxhint.com/install_qemu_debian/

qemu-img create debian.img 5G
qemu-system-i386 -hda debian.img -cdrom ~/Downloads/debian-10.4.0-i386-netinst.iso -boot d -m 1024