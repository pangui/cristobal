#!/bin/bash
set -euo pipefail

STATE_DIR="$HOME/.claude-state"
sudo chown "$(id -u):$(id -g)" "$STATE_DIR"
mkdir -p "$STATE_DIR/.claude"
[ -f "$STATE_DIR/.claude.json" ] || echo '{}' > "$STATE_DIR/.claude.json"

ln -sfn "$STATE_DIR/.claude"      "$HOME/.claude"
ln -sfn "$STATE_DIR/.claude.json" "$HOME/.claude.json"

touch "$HOME/repos/cristobal/cristobal/.env"
