#!/bin/bash

set -o pipefail

if [ $# -lt 2 ]
then
    echo "$(basename $0) <iso_file_path> <device_name>" \
         "[mount_dir_name] [syslinux_dir_name]"
    exit 1
fi

iso_file_path=$1
device_name=$2
mount_dir_name=usb_image_"$device_name"
syslinux_dir_name=syslinux

if [ $# -ge 3 ]
then
    mount_dir_name=$3
fi
if [ $# -ge 4 ]
then
    syslinux_dir_name=$4
fi

mount_dir=/mnt/$mount_dir_name
syslinux_dir=/mnt/$mount_dir_name/$syslinux_dir_name

# check iso file exists
if [ ! -f "$iso_file_path" ]
then
    echo "can not find iso file $iso_file_path"
    exit 1
fi

# check device exists
if [ ! -b /dev/"$device_name" ]
then
    echo "can not find device $device_name"
    exit 1
fi

# check device is removable
device_removable=$(cat "/sys/block/$device_name/removable")
if [ $? -ne 0 ]; then exit 1; fi
if [ "$device_removable" != '1' ]
then
    echo "device $device_name is not removable"
    exit 1
fi

# get device size
device_size=$(lsblk -dno SIZE "/dev/$device_name")
if [ $? -ne 0 ]; then exit 1; fi

# check tools
which parted >/dev/null 2>&1
if [ $? -ne 0 ]
then
    echo "parted not found"
    exit 1
fi

which mkfs.fat >/dev/null 2>&1
if [ $? -ne 0 ]
then
    echo "mkfs.fat not found"
    exit 1
fi

which 7z >/dev/null 2>&1
if [ $? -ne 0 ]
then
    echo "7z not found"
    exit 1
fi

which extlinux >/dev/null 2>&1
if [ $? -ne 0 ]
then
    echo "extlinux not found"
    exit 1
fi

which dd >/dev/null 2>&1
if [ $? -ne 0 ]
then
    echo "dd not found"
    exit 1
fi

# check root
if [ $(id -u) != '0' ]
then
    echo 'require root'
    exit 1
fi

# require user confirm
echo "[$iso_file_path] -> [/dev/$device_name($device_size)]"
echo "warning! all data in this device will be removed"
echo -n "are you sure to continue (Yes/n)"
read user_confirmed
if [ "$user_confirmed" != 'Yes' ]
then
    exit 0
fi

# create partition
echo "create partition ..."
parted -s "/dev/$device_name" \
    mklabel msdos \
    mkpart primary fat32 1MiB 100% \
    set 1 boot on
if [ $? -ne 0 ]; then exit 1; fi

# create file system
echo "create file system ..."
mkfs.fat -F 32 "/dev/${device_name}1" >/dev/null
if [ $? -ne 0 ]; then exit 1; fi

# mount device
echo "mount device to $mount_dir ..."
mkdir "$mount_dir"
if [ $? -ne 0 ]; then exit 1; fi
mount "/dev/${device_name}1" "$mount_dir"
if [ $? -ne 0 ]; then exit 1; fi

# extract iso file
echo "extract iso file ..."
7z x -o"$mount_dir" "$iso_file_path" >/dev/null
if [ $? -ne 0 ]; then exit 1; fi

# install syslinux
echo "install syslinux ..."
mkdir "$syslinux_dir"
if [ $? -ne 0 ]; then exit 1; fi
cp /usr/lib/syslinux/bios/*.c32 "$syslinux_dir"
if [ $? -ne 0 ]; then exit 1; fi
extlinux --install "$syslinux_dir"
if [ $? -ne 0 ]; then exit 1; fi

# umount device
echo "umount device ..."
umount "$mount_dir"
if [ $? -ne 0 ]; then exit 1; fi
rmdir "$mount_dir"
if [ $? -ne 0 ]; then exit 1; fi

# write bootstrap code
echo "write bootstrap code ..."
dd bs=440 count=1 conv=notrunc \
   if=/usr/lib/syslinux/bios/mbr.bin \
   of="/dev/$device_name" >/dev/null
if [ $? -ne 0 ]; then exit 1; fi

echo "finished"

exit 0
