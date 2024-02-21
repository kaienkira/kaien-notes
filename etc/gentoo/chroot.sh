#!/bin/bash

set -o pipefail

cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
if [ $? -ne 0 ]; then exit 1; fi

mount --types proc /proc /mnt/gentoo/proc
if [ $? -ne 0 ]; then exit 1; fi
mount --rbind /sys /mnt/gentoo/sys
if [ $? -ne 0 ]; then exit 1; fi
mount --make-rslave /mnt/gentoo/sys
if [ $? -ne 0 ]; then exit 1; fi
mount --rbind /dev /mnt/gentoo/dev
if [ $? -ne 0 ]; then exit 1; fi
mount --make-rslave /mnt/gentoo/dev
if [ $? -ne 0 ]; then exit 1; fi
mount --bind /run /mnt/gentoo/run
if [ $? -ne 0 ]; then exit 1; fi
mount --make-slave /mnt/gentoo/run
if [ $? -ne 0 ]; then exit 1; fi

chroot /mnt/gentoo /bin/bash
if [ $? -ne 0 ]; then exit 1; fi
