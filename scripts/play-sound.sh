#!/bin/bash
# Play Sound Script
# Plays the appropriate Moby sound based on settings

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"
SOUNDS_DIR="$PLUGIN_ROOT/sounds"
SETTINGS_FILE="$HOME/.claude/mobe-settings.json"

# Get sound type from argument (1beep or 2beep)
SOUND_TYPE="${1:-2beep}"

# Check if deep-fried mode is enabled (requires jq)
DEEP_FRIED="false"
if command -v jq &> /dev/null && [[ -f "$SETTINGS_FILE" ]]; then
  DEEP_FRIED=$(jq -r '.deepFriedMode // false' "$SETTINGS_FILE" 2>/dev/null || echo "false")
fi

# Determine which sound file to play
if [[ "$DEEP_FRIED" == "true" ]]; then
  SOUND_FILE="$SOUNDS_DIR/moby-${SOUND_TYPE}-deepfried.wav"
else
  SOUND_FILE="$SOUNDS_DIR/moby-${SOUND_TYPE}.wav"
fi

# Fall back to normal version if deep-fried doesn't exist
if [[ ! -f "$SOUND_FILE" ]]; then
  SOUND_FILE="$SOUNDS_DIR/moby-${SOUND_TYPE}.wav"
fi

# Play the sound if it exists (non-blocking for overlap support)
if [[ -f "$SOUND_FILE" ]]; then
  afplay "$SOUND_FILE" &
else
  # Fallback to system sound if no custom sounds installed
  afplay /System/Library/Sounds/Ping.aiff &
fi

exit 0
