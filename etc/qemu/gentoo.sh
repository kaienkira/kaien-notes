#!/bin/bash

GBM_BACKEND=nvidia-drm \
__GLX_VENDOR_LIBRARY_NAME=nvidia \
__EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/10_nvidia.json \
VK_DRIVER_FILES=/usr/share/vulkan/icd.d/nvidia_icd.json \
LD_LIBRARY_PATH=$HOME/local/gui/lib/ \
$HOME/local/gui/bin/qemu-system-x86_64 \
    -machine type=q35,smm=on \
    -accel kvm,honor-guest-pat=on \
    -m 8192 -smp 8 -cpu host \
    -drive if=pflash,format=raw,unit=0,file=$HOME/local/gui/share/qemu/edk2-x86_64-code.fd,readonly=on \
    -drive if=pflash,format=raw,unit=1,file=$HOME/local/vm/gentoo/gentoo_vars.fd \
    -device virtio-scsi-pci,id=scsi0 \
    -drive file=$HOME/local/vm/gentoo/gentoo.qcow2,id=disk0,if=none,discard=unmap,detect-zeroes=unmap \
    -device scsi-hd,drive=disk0,bus=scsi0.0 \
    -nic user,model=virtio \
    -display egl-headless \
    -device virtio-vga-gl,xres=1920,yres=1080,hostmem=8G,blob=true,venus=true \
    -device virtio-serial-pci \
    -object secret,id=sec0,format=raw,file=$HOME/local/vm/tls-key/login_pass \
    -spice port=5902,disable-ticketing=off,password-secret=sec0,x509-dir=$HOME/local/vm/tls-key/ \
    -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
    -chardev spicevmc,id=spicechannel0,name=vdagent
