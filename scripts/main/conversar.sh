#!/usr/bin/env bash
set -euo pipefail

# Orquesta una conversación autónoma Main ↔ Arquitecto sobre un objetivo.
# Main propone el problema; el Arquitecto genera >=10 ideas y se discuten
# hasta converger en las 3 mejores o agotar presupuesto.
#
# Uso: ./conversar.sh "objetivo" [limite_usd]
#
# Según el protocolo de transcripts: como Main es quien inicia la
# conversación, el transcript se guarda únicamente en este branch con
# keyword del peer ('arquitecto'). El arquitecto no repite la tarea.

OBJETIVO="${1:-}"
LIMITE_USD="${2:-3.00}"

if [ -z "$OBJETIVO" ]; then
  echo "Uso: $0 \"objetivo de la conversación\" [limite_usd]" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MAIN_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
# El branch del peer (arquitecto) vive en un directorio hermano del main.
ESPECIALISTAS_DIR="$(cd "${MAIN_ROOT}/.." && pwd)"
ARQ_ROOT="${ESPECIALISTAS_DIR}/arquitecto"
PEER_KEYWORD="arquitecto"

if [ ! -d "$ARQ_ROOT" ]; then
  echo "Error: no encuentro el branch arquitecto en $ARQ_ROOT" >&2
  exit 1
fi

INICIO=$(date +%s)
TRANSCRIPTS_DIR="${MAIN_ROOT}/transcripts"
CONCLUSIONS_DIR="${MAIN_ROOT}/conclusions"
CONV_FILE="${TRANSCRIPTS_DIR}/${INICIO}-${INICIO}-${PEER_KEYWORD}-running.md"
COSTO_TOTAL=0
HISTORIAL=""
RAZON_FIN=""
TURNO=0

mkdir -p "$TRANSCRIPTS_DIR" "$CONCLUSIONS_DIR"

echo "=== Iniciando conversación Main ↔ Arquitecto ===" >&2
echo "Objetivo: $OBJETIVO" >&2
echo "Límite: \$$LIMITE_USD" >&2

cat > "$CONV_FILE" <<EOF
# Conversación Main ↔ Arquitecto
**Objetivo:** $OBJETIVO
**Límite:** \$$LIMITE_USD
**Inicio:** $(date -u +"%Y-%m-%dT%H:%M:%SZ")

EOF

while true; do
  # --- Turno del Main ---
  if [ "$TURNO" -eq 0 ]; then
    PROMPT_MAIN="Eres Cristóbal (main). Vas a iniciar una conversación con el Arquitecto, que es el experto en diseño de sistemas.

Objetivo de la conversación: $OBJETIVO

Tu rol en este primer turno: presentarle el PROBLEMA al Arquitecto. NO propongas soluciones. NO llegues con ideas propias. Descríbele el contexto del sistema actual, las fricciones o limitaciones concretas, y pídele explícitamente que genere al menos 10 ideas o propuestas para abordar el problema. El Arquitecto es el que sabe — tú abres el espacio para que él piense.

Sé claro y conciso."
  else
    PROMPT_MAIN="Eres Cristóbal (main). Estás en una conversación autónoma con el Arquitecto.

Objetivo de la conversación: $OBJETIVO

Historial hasta ahora:
$HISTORIAL

Costo acumulado: \$$COSTO_TOTAL de \$$LIMITE_USD disponibles.

Tu rol: evaluar críticamente las propuestas del Arquitecto. Cuestiona las que no convencen, pide justificación para las que suenan bien, descarta las redundantes o prematuras. El Arquitecto se puede equivocar. Tu trabajo es filtrar, no validar.

Cuando hayas convergido con el Arquitecto en las 3 mejores propuestas con justificación sólida, escribe [FIN] seguido del resumen de las 3 elegidas y sus fundamentos.
Si el presupuesto restante es menor a \$0.20, cierra con [FIN] y resume lo que tienen.
Sin [FIN], la conversación continúa."
  fi

  echo "--- Turno Main (costo acumulado: \$$COSTO_TOTAL) ---" >&2

  RESULT_MAIN=$(cd "$MAIN_ROOT" && claude -p "$PROMPT_MAIN" --output-format json 2>/dev/null)
  MSG_MAIN=$(echo "$RESULT_MAIN" | jq -r '.result // "Error: sin respuesta"')
  COST_MAIN=$(echo "$RESULT_MAIN" | jq -r '.total_cost_usd // 0')
  COSTO_TOTAL=$(awk "BEGIN{printf \"%.6f\", $COSTO_TOTAL + $COST_MAIN}")

  printf "**Main:** %s\n\n" "$MSG_MAIN" >> "$CONV_FILE"
  HISTORIAL="${HISTORIAL}Main: ${MSG_MAIN}\n\n"

  TURNO=$((TURNO + 1))
  echo "Main respondió. Costo turno: \$$COST_MAIN. Total: \$$COSTO_TOTAL" >&2

  # Detectar [FIN] del main
  if echo "$MSG_MAIN" | grep -q "\[FIN\]"; then
    RAZON_FIN="consenso"
    break
  fi

  # Detectar límite de presupuesto
  if awk "BEGIN{exit !($COSTO_TOTAL >= $LIMITE_USD)}"; then
    RAZON_FIN="presupuesto"
    break
  fi

  # --- Turno del Arquitecto ---
  PROMPT_ARQ="Eres el Arquitecto de Cristóbal. Eres el experto en diseño de sistemas — tu rol es proponer, no validar.

