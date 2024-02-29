#!/bin/bash

set -o pipefail

echo \
'sys-kernel/linux-firmware linux-fw-redistributable
'>/etc/portage/package.license

emerge \
sys-kernel/linux-firmware \
sys-process/htop \
app-editors/vim
if [ $? -ne 0 ]; then exit 1; fi

install_package_for_intel_cpu()
{
    echo \
    'sys-firmware/intel-microcode intel-ucode' \
    >>/etc/portage/package.license
    if [ $? -ne 0 ]; then return 1; fi

    emerge \
    sys-firmware/intel-microcode
    if [ $? -ne 0 ]; then return 1; fi

    return 0
}

# install_package_for_intel_cpu
# if [ $? -ne 0 ]; then exit 1; fi

emerge -c
if [ $? -ne 0 ]; then exit 1; fi

exit 0
