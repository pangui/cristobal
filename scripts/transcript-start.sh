#!/usr/bin/env bash
set -euo pipefail

NOW=$(date +%s)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DIR="${SCRIPT_DIR}/../transcripts"
mkdir -p "$DIR"
FILE="${DIR}/${NOW}-${NOW}-running.md"
touch "$FILE"
echo "$NOW"
