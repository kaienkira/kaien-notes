#!/bin/bash

set -o pipefail

script_name=`basename $0`
script_abs_name=`readlink -f "$0"`
script_path=`dirname "$script_abs_name"`

copy_file()
{
    local src_file=$1
    local dest_file=$2
    local dest_file_mod=$3

    cp "$src_file" "$dest_file"
    if [ $? -ne 0 ]; then exit 1; fi
    chmod "$dest_file_mod" "$dest_file"
    if [ $? -ne 0 ]; then exit 1; fi
}

create_dir()
{
    local dir_path=$1
    local dir_mod=$2

    mkdir -p "$dir_path"
    if [ $? -ne 0 ]; then exit 1; fi
    chmod "$dir_mod" "$dir_path"
    if [ $? -ne 0 ]; then exit 1; fi
}

create_dir ~/.config 700
create_dir ~/.config/openbox 700
create_dir ~/.config/sakura 700
create_dir ~/.config/tint2 700
create_dir ~/.config/systemd 700
create_dir ~/.config/systemd/user 700
create_dir ~/.local 700
create_dir ~/.local/share 700
create_dir ~/.local/share/applications 700
create_dir ~/local 755
create_dir ~/local/firefox_profile 755
create_dir ~/local/firefox_profile/profile_1 700
create_dir ~/local/firefox_profile/profile_2 700

copy_file "$script_path/../_vimrc" ~/.vimrc 600
copy_file "$script_path/../_gitconfig" ~/.gitconfig 600
copy_file "$script_path/../_gitignore" ~/.gitignore 600
copy_file "$script_path/_xinitrc" ~/.xinitrc 600
copy_file "$script_path/_Xdefaults" ~/.Xdefaults 600
copy_file "$script_path/openbox_rc.xml" ~/.config/openbox/rc.xml 600
copy_file "$script_path/openbox_menu.xml" ~/.config/openbox/menu.xml 600
copy_file "$script_path/sakura.conf" ~/.config/sakura/sakura.conf 600
copy_file "$script_path/tint2rc" ~/.config/tint2/tint2rc 600
copy_file "$script_path/systemd/tl-client.service" \
          ~/.config/systemd/user/tl-client.service 600
copy_file "$script_path/applications/firefox-1.desktop" \
          ~/.local/share/applications/firefox-1.desktop 600
copy_file "$script_path/applications/firefox-2.desktop" \
          ~/.local/share/applications/firefox-2.desktop 600

exit 0
