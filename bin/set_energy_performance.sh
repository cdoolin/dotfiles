#!/bin/bash

if [[ "$1" == "--help" ]]; then
  echo "Available modes:"
  cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_available_preferences
  exit 0
fi

MODE=${1:-power}
echo setting power mode to $MODE

for cpu_path in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
  echo $MODE > "$cpu_path"
done

