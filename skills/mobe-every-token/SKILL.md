---
name: mobe-every-token
description: Toggle every-token mode (Moby sound on every token)
allowed-tools: Bash
---

Toggle every-token mode (plays overlapping sounds as Claude types).

1. Run: `"$MOBE_PLUGIN_ROOT/scripts/toggle-setting.sh" everyTokenMode`
2. Show the new status (enabled or disabled)
3. If enabled, say "Mobe every token activated. You did this to yourself"
4. If disabled, say "Mobe every token deactivated."
