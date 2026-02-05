---
name: mobe
description: Show Claude Mobe status and test the sound
allowed-tools: Bash, Read
---

Show Claude Mobe status and test the sound.

1. Read `~/.claude/mobe-settings.json` (defaults: everyTokenMode=false, deepFriedMode=false)
2. Display current status (everyTokenMode, deepFriedMode)
3. Test the sound by running: `"$MOBE_PLUGIN_ROOT/scripts/play-sound.sh" 2beep`
4. List other commands: `/claude-mobe:mobe-every-token`, `/claude-mobe:mobe-deep-fried`
