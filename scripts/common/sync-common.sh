#!/usr/bin/env bash
set -euo pipefail

# Propaga el contenido común desde el branch main hacia el branch actual.
# NO usa git merge main (merge traería archivos propios de main que no
# corresponden a este rol). En su lugar, hace checkout selectivo de los
# paths declarados comunes.
#
# Paths comunes (actualizar esta lista si aparece otro archivo común):
COMMON_PATHS=(
  "CLAUDE.md"
  "scripts/common/"
  ".gitattributes"
)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BRANCH_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
cd "$BRANCH_ROOT"

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" = "main" ]; then
  echo "Error: estás en main. Este script se corre desde un branch de rol para traer lo común de main." >&2
  exit 1
fi

echo "Sincronizando contenido común desde main → ${CURRENT_BRANCH}..."
for path in "${COMMON_PATHS[@]}"; do
  echo "  checkout main -- $path"
  git checkout main -- "$path"
done

echo ""
echo "Listo. Revisa los cambios con: git status && git diff --cached"
echo "Si todo OK, commitea: git commit -m 'Sincroniza común desde main'"
