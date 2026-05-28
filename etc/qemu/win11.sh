#!/bin/bash

swtpm socket --tpm2 --tpmstate dir=tpm --ctrl type=unixio,path=tpm/swtpm.sock --daemon --terminate

while [ ! -S tpm/swtpm.sock ]; do sleep 1; done

qemu-system-x86_64 \
    -machine type=q35,smm=on,accel=kvm \
    -m 4096 -smp 8 -cpu host \
    -drive if=pflash,format=raw,unit=0,file=/usr/share/OVMF/OVMF_CODE_4M.ms.fd,readonly=on \
    -drive if=pflash,format=raw,unit=1,file=./OVMF_VARS_win11.fd \
    -chardev socket,id=chrtpm,path=./tpm/swtpm.sock \
    -tpmdev emulator,id=tpm0,chardev=chrtpm \
    -device tpm-crb,tpmdev=tpm0 \
    -hda $HOME/local/vm/win11/win11.qcow2 \
    -nic user,model=e1000e \
    -display egl-headless \
    -device virtio-vga,xres=1920,yres=1080 \
    -device virtio-serial-pci \
    -object secret,id=sec0,format=raw,file=$HOME/local/vm/tls-key/login_pass \
    -spice port=5903,disable-ticketing=off,password-secret=sec0,x509-dir=$HOME/local/vm/tls-key/ \
    -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
    -chardev spicevmc,id=spicechannel0,name=vdagent \
    -cdrom $HOME/local/iso/virtio-win-0.1.285.iso
