#!/usr/bin/env bash
set -euo pipefail

# Usage: transcript-start.sh <keyword> [session_id]
#   <keyword> identifies the other party:
#     - "ccs" for a conversation with Cristóbal Campos
#     - "<rol>" for a conversation with another Cristóbal (e.g., "main", "rebuss")
#   [session_id] optional. Also resolved from:
#     - stdin JSON `.session_id` (populated by Claude Code hooks)
#     - $CLAUDE_SESSION_ID env var
#
# Creates: <branch-root>/transcripts/<ts_start>-<ts_start>-<keyword>-running.md
# When a session_id is available, it is embedded as the first line of the
# running file (`session_id: <sid>`). This lets transcript-close.sh /
# transcript-touch.sh disambiguate between concurrent parallel sessions
# of the same specialist.
#
# Output (stdout): <ts_start>

if [ $# -lt 1 ] || [ -z "${1:-}" ]; then
  echo "Error: keyword required (usage: transcript-start.sh <keyword> [session_id])" >&2
  exit 1
fi

KEYWORD="$1"
if ! [[ "$KEYWORD" =~ ^[a-z0-9_-]+$ ]]; then
  echo "Error: keyword must match [a-z0-9_-]+ (got: $KEYWORD)" >&2
  exit 1
fi

SID="${2:-${CLAUDE_SESSION_ID:-}}"
if [ -z "$SID" ] && [ ! -t 0 ] && command -v jq >/dev/null 2>&1; then
  STDIN_JSON=$(cat || true)
  if [ -n "$STDIN_JSON" ]; then
    SID=$(printf '%s' "$STDIN_JSON" | jq -r '.session_id // empty' 2>/dev/null || true)
  fi
fi

NOW=$(date +%s)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BRANCH_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
DIR="${BRANCH_ROOT}/transcripts"
mkdir -p "$DIR"

if [ -n "$SID" ]; then
  # Reject only if a running with the SAME sid already exists.
  shopt -s nullglob
  for existing in "${DIR}"/*-running.md; do
    if grep -qxF "session_id: $SID" "$existing" 2>/dev/null; then
      echo "Error: running transcript already exists for session $SID: $existing" >&2
      exit 1
    fi
  done
  shopt -u nullglob
else
  # No sid: legacy behaviour — any running blocks new start.
  shopt -s nullglob
  EXISTING=("${DIR}"/*-running.md)
  shopt -u nullglob
  if [ ${#EXISTING[@]} -gt 0 ]; then
    echo "Error: a running transcript already exists: ${EXISTING[0]}" >&2
    echo "Close it first with transcript-close.sh, or continue that session." >&2
    exit 1
  fi
fi

FILE="${DIR}/${NOW}-${NOW}-${KEYWORD}-running.md"
# Atomic create; if two starts land in the same second, bump NOW until the
# name is unique. Prevents one session from clobbering another's running file.
while ! (set -o noclobber; : > "$FILE") 2>/dev/null; do
  NOW=$((NOW+1))
  FILE="${DIR}/${NOW}-${NOW}-${KEYWORD}-running.md"
done

if [ -n "$SID" ]; then
  printf 'session_id: %s\n' "$SID" > "$FILE"
fi
echo "$NOW"
