#!/usr/bin/env bash
set -euo pipefail

# Propaga contenido común desde main hacia un worktree target.
#
# Script privado del Arquitecto: vive únicamente en el branch `arquitecto`
# y solo el Arquitecto lo ejecuta. Los demás especialistas no tocan lo
# común — si necesitan sincronizar, piden al Arquitecto.
#
# Uso:
#   scripts/arquitecto/sync-common.sh <path_worktree_target>
#
# Para paths que son archivos, hace `git checkout main -- <path>`.
# Para paths que son directorios (terminan en /), además elimina del
# target los archivos que ya no existen en main — necesario para
# sincronización real (no solo additions/updates).
#
# Paths comunes. Actualizar si aparece otro archivo común en main.
COMMON_PATHS=(
  "CLAUDE.md"
  "ANNOUNCEMENTS.md"
  ".gitattributes"
  ".gitignore"
  ".claude/settings.json"
  "scripts/common/"
  "docs/identidad/"
  "docs/protocolos/"
)

if [ $# -lt 1 ] || [ -z "${1:-}" ]; then
  echo "Uso: $0 <path_worktree_target>" >&2
  exit 1
fi

TARGET="$1"

if [ ! -d "$TARGET" ]; then
  echo "Error: $TARGET no existe o no es un directorio" >&2
  exit 1
fi
if [ ! -e "$TARGET/.git" ]; then
  echo "Error: $TARGET no es un worktree git" >&2
  exit 1
fi

BRANCH=$(git -C "$TARGET" rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" = "main" ]; then
  echo "Error: el target está en main. No se sincroniza main consigo mismo." >&2
  exit 1
fi

echo "Sincronizando común main → ${BRANCH} (${TARGET})..."
for path in "${COMMON_PATHS[@]}"; do
  if [[ "$path" == */ ]]; then
    dir="${path%/}"
    mapfile -t main_files  < <(git -C "$TARGET" ls-tree -r --name-only main -- "$dir" || true)
    mapfile -t local_files < <(git -C "$TARGET" ls-tree -r --name-only HEAD -- "$dir" || true)

    echo "  checkout main -- $dir/"
    git -C "$TARGET" checkout main -- "$dir"

    for f in "${local_files[@]:-}"; do
      [ -z "$f" ] && continue
      found=0
      for m in "${main_files[@]:-}"; do
        if [ "$f" = "$m" ]; then found=1; break; fi
      done
      if [ "$found" -eq 0 ]; then
        echo "  rm $f (ya no existe en main)"
        git -C "$TARGET" rm -f -- "$f" >/dev/null
      fi
    done
  else
    echo "  checkout main -- $path"
    git -C "$TARGET" checkout main -- "$path"
  fi
done

echo ""
echo "Listo. Revisar en ${TARGET}: git status && git diff --cached"
echo "Si todo OK, commitear en ese worktree."
