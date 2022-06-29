#!/bin/sh
#
# Unfuck your OSX networking, when switching VPNs/network devices

IFS=$'\n'
for i in `networksetup -listallhardwareports | awk -F": " '/Hardware Port/ { print $2 }'`; do
    echo "Fix $i"
    networksetup -setv4off $i > /dev/null 2>&1
    if [ "$?" = "0" ]; then
        sleep 1
        networksetup -setdhcp $i
    fi
done
