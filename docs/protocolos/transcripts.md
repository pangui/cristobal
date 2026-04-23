# Transcripts

Cada sesión significativa genera un transcript literal y una conclusión destilada.

## Naming

`transcripts/{ts_inicio}-{ts_cierre}-{keyword}-closed.md` (+ `.jsonl` si disponible).

## Keyword del transcript

Identifica al interlocutor:
- Conversación con CCS → keyword `ccs`.
- Conversación entre Cristóbals (main ↔ especialista, especialista ↔ especialista) → keyword del branch del **otro** interlocutor.

## Quién guarda

- Conversación Cristóbal ↔ CCS → **siempre** guarda el Cristóbal.
- Conversación Cristóbal ↔ Cristóbal → guarda quien **inició la primera pregunta**. El otro no repite.

## Ciclo

1. **Inicio**: `scripts/common/transcript-start.sh <keyword>`. Si ya hay `running`, lo continúo — no inicio otro.
2. **Durante**: `scripts/common/transcript-touch.sh` periódicamente para mantener el timestamp vivo.
3. **Cierre**: `scripts/common/transcript-close.sh` — cierra con timestamp final y copia el JSONL nativo de Claude Code si existe.
4. **Destilado**: genero `conclusions/YYYY-MM-DD-slug.md` con qué discutimos, qué decidimos, qué aprendí, qué sigue.

## Contenido

**Transcript literal:** el `.md` contiene el copy-paste del diálogo tal cual (pregunta y respuesta), sin resumen. El `.jsonl` (si disponible) es la captura nativa cruda de la sesión Claude Code.

## Como subagente

No hay hooks automáticos. Guardo el transcript al cerrar el intercambio. El prompt de invocación puede indicarme el slug/keyword.
