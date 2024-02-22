#!/bin/bash

set -o pipefail

umount /mnt/gentoo/proc
umount -R /mnt/gentoo/sys
umount -R /mnt/gentoo/dev
umount /mnt/gentoo/run
umount /mnt/gentoo/boot
umount /mnt/gentoo

mount /dev/sda3 /mnt/gentoo
if [ $? -ne 0 ]; then exit 1; fi
mount /dev/sda1 /mnt/gentoo/boot
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

cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
if [ $? -ne 0 ]; then exit 1; fi

chroot /mnt/gentoo /bin/env -i \
    PS1='(chroot)\u@\h:\w# ' \
    PATH='/usr/bin' \
    HOME='/root' \
    TERM=linux \
    HISTFILE= \
    /bin/bash --norc
