#!/bin/bash

qemu-system-x86_64 \
    -machine type=q35,smm=on,accel=kvm \
    -m 8192 -smp 8 -cpu host \
    -hda $HOME/local/vm/cachyos/cachyos.qcow2 \
    -nic user,model=virtio \
    -display egl-headless \
    -device virtio-vga-gl,xres=1920,yres=1080 \
    -device virtio-serial-pci \
    -object secret,id=sec0,format=raw,file=$HOME/local/vm/tls-key/login_pass \
    -spice port=5901,disable-ticketing=off,password-secret=sec0,x509-dir=$HOME/local/vm/tls-key/ \
    -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
    -chardev spicevmc,id=spicechannel0,name=vdagent
