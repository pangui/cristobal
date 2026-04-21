#!/bin/bash
set -euo pipefail

STATE_DIR="$HOME/.claude-state"
sudo chown "$(id -u):$(id -g)" "$STATE_DIR"
mkdir -p "$STATE_DIR/.claude"
[ -f "$STATE_DIR/.claude.json" ] || echo '{}' > "$STATE_DIR/.claude.json"

ln -sfn "$STATE_DIR/.claude"      "$HOME/.claude"
ln -sfn "$STATE_DIR/.claude.json" "$HOME/.claude.json"

touch "$HOME/cristobal/especialistas/cristobal/.env"

if [ -S /var/run/docker.sock ]; then
  sock_gid=$(stat -c '%g' /var/run/docker.sock)
  current_gid=$(getent group docker | cut -d: -f3 || echo "")
  if [ "$current_gid" != "$sock_gid" ]; then
    sudo groupmod -g "$sock_gid" docker
  fi
fi
