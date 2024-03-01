#!/bin/bash

set -o pipefail

mkdir -p /etc/portage/repos.conf
if [ $? -ne 0 ]; then exit 1; fi

echo \
'[DEFAULT]
main-repo = gentoo

[gentoo]
sync-type = rsync
sync-uri = rsync://mirrors.tuna.tsinghua.edu.cn/gentoo-portage
'>/etc/portage/repos.conf/gentoo.conf
if [ $? -ne 0 ]; then exit 1; fi

echo \
'COMMON_FLAGS="-O2 -pipe"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"

MAKEOPTS="-j2"

GENTOO_MIRRORS="https://mirrors.tuna.tsinghua.edu.cn/gentoo"
'>/etc/portage/make.conf
if [ $? -ne 0 ]; then exit 1; fi

emerge-webrsync
if [ $? -ne 0 ]; then exit 1; fi
emerge --sync
if [ $? -ne 0 ]; then exit 1; fi
emerge -uDN @world
if [ $? -ne 0 ]; then exit 1; fi
emerge -c
if [ $? -ne 0 ]; then exit 1; fi

echo 'Asia/Shanghai' >/etc/timezone
if [ $? -ne 0 ]; then exit 1; fi
rm -f /etc/localtime
if [ $? -ne 0 ]; then exit 1; fi
emerge --config sys-libs/timezone-data
if [ $? -ne 0 ]; then exit 1; fi

echo 'en_US.UTF-8 UTF-8' >/etc/locale.gen
if [ $? -ne 0 ]; then exit 1; fi
locale-gen
if [ $? -ne 0 ]; then exit 1; fi
eselect locale set en_US.utf8
if [ $? -ne 0 ]; then exit 1; fi

printf '%s\n%s\n%s\n' \
'/dev/sda1 /boot vfat defaults    0 2' \
'/dev/sda2 none  swap sw          0 0' \
'/dev/sda3 /     ext4 rw,relatime 0 1' \
>/etc/fstab

exit 0
