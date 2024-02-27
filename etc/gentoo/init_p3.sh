#!/bin/bash

set -o pipefail

echo \
'sys-kernel/linux-firmware linux-fw-redistributable
'>/etc/portage/package.license

emerge \
sys-kernel/linux-firmware \
sys-process/htop \
app-editors/vim \

if [ $? -ne 0 ]; then exit 1; fi

emerge -c
if [ $? -ne 0 ]; then exit 1; fi

exit 0
