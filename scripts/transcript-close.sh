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
NEW_MD="${DIR}/${CREATED}-${NOW}-closed.md"

mv "$OLD" "$NEW_MD"

# Copy native Claude Code JSONL session log alongside, if found
SESSIONS_DIR="${HOME}/.claude/projects/-home-cristobal-arquitecto"
if [ -d "$SESSIONS_DIR" ]; then
  LATEST_JSONL=$(ls -t "${SESSIONS_DIR}"/*.jsonl 2>/dev/null | head -1)
  if [ -n "$LATEST_JSONL" ]; then
    NEW_JSONL="${DIR}/${CREATED}-${NOW}-closed.jsonl"
    cp "$LATEST_JSONL" "$NEW_JSONL"
    echo "$NEW_JSONL"
  fi
fi

echo "$NOW"
echo "$NEW_MD"