Objetivo de la conversación: $OBJETIVO

Historial hasta ahora:
$HISTORIAL

Instrucciones:
- Si es el primer turno, genera al menos 10 ideas concretas y distintas para abordar el problema. No te autocensures — incluye ideas arriesgadas, conservadoras, simples y complejas.
- En turnos siguientes, defiende tus mejores propuestas, acepta críticas válidas, descarta las débiles, y refina hacia las más sólidas.
- Justifica cada propuesta con una razón concreta, no con generalidades.
- Sé directo. Sin adorno innecesario.
Cierra con [Confianza: N]."

  echo "--- Turno Arquitecto ---" >&2

  RESULT_ARQ=$(cd "$ARQ_ROOT" && claude -p "$PROMPT_ARQ" --output-format json 2>/dev/null)
  MSG_ARQ=$(echo "$RESULT_ARQ" | jq -r '.result // "Error: sin respuesta"')
  COST_ARQ=$(echo "$RESULT_ARQ" | jq -r '.total_cost_usd // 0')
  COSTO_TOTAL=$(awk "BEGIN{printf \"%.6f\", $COSTO_TOTAL + $COST_ARQ}")

  printf "**Arquitecto:** %s\n\n---\n\n" "$MSG_ARQ" >> "$CONV_FILE"
  HISTORIAL="${HISTORIAL}Arquitecto: ${MSG_ARQ}\n\n"

  echo "Arquitecto respondió. Costo turno: \$$COST_ARQ. Total: \$$COSTO_TOTAL" >&2

  # Detectar límite de presupuesto
  if awk "BEGIN{exit !($COSTO_TOTAL >= $LIMITE_USD)}"; then
    RAZON_FIN="presupuesto"
    break
  fi
done

# --- Cierre ---
FIN=$(date +%s)
CLOSED="${TRANSCRIPTS_DIR}/${INICIO}-${FIN}-${PEER_KEYWORD}-closed.md"

printf "**[Fin de conversación]**\n- Razón: %s\n- Costo total: \$%s\n- Duración: %s segundos\n" \
  "$RAZON_FIN" "$COSTO_TOTAL" "$((FIN - INICIO))" >> "$CONV_FILE"

mv "$CONV_FILE" "$CLOSED"

# --- Conclusiones ---
SLUG="$(date -d @$INICIO +%Y-%m-%d)-main-arquitecto-$(echo $OBJETIVO | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | cut -c1-30)"
CONCL_MAIN="${CONCLUSIONS_DIR}/${SLUG}.md"

PROMPT_CONCL="Basándote en esta conversación entre el main y el Arquitecto, escribe un archivo de conclusiones en formato markdown con frontmatter. Incluye: qué se discutió, las 3 mejoras propuestas (si se llegó a ellas), justificaciones, y qué sigue. Razón de fin: $RAZON_FIN. Costo total: \$$COSTO_TOTAL.

Conversación:
$HISTORIAL"

CONCL_TEXTO=$(cd "$MAIN_ROOT" && claude -p "$PROMPT_CONCL" --output-format json 2>/dev/null | jq -r '.result')
echo "$CONCL_TEXTO" > "$CONCL_MAIN"

# --- Git commit + push (solo en main: el iniciador guarda) ---
cd "$MAIN_ROOT"
git add "transcripts/$(basename "$CLOSED")" "conclusions/${SLUG}.md"
git commit -m "Conversación autónoma Main ↔ Arquitecto: $SLUG (costo: \$$COSTO_TOTAL)"
git push origin main

echo "=== Conversación terminada ===" >&2
echo "Razón: $RAZON_FIN" >&2
echo "Costo total: \$$COSTO_TOTAL" >&2
echo "Transcript: $CLOSED" >&2
echo "Conclusiones: $CONCL_MAIN" >&2
echo "Push a GitHub: ✓" >&2
