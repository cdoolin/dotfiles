#!/bin/sh
set -eu

# Sway has created its display by the time this helper runs.
dbus-update-activation-environment --systemd \
    DISPLAY WAYLAND_DISPLAY SWAYSOCK \
    XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE XDG_DATA_DIRS

# Recover failed or stale activation before apps make portal requests.
systemctl --user stop xdg-desktop-portal.service
systemctl --user reset-failed \
    xdg-desktop-portal-gtk.service \
    xdg-desktop-portal-wlr.service
systemctl --user restart \
    xdg-desktop-portal-gtk.service \
    xdg-desktop-portal-wlr.service
systemctl --user start xdg-desktop-portal.service

"$HOME/.config/waybar/waybar.sh" &
"${1:-ghostty}" +new-window &
dex --autostart --environment sway
