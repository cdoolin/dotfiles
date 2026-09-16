#!/bin/sh
set -eu

pid_file="${XDG_RUNTIME_DIR:?}/sway-exit-confirm.pid"

if [ "${1:-}" = cancel ]; then
    if [ -r "$pid_file" ]; then
        read -r helper_pid < "$pid_file"
        kill -TERM "$helper_pid" 2>/dev/null || true
    fi
    swaymsg 'mode "default"' >/dev/null
    exit 0
fi

# Allow only one confirmation bar at a time.
exec 9>"${XDG_RUNTIME_DIR}/sway-exit-confirm.lock"
flock -n 9 || exit 0

bar_pid=
cleanup() {
    trap - EXIT HUP INT TERM
    if [ -n "$bar_pid" ]; then
        kill "$bar_pid" 2>/dev/null || true
        wait "$bar_pid" 2>/dev/null || true
    fi
    rm -f "$pid_file"
    swaymsg 'mode "default"' >/dev/null 2>&1 || true
}
trap cleanup EXIT
trap 'exit 0' HUP INT TERM
printf '%s\n' "$$" > "$pid_file"

swaynag -t warning \
    -m 'Exit Sway? Press Win+Shift+E again or Y to exit; Esc or N to cancel.' \
    -B 'Yes, exit Sway' 'swaymsg exit' &
bar_pid=$!
swaymsg 'mode "exit-confirm"' >/dev/null
wait "$bar_pid" || true
