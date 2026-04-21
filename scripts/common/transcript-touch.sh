#!/usr/bin/env bash
set -euo pipefail

# Updates the middle timestamp of the currently running transcript.
# Output (stdout): <ts_now>

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

NEW="${DIR}/${CREATED}-${NOW}-${KEYWORD}-running.md"

touch "$OLD"
mv "$OLD" "$NEW"
echo "$NOW"
