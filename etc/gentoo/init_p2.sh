#!/bin/bash

mkdir -p /etc/portage/repos.conf

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

emerge --update --deep --newuse @world
if [ $? -ne 0 ]; then exit 1; fi

exit 0
