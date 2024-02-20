#!/bin/bash

set -o pipefail

if [ $# -ne 1 ]
then
    echo "usage: `basename $0` <stage3_file>"
    exit 1
fi

stage3_file=$1

if [ ! -f "$stage3_file" ]
then
    echo "$stage3_file not found"
    exit 1
fi

###############################################################################
install_disk=/dev/sda
install_disk_part1_end=1025MiB
install_disk_part2_end=3073MiB

###############################################################################
umount /mnt/gentoo

parted -s "$install_disk" \
    mklabel gpt \
    mkpart esp fat32 1MiB "$install_disk_part1_end" \
    mkpart primary linux-swap "$install_disk_part1_end" "$install_disk_part2_end" \
    mkpart primary ext4 "$install_disk_part2_end" 100% \
    set 1 esp on
if [ $? -ne 0 ]; then exit 1; fi
mkfs.vfat /dev/sda1
if [ $? -ne 0 ]; then exit 1; fi
mkswap /dev/sda2
if [ $? -ne 0 ]; then exit 1; fi
mkfs.ext4 -F /dev/sda3
if [ $? -ne 0 ]; then exit 1; fi

mount /dev/sda3 /mnt/gentoo
if [ $? -ne 0 ]; then exit 1; fi

tar -xpf "$stage3_file" -C /mnt/gentoo --xattrs-include='*.*' --numeric-owner
if [ $? -ne 0 ]; then exit 1; fi

exit 0
