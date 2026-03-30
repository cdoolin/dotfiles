#!/usr/bin/bash

iw dev wlp1s0 link
sudo dmesg | grep -iE 'ath11k|wmi|mhi|firmware|fail|error|timeout|warn' | tail -100

