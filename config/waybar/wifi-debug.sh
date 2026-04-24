#!/usr/bin/env bash

IFACE="wlp1s0"

link_info="$(iw dev "$IFACE" link 2>/dev/null)"
if ! grep -q '^Connected to ' <<< "$link_info"; then
  echo '{"text":" down","tooltip":"Wi-Fi disconnected","class":"down"}'
  exit 0
fi

ssid="$(awk -F': ' '/SSID:/ {print $2; exit}' <<< "$link_info")"
bssid="$(awk '/^Connected to / {print $3; exit}' <<< "$link_info")"
freq="$(awk -F': ' '/freq:/ {print $2; exit}' <<< "$link_info")"
signal="$(awk -F': ' '/signal:/ {print $2; exit}' <<< "$link_info" | awk '{print $1}')"
rx="$(awk -F': ' '/RX:/ {print $2; exit}' <<< "$link_info")"
tx="$(awk -F': ' '/TX:/ {print $2; exit}' <<< "$link_info")"

band="?"
channel="?"

if [[ -n "$freq" ]]; then
  if (( freq >= 2400 && freq < 2500 )); then
    band="2.4G"
    channel="$(( (freq - 2407) / 5 ))"
  elif (( freq >= 5000 && freq < 5900 )); then
    band="5G"
    channel="$(( (freq - 5000) / 5 ))"
  elif (( freq >= 5950 && freq < 7125 )); then
    band="6G"
    channel="$(( (freq - 5950) / 5 ))"
  fi
fi

ip_addr="$(ip -4 addr show dev "$IFACE" | awk '/inet / {print $2}' | cut -d/ -f1 | head -n1)"
gw="$(ip route | awk -v dev="$IFACE" '$1=="default" && $0 ~ dev {print $3; exit}')"

power_save="$(iw dev "$IFACE" get power_save 2>/dev/null | awk '{print $3}')"
[[ -z "$power_save" ]] && power_save="unknown"

loss="N/A"
avg_ping="N/A"

if [[ -n "$gw" ]]; then
  ping_out="$(ping -n -q -c 3 -W 1 "$gw" 2>/dev/null)"
  loss="$(awk -F', ' '/packet loss/ {print $3}' <<< "$ping_out" | awk '{print $1}')"
  avg_ping="$(awk -F'/' '/^rtt|^round-trip/ {print $5 " ms"}' <<< "$ping_out")"
fi

text=" ${signal}dBm ${band} ch${channel} ${avg_ping}"

tooltip="SSID: ${ssid}
BSSID: ${bssid}
Iface: ${IFACE}
Signal: ${signal} dBm
Band: ${band}
Freq: ${freq} MHz
Channel: ${channel}
RX bitrate: ${rx}
TX bitrate: ${tx}
IP: ${ip_addr:-N/A}
GW: ${gw:-N/A}
Ping GW avg: ${avg_ping}
Packet loss: ${loss}
Power save: ${power_save}"

class="good"
if [[ "$signal" =~ ^-?[0-9]+$ ]]; then
  if (( signal <= -75 )); then
    class="bad"
  elif (( signal <= -67 )); then
    class="warn"
  fi
fi

if [[ "$avg_ping" == "N/A" ]]; then
  class="warn"
fi

printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' \
  "$text" \
  "$(sed ':a;N;$!ba;s/\n/\\n/g' <<< "$tooltip")" \
  "$class"
