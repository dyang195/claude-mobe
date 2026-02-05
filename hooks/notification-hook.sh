#!/bin/bash
# Notification Hook
# Plays appropriate sound based on notification type

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"

# Get sound type from argument (1beep or 2beep)
SOUND_TYPE="${1:-1beep}"

# Read hook input from stdin (required for hooks)
cat > /dev/null

# Play the sound
"$PLUGIN_ROOT/scripts/play-sound.sh" "$SOUND_TYPE" &

exit 0
