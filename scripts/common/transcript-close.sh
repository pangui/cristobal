#!/usr/bin/env bash
set -euo pipefail

# Closes the currently running transcript:
#   <ts_start>-<ts_mid>-<keyword>-running.md
#     → <ts_start>-<ts_end>-<keyword>-closed.md
# Also copies the latest native Claude Code JSONL session log alongside, if found.
# Output (stdout): <ts_end> and the paths of the closed files.

NOW=$(date +%s)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BRANCH_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
DIR="${BRANCH_ROOT}/transcripts"

shopt -s nullglob
RUNNING=("${DIR}"/*-running.md)
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
# filename = <ts_start>-<ts_mid>-<keyword>-running.md
CREATED=${filename%%-*}
REST=${filename#*-}            # <ts_mid>-<keyword>-running.md
REST_AFTER_MID=${REST#*-}      # <keyword>-running.md
KEYWORD=${REST_AFTER_MID%-running.md}

NEW_MD="${DIR}/${CREATED}-${NOW}-${KEYWORD}-closed.md"
mv "$OLD" "$NEW_MD"

# Derive native Claude Code sessions directory from branch root path.
# Example: /home/cristobal/cristobal/especialistas/arquitecto
#       → -home-cristobal-cristobal-especialistas-arquitecto
JSONL_DIR_NAME=$(echo "$BRANCH_ROOT" | sed 's|/|-|g')
SESSIONS_DIR="${HOME}/.claude/projects/${JSONL_DIR_NAME}"

if [ -d "$SESSIONS_DIR" ]; then
  LATEST_JSONL=$(ls -t "${SESSIONS_DIR}"/*.jsonl 2>/dev/null | head -1 || true)
  if [ -n "${LATEST_JSONL:-}" ]; then
    NEW_JSONL="${DIR}/${CREATED}-${NOW}-${KEYWORD}-closed.jsonl"
    cp "$LATEST_JSONL" "$NEW_JSONL"
    echo "$NEW_JSONL"
  fi
fi

echo "$NOW"
echo "$NEW_MD"
