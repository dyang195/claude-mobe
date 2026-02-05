#!/bin/bash
# File Watcher Script
# Polls transcript and plays staggered sounds for every ~30 bytes of new content (chaos mode)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"

TRANSCRIPT_PATH="$1"
BYTES_PER_BEEP=30  # Roughly one word

if [[ -z "$TRANSCRIPT_PATH" ]] || [[ ! -f "$TRANSCRIPT_PATH" ]]; then
  exit 1
fi

# Get initial file size
LAST_SIZE=$(stat -f%z "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")

# Poll every 30ms for responsiveness
while true; do
  if [[ ! -f "$TRANSCRIPT_PATH" ]]; then
    exit 0
  fi

  CURRENT_SIZE=$(stat -f%z "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")

  if [[ "$CURRENT_SIZE" -gt "$LAST_SIZE" ]]; then
    # Calculate how many beeps based on bytes added
    DELTA=$((CURRENT_SIZE - LAST_SIZE))
    NUM_BEEPS=$((DELTA / BYTES_PER_BEEP))

    # At least one beep if anything changed
    if [[ "$NUM_BEEPS" -lt 1 ]]; then
      NUM_BEEPS=1
    fi

    # Fire off staggered beeps (50ms apart for overlapping effect)
    for ((i=0; i<NUM_BEEPS; i++)); do
      (sleep "$(awk "BEGIN {print $i * 0.05}")" && "$PLUGIN_ROOT/scripts/play-sound.sh" 2beep) &
    done

    LAST_SIZE="$CURRENT_SIZE"
  fi

  sleep 0.03
done
