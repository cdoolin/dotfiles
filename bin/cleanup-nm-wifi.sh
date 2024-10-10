#!/bin/bash

# Get the cutoff date, which is 6 months ago
cutoff_date=$(date --date="9 months ago" +%s)

# List all Wi-Fi connections
for uuid in $(nmcli -t -f UUID,TYPE c | grep wireless | cut -d: -f1)
do
    # Check when the connection was last used
    last_used=$(nmcli -f connection.id,connection.type,connection.timestamp con show "$uuid" |
                grep "timestamp:" |
                awk '{print $2}')
    
    # Get the SSID (Wi-Fi network name) associated with the UUID
    ssid=$(nmcli -f 802-11-wireless.ssid con show "$uuid" | grep "802-11-wireless.ssid" | sed 's/802-11-wireless.ssid: //' | sed 's/^[ \t]*//;s/[ \t]*$//')

    # Compare last used timestamp with the cutoff
    if [[ $last_used -lt $cutoff_date ]]; then
        echo "DELETE UUID: $uuid | SSID: $ssid | Last Used: $last_used"
        nmcli connection delete uuid "$uuid"
    else 
        echo " OK    UUID: $uuid | SSID: $ssid | Last Used: $last_used"
    fi
done

