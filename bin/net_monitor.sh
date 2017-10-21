#!/bin/bash

if [ $# -eq 1 ]
then
    port=$1
    interface=
elif [ $# -eq 2 ]
then
    port=$1
    interface=$2
else
    echo "usage: `basename $0` <port> [interface]"
    exit 1
fi

if [ ! -z "$interface" ]
then
    interface_arg="-i $interface"
fi

sudo tcpdump -U tcp port $port $interface_arg -w - | htcpflow -Ce -
