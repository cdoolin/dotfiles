#!/usr/bin/env python3

import json
import re
import subprocess

IFACE = "wlp1s0"


def run(cmd):
    try:
        return subprocess.check_output(cmd, text=True, stderr=subprocess.DEVNULL).strip()
    except subprocess.CalledProcessError:
        return ""
    except FileNotFoundError:
        return ""


def parse_iw_link(iface):
    out = run(["iw", "dev", iface, "link"])
    if not out or "Not connected" in out:
        return None

    data = {
        "raw": out,
        "bssid": None,
        "ssid": None,
        "freq": None,
        "signal": None,
        "rx_bitrate": None,
        "tx_bitrate": None,
    }

    m = re.search(r"Connected to ([0-9a-f:]{17})", out, re.I)
    if m:
        data["bssid"] = m.group(1)

    patterns = {
        "ssid": r"^\s*SSID:\s+(.+)$",
        "freq": r"^\s*freq:\s+([0-9.]+)$",
        "signal": r"^\s*signal:\s+(-?[0-9]+)\s+dBm$",
        "rx_bitrate": r"^\s*rx bitrate:\s+(.+)$",
        "tx_bitrate": r"^\s*tx bitrate:\s+(.+)$",
    }

    for key, pat in patterns.items():
        m = re.search(pat, out, re.M)
        if m:
            data[key] = m.group(1)

    # fallback for older iw output
    if not data["rx_bitrate"]:
        m = re.search(r"^\s*RX:\s+(.+)$", out, re.M)
        if m:
            data["rx_bitrate"] = m.group(1)
    if not data["tx_bitrate"]:
        m = re.search(r"^\s*TX:\s+(.+)$", out, re.M)
        if m:
            data["tx_bitrate"] = m.group(1)

    return data


def band_and_channel(freq):
    if freq is None:
        return "?", "?"
    try:
        f = int(float(freq))
    except ValueError:
        return "?", "?"

    if 2400 <= f < 2500:
        return "2.4G", str((f - 2407) // 5)
    if 5000 <= f < 5900:
        return "5G", str((f - 5000) // 5)
    if 5950 <= f < 7125:
        return "6G", str((f - 5950) // 5)
    return "?", "?"


def get_ip_addr(iface):
    out = run(["ip", "-4", "addr", "show", "dev", iface])
    m = re.search(r"\binet\s+([0-9.]+)/", out)
    return m.group(1) if m else None


def get_gateway(iface):
    out = run(["ip", "route"])
    for line in out.splitlines():
        if line.startswith("default") and f" dev {iface}" in line:
            parts = line.split()
            if "via" in parts:
                return parts[parts.index("via") + 1]
    return None


def get_power_save(iface):
    out = run(["iw", "dev", iface, "get", "power_save"])
    m = re.search(r"Power save:\s+(\w+)", out, re.I)
    return m.group(1).lower() if m else "unknown"


def ping_host(host):
    if not host:
        return None, None
    out = run(["ping", "-n", "-q", "-c", "5", "-W", "1", host])
    if not out:
        return None, None

    loss = None
    avg = None

    m = re.search(r"([0-9.]+)% packet loss", out)
    if m:
        loss = float(m.group(1))

    m = re.search(r"(?:rtt|round-trip) min/avg/max/(?:mdev|stddev) = [0-9.]+/([0-9.]+)/", out)
    if m:
        avg = float(m.group(1))

    return loss, avg


def classify(signal, loss, avg_ping):
    cls = "good"

    if signal is not None:
        if signal <= -75:
            cls = "bad"
        elif signal <= -67:
            cls = "warn"

    if loss is not None:
        if loss > 20:
            cls = "bad"
        elif loss > 0 and cls == "good":
            cls = "warn"

    if avg_ping is not None:
        if avg_ping > 100:
            cls = "bad"
        elif avg_ping > 20 and cls == "good":
            cls = "warn"

    return cls


def diagnosis(signal, loss, avg_ping):
    if signal is not None and signal <= -72:
        return "Weak signal likely"
    if signal is not None and signal > -67:
        if (loss is not None and loss > 0) or (avg_ping is not None and avg_ping > 20):
            return "Interference/congestion possible"
    if signal is not None and avg_ping is not None and signal > -67 and avg_ping <= 10 and (loss is None or loss == 0):
        return "Link looks healthy"
    return "Mixed/unclear"


def main():
    link = parse_iw_link(IFACE)
    if not link:
        print(json.dumps({
            "text": " down",
            "tooltip": "Wi-Fi disconnected",
            "class": "down"
        }))
        return

    signal = int(link["signal"]) if link["signal"] is not None else None
    band, channel = band_and_channel(link["freq"])
    ip_addr = get_ip_addr(IFACE)
    gateway = get_gateway(IFACE)
    power_save = get_power_save(IFACE)
    loss, avg_ping = ping_host(gateway)

    ping_display = f"{avg_ping:.1f} ms" if avg_ping is not None else "N/A"
    loss_display = f"{loss:.1f}%" if loss is not None else "N/A"
    cls = classify(signal, loss, avg_ping)
    hint = diagnosis(signal, loss, avg_ping)

    text = f" {signal if signal is not None else '?'}dBm {band} ch{channel} {ping_display}"

    tooltip = "\n".join([
        f"SSID: {link['ssid'] or 'N/A'}",
        f"BSSID: {link['bssid'] or 'N/A'}",
        f"Iface: {IFACE}",
        f"Signal: {signal if signal is not None else 'N/A'} dBm",
        f"Band: {band}",
        f"Freq: {link['freq'] or 'N/A'} MHz",
        f"Channel: {channel}",
        f"RX bitrate: {link['rx_bitrate'] or 'N/A'}",
        f"TX bitrate: {link['tx_bitrate'] or 'N/A'}",
        f"IP: {ip_addr or 'N/A'}",
        f"GW: {gateway or 'N/A'}",
        f"Ping GW avg: {ping_display}",
        f"Packet loss: {loss_display}",
        f"Power save: {power_save}",
        f"Hint: {hint}",
    ])

    print(json.dumps({
        "text": text,
        "tooltip": tooltip,
        "class": cls
    }))


if __name__ == "__main__":
    main()
