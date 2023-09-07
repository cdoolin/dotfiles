#!/bin/bash

for cpu_path in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
  echo "power" > "$cpu_path"
done

