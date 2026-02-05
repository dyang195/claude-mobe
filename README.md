# Claude Mobe

*Like Claude Code, but Moby*

A Claude Code plugin that plays Moby (from Tim and Moby)'s robot sound as a ping/reminder. Features "every token mode" (mobe on every token) and "deep fried mode" (distorted mobing).

## When does it Mobe (beep)

**One Mobe** (needs your input):
- **Permission prompt** - Claude needs your approval

**Two Mobes** (complete/done):
- **Finished responding** - Claude's done talking
- **Auth success** - Authentication completed
- **Every token mode** - Rapid-fire two-beeps as Claude types (chaos mode)

## I wanna Claude Mobe

### Option 1: Quick Start (Try It Out)
Clone and run with the plugin loaded for this session.

1. Clone the repo:
```bash
git clone https://github.com/dyang195/claude-mobe.git ~/.claude/plugins/claude-mobe
```

2. Run Claude with the plugin:
```bash
claude --plugin-dir ~/.claude/plugins/claude-mobe
```

Note: `--plugin-dir` loads the plugin for the current session only. It won't appear in `plugin list`.

### [COMING SOON] Option 2: Permanent Install (via Marketplace) 
Install permanently so it loads automatically every session. Run these inside Claude Code:

1. Add the marketplace:
```
/plugin marketplace add dyang195/claude-mobe
```

2. Install the plugin:
```
/plugin install claude-mobe@claude-mobe
```

## Requirements

- macOS (uses `afplay` for audio playback)
- `jq` (optional) - only needed for `/mobe-every-token` and `/mobe-deep-fried` commands: `brew install jq`

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
