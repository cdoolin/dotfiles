#!/bin/sh

if [ -f /sys/class/power_supply/BAT0/power_now ]; then
    cat /sys/class/power_supply/BAT0/power_now | awk '{printf "%.1f", $1 / 1000000}'
fi
