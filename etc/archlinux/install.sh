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
create_dir ~/.config/tint2 700
create_dir ~/.config/i3 700
create_dir ~/.config/i3status 700
create_dir ~/.config/rofi 700
create_dir ~/.config/sway 700
create_dir ~/.config/xfce4 700
create_dir ~/.config/xfce4/terminal 700
create_dir ~/.config/fcitx5 700
create_dir ~/.config/fcitx5/conf 700
create_dir ~/.config/systemd 700
create_dir ~/.config/systemd/user 700
create_dir ~/.local 700
create_dir ~/.local/share 700
create_dir ~/.local/share/applications 700
create_dir ~/local 700
create_dir ~/local/firefox-profile 755
create_dir ~/local/firefox-profile/profile-1 700
create_dir ~/local/firefox-profile/profile-2 700

copy_file "$script_path"/../_vimrc ~/.vimrc 600
copy_file "$script_path"/../_gitconfig ~/.gitconfig 600
copy_file "$script_path"/../_gitignore ~/.gitignore 600
copy_file "$script_path"/_fonts.conf ~/.fonts.conf 600
copy_file "$script_path"/_xinitrc ~/.xinitrc 600
copy_file "$script_path"/_xprofile ~/.xprofile 600
copy_file "$script_path"/_pam_environment ~/.pam_environment 600
copy_file "$script_path"/openbox_rc.xml ~/.config/openbox/rc.xml 600
copy_file "$script_path"/openbox_menu.xml ~/.config/openbox/menu.xml 600
copy_file "$script_path"/openbox_autostart ~/.config/openbox/autostart 600
copy_file "$script_path"/tint2rc ~/.config/tint2/tint2rc 600
copy_file "$script_path"/tint2_i3status_config ~/.config/tint2/i3status_config 600
copy_file "$script_path"/tint2_conkyrc ~/.config/tint2/conkyrc 600
copy_file "$script_path"/i3_config ~/.config/i3/config 600
copy_file "$script_path"/i3status_config ~/.config/i3status/config 600
copy_file "$script_path"/rofi_config.rasi ~/.config/rofi/config.rasi 600
copy_file "$script_path"/sway_config ~/.config/sway/config 600
copy_file "$script_path"/xfce4_terminal_terminalrc ~/.config/xfce4/terminal/terminalrc 600
copy_file "$script_path"/xfce4_terminal_accels.scm ~/.config/xfce4/terminal/accels.scm 600
copy_file "$script_path"/fcitx5_profile ~/.config/fcitx5/profile 600
copy_file "$script_path"/fcitx5_classicui.conf ~/.config/fcitx5/conf/classicui.conf 600
copy_file "$script_path"/systemd/tl-client.service \
          ~/.config/systemd/user/tl-client.service 600
copy_file "$script_path"/applications/firefox-1.desktop \
          ~/.local/share/applications/firefox-1.desktop 600
copy_file "$script_path"/applications/firefox-2.desktop \
          ~/.local/share/applications/firefox-2.desktop 600

exit 0
