#!/bin/bash
# Session End Hook
# Cleans up file watcher and resets settings

set -euo pipefail

SETTINGS_FILE="$HOME/.claude/mobe-settings.json"

# Find and kill any file watcher processes
for pidfile in /tmp/mobe-watcher-*.pid; do
  if [[ -f "$pidfile" ]]; then
    PID=$(cat "$pidfile")
    if kill -0 "$PID" 2>/dev/null; then
      kill "$PID" 2>/dev/null || true
    fi
    rm -f "$pidfile"
  fi
done

# Clean up transcript path file
rm -f "$HOME/.claude/mobe-transcript-path.txt"

# Reset settings to defaults
echo '{"everyTokenMode": false, "deepFriedMode": false}' > "$SETTINGS_FILE"

exit 0
