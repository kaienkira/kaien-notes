#!/bin/bash

if [ $# -ne 1 ]
then
    echo "usage `basename $0` <key>"
    exit 1
fi

printf "$1" | \
xxd -r -p | \
openssl enc -bf-cbc -nopad -nosalt -d -K 24A63DDE5BD3B3829C7E06F40816AA07 -iv 0 | \
head -c -4 | tail -c +5 | \
openssl enc -bf-cbc -nopad -nosalt -d -K 5FB045A29417D916C6C6A2FF064182B7 -iv 0 | \
awk -F '\0\0' '{ print $1; }'
