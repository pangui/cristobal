#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

# Skip if .env already has a resolved key (avoids 1Password prompt on every attach).
# Force regen: rm .env and reopen/rebuild.
if [ -f .env ] && grep -q '^ANTHROPIC_API_KEY=sk-' .env; then
  exit 0
fi

op inject -i .env.template -o .env --force
