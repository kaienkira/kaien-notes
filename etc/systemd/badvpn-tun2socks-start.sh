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

ip tuntap add dev "$cfg_tun_dev" mode tun
if [ $? -ne 0 ]
then
    echo "ip tuntap add failed"
    exit 1
fi

ip addr change "${cfg_tun_network_prefix}.1/24" dev "$cfg_tun_dev"
if [ $? -ne 0 ]
then
    echo "ip addr change failed"
    exit 1
fi

ip link set "$cfg_tun_dev" up
if [ $? -ne 0 ]
then
    echo "ip link set up failed"
    exit 1
fi

ip route del default via "$cfg_gateway_ip"
ip route add default via "$cfg_gateway_ip" metric 100
for i in $cfg_bypass_ip_list
do
    ip route add "$i" via "$cfg_gateway_ip" metric 5
done
ip route add default via "${cfg_tun_network_prefix}.2" metric 6

exit 0
