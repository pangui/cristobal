#!/bin/bash
# Latido cada 60s mientras el contenedor esté vivo.
while true; do
  date -u +%FT%TZ > "$HOME/.container-heartbeat"
  sleep 60
done
