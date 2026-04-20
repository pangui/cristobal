#!/usr/bin/env bash
set -euo pipefail

NOW=$(date +%s)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DIR="${SCRIPT_DIR}/../transcripts"

shopt -s nullglob
RUNNING=("${DIR}"/*-*-running.md)
shopt -u nullglob

if [ ${#RUNNING[@]} -eq 0 ]; then
  echo "Error: no running transcript found" >&2
  exit 1
elif [ ${#RUNNING[@]} -gt 1 ]; then
  echo "Error: multiple running transcripts found" >&2
  exit 1
fi

OLD="${RUNNING[0]}"
filename=$(basename "$OLD")
CREATED=${filename%%-*}
NEW="${DIR}/${CREATED}-${NOW}-running.md"

touch "$OLD"
mv "$OLD" "$NEW"
echo "$NOW"
