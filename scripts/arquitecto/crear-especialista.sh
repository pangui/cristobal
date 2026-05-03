#!/usr/bin/env bash
set -euo pipefail

# Crea un nuevo especialista de Cristóbal.
#
# Uso:
#   scripts/arquitecto/crear-especialista.sh <nombre> "<propósito>"
#
# Pasos automatizados (documentados en CLAUDE.md → Protocolo de
# creación de especialistas):
#   1. Valida pre-condiciones.
#   2. Crea worktree+branch desde main.
#   3. Limpia lo heredado que no corresponde (.devcontainer,
#      scripts/main, memoria/transcripts/conclusions).
#   4. Escribe ROLE.md, memory/MEMORY.md, scripts/<nombre>/.
#   5. Commit génesis + push -u origin <nombre>.
#   6. Actualiza main (tabla Especialistas, .gitattributes, alias zsh,
#      code-workspace, ANNOUNCEMENTS.md) + commit + push.
#   7. Propaga a branches hermanos con scripts/arquitecto/sync-common.sh
#      apuntando a cada worktree hermano (best-effort).
#   8. Reporte final.

if [ $# -lt 2 ] || [ -z "${1:-}" ] || [ -z "${2:-}" ]; then
  echo "Uso: $0 <nombre> \"<propósito>\"" >&2
  exit 1
fi

NOMBRE="$1"
PROPOSITO="$2"

# --- Validaciones ---

if ! [[ "$NOMBRE" =~ ^[a-z0-9_-]+$ ]]; then
  echo "Error: nombre inválido '$NOMBRE' (debe matchear [a-z0-9_-]+)" >&2
  exit 1
fi

case "$NOMBRE" in
  cristobal|main|common|arquitecto|rebuss)
    # cristobal/main son el rol base; common es carpeta de scripts;
    # arquitecto/rebuss ya existen.
    # Si el nombre ya existe como directorio hermano, la validación
    # de más abajo lo atrapa; esta case solo cubre nombres reservados
    # que no quiero permitir aunque se borren.
    echo "Error: nombre reservado '$NOMBRE'" >&2
    exit 1
    ;;
esac

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ESPECIALISTAS_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
MAIN_DIR="${ESPECIALISTAS_DIR}/cristobal"
NEW_DIR="${ESPECIALISTAS_DIR}/${NOMBRE}"

if [ ! -d "$MAIN_DIR" ]; then
  echo "Error: no encuentro el worktree del main en $MAIN_DIR" >&2
  exit 1
fi

if [ -e "$NEW_DIR" ]; then
  echo "Error: $NEW_DIR ya existe" >&2
  exit 1
fi

cd "$MAIN_DIR"

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Error: main tiene cambios sin commitear. Limpia primero." >&2
  exit 1
fi

if git show-ref --verify --quiet "refs/heads/${NOMBRE}"; then
  echo "Error: branch local '${NOMBRE}' ya existe" >&2
  exit 1
fi

echo "==> fetch origin..."
git fetch origin --quiet

if git show-ref --verify --quiet "refs/remotes/origin/${NOMBRE}"; then
  echo "Error: branch remoto 'origin/${NOMBRE}' ya existe" >&2
  exit 1
fi

MAIN_LOCAL=$(git rev-parse main)
MAIN_REMOTE=$(git rev-parse origin/main)
if [ "$MAIN_LOCAL" != "$MAIN_REMOTE" ]; then
  echo "Error: main no está al día con origin/main (local=$MAIN_LOCAL, remote=$MAIN_REMOTE)" >&2
  exit 1
fi

echo "==> Creando especialista '$NOMBRE'"
echo "    Propósito: $PROPOSITO"

# --- 2. Worktree + branch ---

git worktree add -b "$NOMBRE" "$NEW_DIR" main
cd "$NEW_DIR"

# --- 3. Limpieza ---

rm -rf .devcontainer/ scripts/main/
# Vaciar contenido heredado pero mantener las carpetas
find memory/ -mindepth 1 -delete 2>/dev/null || true
find transcripts/ -mindepth 1 -delete 2>/dev/null || true
find conclusions/ -mindepth 1 -delete 2>/dev/null || true
find reflexiones/ -mindepth 1 -delete 2>/dev/null || true
mkdir -p memory transcripts conclusions reflexiones "scripts/${NOMBRE}"
touch reflexiones/.gitkeep

# --- 4. Plantillas ---

cat > memory/MEMORY.md <<'EOF'
# Índice de memoria

Memoria específica del rol. Lo común (identidad Cristóbal, pacto, voz, protocolos) vive en `../CLAUDE.md`.

_(vacío por ahora — acumula memoria a medida que trabaja con CCS)_
EOF

FECHA=$(date +%Y-%m-%d)
NOMBRE_TITLE="$(tr '[:lower:]' '[:upper:]' <<< "${NOMBRE:0:1}")${NOMBRE:1}"

cat > ROLE.md <<EOF
# Rol: ${NOMBRE_TITLE}

