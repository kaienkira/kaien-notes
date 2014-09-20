#!/bin/bash

ss_path=/home/kaien/proj/shadowsocks
config_path=/home/kaien/etc
run_path=/home/kaien/run

script_name=`basename $0`
prog=${ss_path}/shadowsocks/server.py
args="-c ${config_path}/config.json"
pid_file=${run_path}/ss.pid

usage()
{
    printf "usage: $script_name [start|stop|restart|status]\n"
    exit 1
}

show_error()
{
  local message=$1
  printf "\033[;31m%s\033[0m\n" "$message"
}

show_success()
{
  local message=$1
  printf "\033[;32m%s\033[0m\n" "$message"
}

op_start()
{
    printf "[starting shadowsocks server]"
    start-stop-daemon -T -p $pid_file
    if [ $? -eq 0 ]
    then
        show_error '[already started]'
    else
        start-stop-daemon -Smb -p $pid_file -a $prog -- $args >${run_path}/ss.log 2>&1
        if [ $? -eq 0 ]
        then
            show_success '[success]'
        else
            show_error '[failed]'
        fi
    fi
}

op_stop()
{
    printf "[stoping shadowsocks server]"
    start-stop-daemon -T -p $pid_file
    if [ $? -eq 0 ]
    then
        start-stop-daemon -K -p $pid_file
        if [ $? -eq 0 ]
        then
            show_success '[success]'
        else
            show_error '[failed]'
        fi
    else
        show_error '[not started]'
    fi
}

op_status()
{
    printf "shadowsocks server   "
    start-stop-daemon -T -p $pid_file
    if [ $? -eq 0 ]
    then
        show_success "[started]"
    else
        show_error "[stopped]"
    fi
}

if [ $# -ne 1 ]
then
    usage
fi

case $1 in
    start)
        op_start
        ;;
    stop)
        op_stop
        ;;
    restart)
        op_stop
        op_start
        ;;
    status)
        op_status
        ;;
    *)
        usage
        ;;
esac

exit 0
