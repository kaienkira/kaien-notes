#!/bin/bash

service_desc="shadowsocks server"
script_name=`basename $0`
prog=/home/kaien/proj/shadowsocks/shadowsocks/server.py
args="-c /home/kaien/etc/config.json"
pid_file=/home/kaien/run/ss.pid
log_file=/dev/null

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
    printf "[starting $service_desc]"
    start-stop-daemon -T -p $pid_file
    if [ $? -eq 0 ]
    then
        show_error '[already started]'
    else
        start-stop-daemon -Smb -p $pid_file -a /bin/bash -- \
                          -c "exec $prog $args >$log_file 2>&1"
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
    printf "[stoping $service_desc]"
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
    printf "[$service_desc status]"
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

case "$1" in
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
