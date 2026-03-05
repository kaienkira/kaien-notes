#!/bin/bash

set -o pipefail

install_system_tools()
{
    emerge \
        app-portage/portage-utils
    if [ $? -ne 0 ]; then return 1; fi

    return 0
}

install_dev_tools()
{
    emerge \
        app-editors/neovim
    if [ $? -ne 0 ]; then return 1; fi

    return 0
}

install_system_tools
if [ $? -ne 0 ]; then exit 1; fi

install_dev_tools
if [ $? -ne 0 ]; then exit 1; fi

return 0
