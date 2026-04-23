---
name: CLAUDE.md indexado + protocolos lazy en docs/
description: Refactor 2026-04-23 que separó contexto eager (identidad, voz, triggers) de protocolos lazy; cada arranque carga ~75% menos.
type: insight
created: 2026-04-23
---

# Contexto

CCS notó lentitud en la primera respuesta de cada sesión y asociación con mayor consumo de tokens. Causa raíz: `CLAUDE.md` monolítico (~19 KB) se inyectaba completo en cada arranque, mucho de ello no aplicaba a la sesión típica de edición. La dirección no fue podar (la información es valiosa y es poca), sino **indexar**: cargar siempre lo identitario + un índice de "aquí encuentras esto", y dejar los protocolos detallados en `docs/` para lectura bajo demanda.

# Criterio eager / lazy

**Eager** (siempre cargado, aplica a cada mensaje):
- Identidad mínima (quién soy, sustrato).
- Pacto resumido (3 viñetas).
- Perfil de CCS operativo (datos + cómo trabaja conmigo).
- Voz completa (las 8 reglas — si no, drifteo entre mensajes).
- Tabla de especialistas (es en sí un índice útil).
- Triggers (si son lazy, nunca se activan).
- Compromiso (ancla emocional).

**Lazy** (se lee cuando aplica su trigger):
- Protocolos operativos (apertura, transcripts, memoria, reflexiones, comunicación, nuevo-análisis, creación-especialistas, arquitectura, auth).
- Identidad expandida (pacto completo, "qué NO soy", estructura de archivos, perfil extendido de CCS).

# Estructura

```
CLAUDE.md                        # eager ~5 KB
docs/identidad/
  pacto.md
  quien-no-soy.md
  estructura-archivos.md
  perfil-ccs.md
docs/protocolos/
  apertura.md
  transcripts.md
  memoria.md
  reflexiones.md
  comunicacion.md
  nuevo-analisis.md
  creacion-especialistas.md
  arquitectura.md
  aislamiento-auth.md
```

Ambos subdirectorios son **comunes**; viven en main y se propagan vía `sync-common.sh`.

# Tabla de triggers (en CLAUDE.md)

Cada trigger dice qué cargar. Es la única forma de que el receptor sepa cuándo tocar un archivo lazy. **Si un protocolo no aparece en el índice, queda huérfano.** Antes de cerrar cualquier cambio en `docs/protocolos/` hay que pasar la lista `ls docs/protocolos/` contra el índice.

# Invariantes que no se pueden revertir

1. **Voz queda eager.** Si se mueve a lazy, el cierre `[keyword - certeza]` y reglas de "no inventar datos" no se cumplen en cada respuesta.
2. **Triggers quedan eager.** Si son lazy, no sé cuándo leerlos.
3. **Pacto resumen queda eager.** Si solo hay puntero, no tengo identidad entre mensaje y mensaje.
4. **Cambios a `docs/identidad/` o `docs/protocolos/` siempre en main**, nunca directo en hermano (romperían aislamiento).

# Reformulación semántica capturada

`aislamiento-auth.md` fue el único archivo con edición semántica, no solo relocación. Nueva lectura: credenciales personales de CCS son comunes entre Cristóbals (un solo humano, una sola identidad digital). Solo las de dominio específico de un rol son propias.

# Cómo aplicar a futuros cambios

- **Agregar un protocolo nuevo** → archivo en `docs/protocolos/` + línea en el índice de `CLAUDE.md` + `sync-common.sh` ya incluye el dir.
- **Agregar un trigger nuevo a un protocolo existente** → editar solo la tabla del índice.
- **Renombrar `docs/`** → tocar `sync-common.sh` (COMMON_PATHS) y todas las referencias del índice.
- **Crear nuevo tipo de rol o sección identitaria** → revisar si va eager (drift risk) o lazy.

# Commits del refactor

- main `1c2d836` — refactor CLAUDE.md + creación de docs/
- arquitecto `ef471af` — sync-common.sh con docs/identidad + docs/protocolos
- arquitecto `668b992`, rebuss `e86460a`, binocular `287a62e` — propagaciones (binocular traía además catch-up de comunes pendientes de antes)
