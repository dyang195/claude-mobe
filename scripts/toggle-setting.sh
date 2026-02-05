#!/bin/bash
# Toggle Setting Script
# Toggles a boolean setting and manages the file watcher for every-token mode

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"

# Check if jq is available
if ! command -v jq &> /dev/null; then
  echo "Error: jq is required. Install with: brew install jq" >&2
  exit 1
fi

SETTINGS_FILE="$HOME/.claude/mobe-settings.json"
TRANSCRIPT_FILE="$HOME/.claude/mobe-transcript-path.txt"
SETTING_NAME="${1:-}"

if [[ -z "$SETTING_NAME" ]]; then
  echo "Error: Setting name required" >&2
  exit 1
fi

# Create settings directory if needed
mkdir -p "$(dirname "$SETTINGS_FILE")"

# Create default settings if file doesn't exist
if [[ ! -f "$SETTINGS_FILE" ]]; then
  echo '{"everyTokenMode": false, "deepFriedMode": false}' > "$SETTINGS_FILE"
fi

# Get current value
CURRENT_VALUE=$(jq -r ".$SETTING_NAME // false" "$SETTINGS_FILE")

# Toggle the value
if [[ "$CURRENT_VALUE" == "true" ]]; then
  NEW_VALUE="false"
else
  NEW_VALUE="true"
fi

# Update the setting
jq ".$SETTING_NAME = $NEW_VALUE" "$SETTINGS_FILE" > "${SETTINGS_FILE}.tmp"
mv "${SETTINGS_FILE}.tmp" "$SETTINGS_FILE"

# Handle every-token mode - start/stop watcher immediately
if [[ "$SETTING_NAME" == "everyTokenMode" ]]; then
  if [[ "$NEW_VALUE" == "true" ]]; then
    # Start the watcher if we have the transcript path
    if [[ -f "$TRANSCRIPT_FILE" ]]; then
      TRANSCRIPT_PATH=$(cat "$TRANSCRIPT_FILE")
      if [[ -n "$TRANSCRIPT_PATH" ]] && [[ -f "$TRANSCRIPT_PATH" ]]; then
        "$PLUGIN_ROOT/scripts/file-watcher.sh" "$TRANSCRIPT_PATH" &
        echo "$!" > "/tmp/mobe-watcher-$$.pid"
      fi
    fi
  else
    # Kill any running watchers
    for pidfile in /tmp/mobe-watcher-*.pid; do
      if [[ -f "$pidfile" ]]; then
        PID=$(cat "$pidfile")
        kill "$PID" 2>/dev/null || true
        rm -f "$pidfile"
      fi
    done
  fi
fi

# Output the new value for confirmation
echo "$NEW_VALUE"
