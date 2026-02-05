#!/bin/bash
# Session Start Hook
# Exports plugin root for Claude's bash commands and starts file watcher if every-token mode is enabled

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"
SETTINGS_FILE="$HOME/.claude/mobe-settings.json"
TRANSCRIPT_FILE="$HOME/.claude/mobe-transcript-path.txt"

# Read hook input from stdin
HOOK_INPUT=$(cat)

# Export MOBE_PLUGIN_ROOT so Claude's bash commands can find our scripts
if [[ -n "${CLAUDE_ENV_FILE:-}" ]]; then
  echo "export MOBE_PLUGIN_ROOT=\"$PLUGIN_ROOT\"" >> "$CLAUDE_ENV_FILE"
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
  exit 0
fi

# Save transcript path for use by toggle script
TRANSCRIPT_PATH=$(echo "$HOOK_INPUT" | jq -r '.transcript_path // empty')
if [[ -n "$TRANSCRIPT_PATH" ]]; then
  echo "$TRANSCRIPT_PATH" > "$TRANSCRIPT_FILE"
fi

# Check if every-token mode is enabled
if [[ -f "$SETTINGS_FILE" ]]; then
  EVERY_TOKEN=$(jq -r '.everyTokenMode // false' "$SETTINGS_FILE" 2>/dev/null || echo "false")
else
  EVERY_TOKEN="false"
fi

if [[ "$EVERY_TOKEN" == "true" ]] && [[ -n "$TRANSCRIPT_PATH" ]]; then
  # Start the file watcher in background
  "$PLUGIN_ROOT/scripts/file-watcher.sh" "$TRANSCRIPT_PATH" &
  WATCHER_PID=$!

  # Store PID for cleanup
  echo "$WATCHER_PID" > "/tmp/mobe-watcher-$$.pid"
fi

exit 0
