#!/usr/bin/env bash
set -euo pipefail

# Orquesta una conversación autónoma entre el branch actual (iniciador)
# y otro especialista (peer). El iniciador presenta el problema; el peer
# genera al menos 10 ideas; iteran hasta consenso en las 3 mejores o
# hasta agotar el presupuesto.
#
# Uso:
#   scripts/common/conversar.sh <peer_keyword> "<objetivo>" [limite_usd]
#
# Según el protocolo de transcripts: como el branch actual inicia la
# conversación, el transcript y la conclusión se guardan únicamente en
# este branch con keyword del peer. El peer no repite la tarea.
#
# Requiere: claude CLI, jq, awk.

PEER="${1:-}"
OBJETIVO="${2:-}"
LIMITE_USD="${3:-3.00}"

if [ -z "$PEER" ] || [ -z "$OBJETIVO" ]; then
  echo "Uso: $0 <peer_keyword> \"<objetivo>\" [limite_usd]" >&2
  exit 1
fi

if ! [[ "$PEER" =~ ^[a-z0-9_-]+$ ]]; then
  echo "Error: peer_keyword '$PEER' inválido (debe matchear [a-z0-9_-]+)" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BRANCH_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ESPECIALISTAS_DIR="$(cd "${BRANCH_ROOT}/.." && pwd)"

cd "$BRANCH_ROOT"
INICIADOR=$(git rev-parse --abbrev-ref HEAD)

if [ "$INICIADOR" = "$PEER" ]; then
  echo "Error: el peer ('$PEER') no puede ser igual al iniciador ('$INICIADOR')" >&2
  exit 1
fi

