#!/bin/bash
# Lanza (si no existe) un daemon que mantiene actividad continua dentro
# del contenedor. Sin esto, la conexión vscode-server/Cursor cae tras
# inactividad — los otros devcontainers del host no sufren el síntoma
# porque siempre tienen procesos de usuario corriendo (foreman, bin/dev, etc).
set -e

DAEMON="$(dirname "$(readlink -f "$0")")/keepalive-daemon.sh"

if pgrep -u "$(id -u)" -fx "$DAEMON" >/dev/null 2>&1; then
  exit 0
fi

setsid -f "$DAEMON" </dev/null >/dev/null 2>&1
