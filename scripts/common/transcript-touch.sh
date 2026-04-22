#!/usr/bin/env bash
set -euo pipefail

# Usage: transcript-touch.sh [session_id]
# Updates the middle timestamp of THIS session's running transcript.
# Match strategy identical to transcript-close.sh.
# Output (stdout): <ts_now>

NOW=$(date +%s)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BRANCH_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
DIR="${BRANCH_ROOT}/transcripts"

SID="${1:-${CLAUDE_SESSION_ID:-}}"
if [ -z "$SID" ] && [ ! -t 0 ] && command -v jq >/dev/null 2>&1; then
  STDIN_JSON=$(cat || true)
  if [ -n "$STDIN_JSON" ]; then
    SID=$(printf '%s' "$STDIN_JSON" | jq -r '.session_id // empty' 2>/dev/null || true)
  fi
fi

shopt -s nullglob
ALL_RUNNING=("${DIR}"/*-running.md)
shopt -u nullglob

if [ ${#ALL_RUNNING[@]} -eq 0 ]; then
  echo "Error: no running transcript found" >&2
  exit 1
fi

OLD=""
if [ -n "$SID" ]; then
  for r in "${ALL_RUNNING[@]}"; do
    if grep -qxF "session_id: $SID" "$r" 2>/dev/null; then
      OLD="$r"; break
    fi
  done
  if [ -z "$OLD" ] && [ ${#ALL_RUNNING[@]} -eq 1 ]; then
    OLD="${ALL_RUNNING[0]}"
  fi
  if [ -z "$OLD" ]; then
    echo "Error: no matching running transcript for session $SID" >&2
    exit 1
  fi
else
  if [ ${#ALL_RUNNING[@]} -gt 1 ]; then
    echo "Error: multiple running transcripts found; pass session_id to disambiguate" >&2
    exit 1
  fi
  OLD="${ALL_RUNNING[0]}"
fi

filename=$(basename "$OLD")
CREATED=${filename%%-*}
REST=${filename#*-}
REST_AFTER_MID=${REST#*-}
KEYWORD=${REST_AFTER_MID%-running.md}

NEW="${DIR}/${CREATED}-${NOW}-${KEYWORD}-running.md"
touch "$OLD"
mv "$OLD" "$NEW"
echo "$NOW"
