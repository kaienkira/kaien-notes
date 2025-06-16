#!/bin/zsh

set -o pipefail

script_name=`basename $0`
script_abs_name=`readlink -f "$0"`
script_path=`dirname "$script_abs_name"`

function copy_file()
{
    local src_file=$1
    local dest_file=$2
    local dest_file_mod=$3

    cp "$src_file" "$dest_file"
    if [ $? -ne 0 ]; then exit 1; fi
    chmod "$dest_file_mod" "$dest_file"
    if [ $? -ne 0 ]; then exit 1; fi
}

function create_dir()
{
    local dir_path=$1
    local dir_mod=$2

    mkdir -p "$dir_path"
    if [ $? -ne 0 ]; then exit 1; fi
    chmod "$dir_mod" "$dir_path"
    if [ $? -ne 0 ]; then exit 1; fi
}

brew analytics off
if [ $? -ne 0 ]; then exit 1; fi

brew install \
    htop \
    git \
    trzsz-go \
    vim
if [ $? -ne 0 ]; then exit 1; fi

create_dir ~/Home 700

copy_file "$script_path"/_zshrc ~/.zshrc 600
copy_file "$script_path"/../archlinux/_vimrc ~/.vimrc 600
copy_file "$script_path"/../archlinux/_gitconfig ~/.gitconfig 600
copy_file "$script_path"/../archlinux/_gitignore ~/.gitignore 600

exit 0
