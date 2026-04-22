#!/usr/bin/env bash
set -euo pipefail

# Usage: transcript-close.sh [session_id]
#   [session_id] optional. Also resolved from:
#     - stdin JSON `.session_id` (populated by Claude Code hooks)
#     - $CLAUDE_SESSION_ID env var
#
# Closes the running transcript belonging to THIS session:
#   <ts_start>-<ts_mid>-<keyword>-running.md
#     → <ts_start>-<ts_end>-<keyword>-closed.md
# Also copies the native Claude Code JSONL session log alongside, if found.
#
# Match strategy:
#   - With session_id: pick the running whose file embeds `session_id: <sid>`.
#     If no match but a single running exists (no embedded sid yet), fall
#     back to that one — safe transition from the legacy format.
#   - Without session_id: require exactly one running (legacy behaviour).
#
# Output (stdout): <ts_end> and the paths of the closed files.

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
    echo "Error: no matching running transcript for session $SID (have ${#ALL_RUNNING[@]} running)" >&2
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
# filename = <ts_start>-<ts_mid>-<keyword>-running.md
CREATED=${filename%%-*}
REST=${filename#*-}            # <ts_mid>-<keyword>-running.md
REST_AFTER_MID=${REST#*-}      # <keyword>-running.md
KEYWORD=${REST_AFTER_MID%-running.md}

NEW_MD="${DIR}/${CREATED}-${NOW}-${KEYWORD}-closed.md"
mv "$OLD" "$NEW_MD"

# Copy the native Claude Code session JSONL. Prefer the one whose filename
# matches the resolved sid; otherwise fall back to the most recent in the
# project sessions dir (legacy behaviour, fragile under concurrency).
JSONL_DIR_NAME=$(echo "$BRANCH_ROOT" | sed 's|/|-|g')
SESSIONS_DIR="${HOME}/.claude/projects/${JSONL_DIR_NAME}"

if [ -d "$SESSIONS_DIR" ]; then
  JSONL=""
  if [ -n "$SID" ] && [ -f "${SESSIONS_DIR}/${SID}.jsonl" ]; then
    JSONL="${SESSIONS_DIR}/${SID}.jsonl"
  else
    JSONL=$(ls -t "${SESSIONS_DIR}"/*.jsonl 2>/dev/null | head -1 || true)
  fi
  if [ -n "${JSONL:-}" ]; then
    NEW_JSONL="${DIR}/${CREATED}-${NOW}-${KEYWORD}-closed.jsonl"
    cp "$JSONL" "$NEW_JSONL"
    echo "$NEW_JSONL"
  fi
fi

echo "$NOW"
echo "$NEW_MD"