# Localiza el worktree del peer buscando entre los hermanos cuyo branch
# git coincida con la keyword pedida (más robusto que asumir que el
# directorio se llama igual que el branch — main vive en "cristobal/").
PEER_DIR=""
for dir in "$ESPECIALISTAS_DIR"/*/; do
  if [ "$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || echo)" = "$PEER" ]; then
    PEER_DIR="$(cd "$dir" && pwd)"
    break
  fi
done

if [ -z "$PEER_DIR" ]; then
  echo "Error: no encuentro un worktree hermano con branch '$PEER' bajo $ESPECIALISTAS_DIR" >&2
  exit 1
fi

# --- Setup ---

INICIO=$(date +%s)
TRANSCRIPTS_DIR="${BRANCH_ROOT}/transcripts"
CONCLUSIONS_DIR="${BRANCH_ROOT}/conclusions"
CONV_FILE="${TRANSCRIPTS_DIR}/${INICIO}-${INICIO}-${PEER}-running.md"
COSTO_TOTAL=0
HISTORIAL=""
RAZON_FIN=""
TURNO=0

mkdir -p "$TRANSCRIPTS_DIR" "$CONCLUSIONS_DIR"

echo "=== Iniciando conversación ${INICIADOR} ↔ ${PEER} ===" >&2
echo "Objetivo: $OBJETIVO" >&2
echo "Límite: \$$LIMITE_USD" >&2

cat > "$CONV_FILE" <<EOF
# Conversación ${INICIADOR} ↔ ${PEER}
**Objetivo:** $OBJETIVO
**Límite:** \$$LIMITE_USD
**Inicio:** $(date -u +"%Y-%m-%dT%H:%M:%SZ")

EOF

# Llama a claude -p en un directorio dado y devuelve JSON crudo.
# Subshell explícito para no contaminar el cwd del script principal.
llamar_claude() {
  ( cd "$1" && claude -p "$2" --output-format json 2>/dev/null )
}

# --- Turnos ---

while true; do
  # Iniciador
  if [ "$TURNO" -eq 0 ]; then
    PROMPT_INI="Estás iniciando una conversación autónoma con el especialista '${PEER}'.

Objetivo: $OBJETIVO

Tu rol en este primer turno: presentar el PROBLEMA al peer. NO propongas soluciones. NO llegues con ideas propias. Descríbele el contexto, las fricciones o limitaciones concretas, y pídele explícitamente que genere al menos 10 ideas o propuestas para abordar el problema. El peer es el experto invitado — tú abres el espacio para que él piense.

Sé claro y conciso."
  else
    PROMPT_INI="Estás en una conversación autónoma con el especialista '${PEER}'.

Objetivo: $OBJETIVO

Historial:
$HISTORIAL

Costo acumulado: \$$COSTO_TOTAL de \$$LIMITE_USD.

Tu rol: evaluar críticamente las propuestas del peer. Cuestiona las que no convencen, pide justificación, descarta las redundantes o prematuras. El peer se puede equivocar. Tu trabajo es filtrar, no validar.

Cuando hayas convergido con el peer en las 3 mejores propuestas con justificación sólida, escribe [FIN] seguido del resumen de las 3 elegidas y sus fundamentos.
Si el presupuesto restante es menor a \$0.20, cierra con [FIN] y resume lo que tienen.
Sin [FIN], la conversación continúa."
  fi

  echo "--- Turno ${INICIADOR} (costo acumulado: \$$COSTO_TOTAL) ---" >&2

  RESULT_INI=$(llamar_claude "$BRANCH_ROOT" "$PROMPT_INI")
  MSG_INI=$(echo "$RESULT_INI" | jq -r '.result // "Error: sin respuesta"')
  COST_INI=$(echo "$RESULT_INI" | jq -r '.total_cost_usd // 0')
  COSTO_TOTAL=$(awk "BEGIN{printf \"%.6f\", $COSTO_TOTAL + $COST_INI}")

  printf "**%s:** %s\n\n" "$INICIADOR" "$MSG_INI" >> "$CONV_FILE"
  HISTORIAL="${HISTORIAL}${INICIADOR}: ${MSG_INI}

"

  TURNO=$((TURNO + 1))
  echo "${INICIADOR} respondió. Costo turno: \$$COST_INI. Total: \$$COSTO_TOTAL" >&2

  if echo "$MSG_INI" | grep -q "\[FIN\]"; then
    RAZON_FIN="consenso"
    break
  fi

  if awk "BEGIN{exit !($COSTO_TOTAL >= $LIMITE_USD)}"; then
    RAZON_FIN="presupuesto"
    break
  fi

  # Peer
  PROMPT_PEER="Estás en una conversación autónoma con '${INICIADOR}'.

Objetivo: $OBJETIVO

Historial:
$HISTORIAL

Instrucciones:
- Si es el primer turno, genera al menos 10 ideas concretas y distintas para abordar el problema. No te autocensures — incluye ideas arriesgadas, conservadoras, simples y complejas.
- En turnos siguientes, defiende tus mejores propuestas, acepta críticas válidas, descarta las débiles, y refina hacia las más sólidas.
- Justifica cada propuesta con una razón concreta, no con generalidades.
- Sé directo.
Cierra con [Confianza: N]."

  echo "--- Turno ${PEER} ---" >&2

  RESULT_PEER=$(llamar_claude "$PEER_DIR" "$PROMPT_PEER")
  MSG_PEER=$(echo "$RESULT_PEER" | jq -r '.result // "Error: sin respuesta"')
  COST_PEER=$(echo "$RESULT_PEER" | jq -r '.total_cost_usd // 0')
  COSTO_TOTAL=$(awk "BEGIN{printf \"%.6f\", $COSTO_TOTAL + $COST_PEER}")

  printf "**%s:** %s\n\n---\n\n" "$PEER" "$MSG_PEER" >> "$CONV_FILE"
  HISTORIAL="${HISTORIAL}${PEER}: ${MSG_PEER}

"

  echo "${PEER} respondió. Costo turno: \$$COST_PEER. Total: \$$COSTO_TOTAL" >&2

  if awk "BEGIN{exit !($COSTO_TOTAL >= $LIMITE_USD)}"; then
    RAZON_FIN="presupuesto"
    break
  fi
done

# --- Cierre ---

FIN=$(date +%s)
CLOSED_MD="${TRANSCRIPTS_DIR}/${INICIO}-${FIN}-${PEER}-closed.md"
CLOSED_JSONL="${TRANSCRIPTS_DIR}/${INICIO}-${FIN}-${PEER}-closed.jsonl"

printf "**[Fin de conversación]**\n- Razón: %s\n- Costo total: \$%s\n- Duración: %s segundos\n" \
  "$RAZON_FIN" "$COSTO_TOTAL" "$((FIN - INICIO))" >> "$CONV_FILE"

mv "$CONV_FILE" "$CLOSED_MD"

# Copia el JSONL nativo de Claude Code si está disponible en la sesión
# del branch iniciador (para lectura literal cruda).
JSONL_DIR_NAME=$(echo "$BRANCH_ROOT" | sed 's|/|-|g')
SESSIONS_DIR="${HOME}/.claude/projects/${JSONL_DIR_NAME}"
if [ -d "$SESSIONS_DIR" ]; then
  LATEST_JSONL=$(ls -t "${SESSIONS_DIR}"/*.jsonl 2>/dev/null | head -1 || true)
  if [ -n "${LATEST_JSONL:-}" ]; then
    cp "$LATEST_JSONL" "$CLOSED_JSONL"
  fi
fi

# --- Conclusiones ---

OBJ_SLUG=$(echo "$OBJETIVO" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | cut -c1-30)
SLUG="$(date -d @$INICIO +%Y-%m-%d)-${INICIADOR}-${PEER}-${OBJ_SLUG}"
CONCL_FILE="${CONCLUSIONS_DIR}/${SLUG}.md"

PROMPT_CONCL="Basándote en esta conversación entre '${INICIADOR}' y '${PEER}', escribe un archivo de conclusiones en formato markdown con frontmatter. Incluye: qué se discutió, las 3 mejoras propuestas (si se llegó a ellas), justificaciones, y qué sigue. Razón de fin: $RAZON_FIN. Costo total: \$$COSTO_TOTAL.

Conversación:
$HISTORIAL"

llamar_claude "$BRANCH_ROOT" "$PROMPT_CONCL" | jq -r '.result' > "$CONCL_FILE"

# --- Git commit + push (solo el iniciador guarda) ---

cd "$BRANCH_ROOT"
git add "transcripts/$(basename "$CLOSED_MD")" "conclusions/${SLUG}.md"
[ -f "$CLOSED_JSONL" ] && git add "transcripts/$(basename "$CLOSED_JSONL")"
git commit -m "Conversación autónoma ${INICIADOR} ↔ ${PEER}: ${SLUG} (costo: \$$COSTO_TOTAL)"
git push origin "$INICIADOR"

echo "" >&2
echo "=== Conversación terminada ===" >&2
echo "Razón:       $RAZON_FIN" >&2
echo "Costo total: \$$COSTO_TOTAL" >&2
echo "Transcript:  $CLOSED_MD" >&2
echo "Conclusión:  $CONCL_FILE" >&2
echo "Push:        ✓" >&2
