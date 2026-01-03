#!/bin/sh

# 1. Check if Tailscale is installed
if ! command -v tailscale >/dev/null 2>&1; then
    echo '{"text": "ts: ni", "class": "not-installed", "tooltip": "Tailscale is not installed"}'
    exit 0
fi

# 2. Fetch status
STATUS_JSON=$(tailscale status --json 2>/dev/null)
STATUS_TEXT=$(tailscale status 2>/dev/null) # Get the raw text list of devices

# Check if the command failed
if [ $? -ne 0 ]; then
    echo '{"text": "ts: x", "class": "disconnected", "tooltip": "Tailscale daemon is unreachable"}'
    exit 0
fi

# 3. Check the 'BackendState'
STATE=$(echo "$STATUS_JSON" | jq -r .BackendState)

if [ "$STATE" != "Running" ]; then
    echo "{\"text\": \"ts: x\", \"class\": \"stopped\", \"tooltip\": \"Status: $STATE\"}"
    exit 0
fi

# 4. Extract info
# Text: CurrentTailnet.Name
NAME=$(echo "$STATUS_JSON" | jq -r '.CurrentTailnet.Name // .MagicDNSSuffix // "unknown"')

# Tooltip Header: MagicDNSSuffix
SUFFIX=$(echo "$STATUS_JSON" | jq -r '.CurrentTailnet.MagicDNSSuffix // .MagicDNSSuffix // "No MagicDNS"')

# 5. Build JSON output using jq
# We pass the variables into jq arguments (--arg) so it handles newlines/escaping automatically.
jq -n -c \
  --arg text "ts: $NAME" \
  --arg suffix "$SUFFIX" \
  --arg list "$STATUS_TEXT" \
  '{
     "text": $text,
     "class": "connected",
     "tooltip": ($suffix + "\n\n" + $list)
   }'

