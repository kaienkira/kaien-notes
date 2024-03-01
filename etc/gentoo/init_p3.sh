#!/bin/bash

set -o pipefail

install_base_common()
{
    mkdir -p /etc/portage/package.license/
    if [ $? -ne 0 ]; then return 1; fi

    printf '%s\n' \
    'sys-kernel/linux-firmware linux-fw-redistributable' \
    >/etc/portage/package.license/base_common

    emerge \
        sys-kernel/linux-firmware \
        sys-process/htop \
        app-editors/vim \
        app-text/tree
    if [ $? -ne 0 ]; then return 1; fi

    return 0
}

install_base_intel()
{
    printf '%s\n' \
    'sys-firmware/intel-microcode intel-ucode' \
    >/etc/portage/package.license/base_intel
    if [ $? -ne 0 ]; then return 1; fi

    emerge \
        sys-firmware/intel-microcode
    if [ $? -ne 0 ]; then return 1; fi

    return 0
}

install_kernel()
{
    printf '%s\n%s\n%s\n' \
    'sys-apps/systemd boot' \
    'sys-kernel/installkernel systemd-boot dracut uki' \
    >/etc/portage/package.use/kernel

    printf '%s\n' \
    'kernel_cmdline="root=/dev/sda3"' \
    >/etc/dracut.conf

    emerge \
        sys-kernel/gentoo-kernel
    if [ $? -ne 0 ]; then return 1; fi

    return 0
}

install_base_common
if [ $? -ne 0 ]; then exit 1; fi
# install_base_intel
# if [ $? -ne 0 ]; then exit 1; fi
install_kernel
if [ $? -ne 0 ]; then exit 1; fi

emerge -c
if [ $? -ne 0 ]; then exit 1; fi

bootctl install
if [ $? -ne 0 ]; then exit 1; fi

exit 0
