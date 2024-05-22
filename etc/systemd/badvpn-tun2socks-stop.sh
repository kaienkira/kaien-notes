#!/bin/bash

set -o pipefail

script_abs_name=`readlink -f "$0"`
script_path=`dirname "$script_abs_name"`

config_file=`readlink -f "$script_path/badvpn-tun2socks-config.sh"`
if [ ! -f "$config_file" ]
then
    echo "$config_file is missing"
    exit 1
fi
source "$config_file"

ip route del default via "${cfg_tun_network_prefix}.2" metric 6 2>/dev/null
for i in $cfg_bypass_ip_list
do
    ip route del "$i" via "$cfg_gateway_ip" metric 5 2>/dev/null
done

ip route del default via "$cfg_gateway_ip" metric 100 2>/dev/null
ip route add default via "$cfg_gateway_ip" 2>/dev/null

ip link del "$cfg_tun_dev" 2>/dev/null

exit 0
