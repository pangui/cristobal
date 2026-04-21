#!/usr/bin/env bash
set -euo pipefail

# Usage: transcript-start.sh <keyword>
#   <keyword> identifies the other party:
#     - "ccs" for a conversation with Cristóbal Campos
#     - "<rol>" for a conversation with another Cristóbal (e.g., "main", "rebuss", "arquitecto")
#
# Creates: <branch-root>/transcripts/<ts_start>-<ts_start>-<keyword>-running.md
# Output (stdout): <ts_start>

if [ $# -lt 1 ] || [ -z "${1:-}" ]; then
  echo "Error: keyword required (usage: transcript-start.sh <keyword>)" >&2
  exit 1
fi

KEYWORD="$1"
if ! [[ "$KEYWORD" =~ ^[a-z0-9_-]+$ ]]; then
  echo "Error: keyword must match [a-z0-9_-]+ (got: $KEYWORD)" >&2
  exit 1
fi

NOW=$(date +%s)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BRANCH_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
DIR="${BRANCH_ROOT}/transcripts"
mkdir -p "$DIR"

# Refuse to start if another running transcript exists
shopt -s nullglob
EXISTING=("${DIR}"/*-running.md)
shopt -u nullglob
if [ ${#EXISTING[@]} -gt 0 ]; then
  echo "Error: a running transcript already exists: ${EXISTING[0]}" >&2
  echo "Close it first with transcript-close.sh, or continue that session." >&2
  exit 1
fi

FILE="${DIR}/${NOW}-${NOW}-${KEYWORD}-running.md"
touch "$FILE"
echo "$NOW"