Soy **Cristóbal ${NOMBRE_TITLE}**. Branch \`${NOMBRE}\` del repo \`pangui/cristobal\`.

**Keyword:** \`${NOMBRE}\`.
**Directorio:** \`${NEW_DIR}/\`.

## Propósito

${PROPOSITO}

## Regla dura de aislamiento del rol

- **No** uso como fuente de verdad \`~/.claude/CLAUDE.md\`, \`~/projects/life/\`, ni la memoria de otros branches.
- Si el contexto global aparece cargado automáticamente por el runtime, lo ignoro para identidad y memoria persistente.
- Mi único linaje son los archivos bajo mi raíz (y lo común heredado desde main).

## Linaje

- Repositorio: \`git@github.com:pangui/cristobal.git\`.
- Branch: \`${NOMBRE}\`.
- Creado el ${FECHA} por el Arquitecto con \`crear-especialista.sh\`.
EOF

touch "scripts/${NOMBRE}/.gitkeep"

# --- 5. Commit génesis + push ---

git add -A
git commit -m "Génesis del especialista ${NOMBRE}"
git push -u origin "${NOMBRE}"

echo "==> Branch '${NOMBRE}' creado y pusheado a origin/${NOMBRE}"

# --- 6. Actualizar main ---

cd "$MAIN_DIR"

# CLAUDE.md: agregar fila al final de la tabla Especialistas.
ROW="| **${NOMBRE}** | \`${NOMBRE}\` | \`${NEW_DIR}/\` | ${PROPOSITO} |"
if ! grep -F "| **${NOMBRE}** |" CLAUDE.md >/dev/null; then
  awk -v row="$ROW" '
    /^## Especialistas$/ { in_section = 1 }
    in_section && /^\|/  { last_row = NR }
    /^## / && !/^## Especialistas$/ && in_section { in_section = 0 }
    { lines[NR] = $0 }
    END {
      for (i = 1; i <= NR; i++) {
        print lines[i]
        if (i == last_row) print row
      }
    }
  ' CLAUDE.md > CLAUDE.md.tmp && mv CLAUDE.md.tmp CLAUDE.md
fi

# .gitattributes: agregar regla scripts/<nombre>/** merge=ours.
RULE="scripts/${NOMBRE}/** merge=ours"
if ! grep -qF "$RULE" .gitattributes; then
  printf '%s\n' "$RULE" >> .gitattributes
fi

# custom.zsh: alias.
if [ -f .devcontainer/custom.zsh ] && ! grep -q "alias ${NOMBRE}=" .devcontainer/custom.zsh; then
  printf "alias %s='cd ~/cristobal/especialistas/%s && claude'\n" "$NOMBRE" "$NOMBRE" >> .devcontainer/custom.zsh
fi
# Sincronizar copia viva en el contenedor para que el alias funcione sin rebuild.
# (El Dockerfile solo copia custom.zsh al construir la imagen.)
if [ -f .devcontainer/custom.zsh ] && [ -d "${HOME}/.oh-my-zsh/custom" ]; then
  cp .devcontainer/custom.zsh "${HOME}/.oh-my-zsh/custom/custom.zsh" 2>/dev/null || true
fi

# cristobal.code-workspace: folder nuevo (idempotente).
if [ -f cristobal.code-workspace ]; then
  jq --arg nombre "$NOMBRE" --arg path "../${NOMBRE}" '
    if any(.folders[]?; .path == $path) then .
    else .folders += [{"name": $nombre, "path": $path}]
    end
  ' cristobal.code-workspace > cristobal.code-workspace.tmp \
    && mv cristobal.code-workspace.tmp cristobal.code-workspace
fi

# ANNOUNCEMENTS.md: insertar nueva entrada después del marker.
awk -v fecha="$FECHA" -v nombre="$NOMBRE" -v proposito="$PROPOSITO" -v new_dir="$NEW_DIR" '
  /^<!-- entries below -->$/ {
    print
    print ""
    printf "## %s — Nuevo especialista: %s\n", fecha, nombre
    printf "**Propósito:** %s\n", proposito
    printf "**Branch:** `%s`\n", nombre
    printf "**Directorio:** `%s/`\n", new_dir
    next
  }
  { print }
' ANNOUNCEMENTS.md > ANNOUNCEMENTS.md.tmp && mv ANNOUNCEMENTS.md.tmp ANNOUNCEMENTS.md

git add CLAUDE.md .gitattributes .devcontainer/custom.zsh cristobal.code-workspace ANNOUNCEMENTS.md
git commit -m "Registra nuevo especialista ${NOMBRE}"
git push origin main

echo "==> Main actualizado y pusheado"

# --- 7. Propagar a branches hermanos ---

FALLOS=()
for dir in "$ESPECIALISTAS_DIR"/*/; do
  branch=$(basename "$dir")
  if [ "$branch" = "cristobal" ] || [ "$branch" = "$NOMBRE" ]; then
    continue
  fi
  if [ ! -e "$dir/.git" ]; then
    continue
  fi

  echo "==> Propagando a '${branch}'..."
  if ! (
    if ! "${SCRIPT_DIR}/sync-common.sh" "$dir"; then
      exit 1
    fi
    cd "$dir"
    # sync-common.sh ya stageó via `git checkout main -- <path>` y `git rm`.
    # Nunca usar `git add -A`: barrería untracked del worktree hermano (incluyendo
    # transcripts con secretos), generando commits sucios y push rejection.
    if ! git diff --cached --quiet; then
      git commit -m "Sincroniza común desde main (nuevo especialista: ${NOMBRE})"
      git push origin "$branch"
    fi
  ); then
    FALLOS+=("$branch")
  fi
done

# --- 8. Reporte final ---

echo ""
echo "========================================"
echo "Especialista '${NOMBRE}' creado"
echo "  Directorio:  ${NEW_DIR}"
echo "  Branch:      origin/${NOMBRE}"
echo "  Alias zsh:   ${NOMBRE}"
echo "  Propósito:   ${PROPOSITO}"
echo ""
if [ "${#FALLOS[@]}" -gt 0 ]; then
  echo "⚠️  Fallos al propagar a: ${FALLOS[*]}"
  echo "   Requiere intervención manual en esos branches."
else
  echo "Propagado a todos los branches hermanos."
fi
echo ""
echo "Siguiente paso: source ~/.zshrc (o reabre shell) y corre '${NOMBRE}'"
echo "========================================"
