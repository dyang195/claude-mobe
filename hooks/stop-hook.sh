#!/bin/bash
# Stop Hook
# Plays double beep when Claude finishes responding

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"

# Read hook input from stdin (required for stop hooks)
cat > /dev/null

# Play the 2-beep sound (complete/done)
"$PLUGIN_ROOT/scripts/play-sound.sh" 2beep &

exit 0
