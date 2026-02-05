# Claude Mobe

*Like Claude Code, but Moby*

A Claude Code plugin that plays the Moby robot sound (from Tim and Moby) as a ping/reminder. Features "every token mode" (Moby sound on every token) and "deep fried mode" (distorted Moby sounds).

## When It Mobes (beep sound)

**One Mobe** (needs your input):
- **Permission prompt** - Claude needs your approval
- **Idle prompt** - Claude's been waiting 60+ seconds

**Two Mobes** (complete/done):
- **Finished responding** - Claude's done talking
- **Auth success** - Authentication completed
- **Every token mode** - Rapid-fire two-beeps as Claude types (chaos mode)

## Requirements

- macOS (uses `afplay` for audio playback)
- `jq` for JSON parsing: `brew install jq`

## Installation

### Option 1: Install via Marketplace
Add the marketplace and install the plugin:
```bash
/plugin marketplace add dyang195/claude-mobe
/plugin install claude-mobe@claude-mobe
```

### Option 2: Local Testing
Clone and run with the `--plugin-dir` flag:
```bash
git clone https://github.com/dyang195/claude-mobe.git
claude --plugin-dir ./claude-mobe
```

### Add Sound Files (Required)
The plugin needs sound files to work properly. See `sounds/README.md` for instructions on getting the Moby sounds from YouTube.

Without sound files, the plugin falls back to the system Ping sound.

## Commands

- `/claude-mobe:mobe` - Show status and test the sound
- `/claude-mobe:mobe-every-token` - Toggle every-token mode (chaos mode)
- `/claude-mobe:mobe-deep-fried` - Toggle deep-fried mode (distorted audio)

## Settings

Settings are stored in `~/.claude/mobe-settings.json`:

```json
{
  "everyTokenMode": false,
  "deepFriedMode": false
}
```

## Architecture

```
claude-mobe/
├── .claude-plugin/
│   └── plugin.json              # Plugin manifest
├── hooks/
│   ├── hooks.json               # Hook configuration
│   ├── session-start.sh         # Start file watcher if every-token enabled
│   ├── session-end.sh           # Clean up file watcher process
│   ├── stop-hook.sh             # Play sound when Claude stops
│   └── notification-hook.sh     # Play sound on notifications
├── scripts/
│   ├── file-watcher.sh          # Background transcript watcher (50ms polling)
│   ├── play-sound.sh            # Sound playback wrapper
│   └── toggle-setting.sh        # Toggle settings
├── sounds/
│   ├── README.md                # Instructions for getting sounds
│   ├── moby-1beep.wav           # Single beep (needs input)
│   ├── moby-2beep.wav           # Double beep (complete/done)
│   ├── moby-1beep-deepfried.wav # Deep fried single beep
│   └── moby-2beep-deepfried.wav # Deep fried double beep
└── commands/
    ├── mobe.md                  # Status + test sound
    ├── mobe-every-token.md      # Toggle every-token mode
    └── mobe-deep-fried.md       # Toggle deep-fried mode
```

## License

MIT
