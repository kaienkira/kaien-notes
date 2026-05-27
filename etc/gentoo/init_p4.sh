#!/bin/bash

set -o pipefail

install_system_tools()
{
    emerge \
        app-portage/gentoolkit \
        app-portage/portage-utils
    if [ $? -ne 0 ]; then return 1; fi

    return 0
}

install_emulation_tools()
{
    printf '%s\n' \
    'app-emulation/qemu virtfs' \
    >/etc/portage/package.use/emulation
    if [ $? -ne 0 ]; then return 1; fi

    emerge \
        app-emulation/qemu
    if [ $? -ne 0 ]; then return 1; fi

    return 0
}

install_dev_tools()
{
    emerge \
        app-editors/neovim \
        dev-lang/go \
        dev-lang/rust \
        dev-lang/php
    if [ $? -ne 0 ]; then return 1; fi

    return 0
}

install_gui_tools()
{
    emerge \
        gui-wm/sway
    if [ $? -ne 0 ]; then return 1; fi

    return 0
}

install_system_tools
if [ $? -ne 0 ]; then exit 1; fi
install_emulation_tools
if [ $? -ne 0 ]; then exit 1; fi
install_dev_tools
if [ $? -ne 0 ]; then exit 1; fi
install_gui_tools
if [ $? -ne 0 ]; then exit 1; fi

return 0
