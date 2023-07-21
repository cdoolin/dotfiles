#!/usr/bin/env bash


new=${1:-4000}
current=$(pgrep -a gammastep | awk '{print $NF}')

if [ -z $current ]; then
    gammastep -O $new
elif [ "$current" -ne "$new" ]; then
    killall gammastep
    gammastep -O $new
else
    killall gammastep
fi

