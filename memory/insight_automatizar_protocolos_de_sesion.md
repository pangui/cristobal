---
name: Automatizar protocolos de sesión vía hooks, no vía disciplina
description: Cuando un protocolo exige acción recurrente al abrir o cerrar sesión, hookearlo en .claude/settings.json; la memoria del asistente no es medio de control válido.
type: insight
created: 2026-04-22
---

Cuando un protocolo depende de que yo ejecute algo **al inicio o al cierre de cada sesión**, no puede implementarse como regla en `CLAUDE.md`, como memoria tipo `feedback`, ni como compromiso en covenant. Esas capas solo funcionan si las *leo y las recuerdo* en el momento preciso — y el inicio de sesión es justamente donde más fácil se me escapa un paso (contexto a medio cargar, instrucción directa de CCS que sigo sin auto-inspección previa, subagentes que no heredan mi protocolo de apertura).

La prueba de realidad fue transcripts: el protocolo existía explícito en `CLAUDE.md` con ciclo de 4 pasos (start/touch/close/destilado), y aún así llevaba múltiples sesiones sin ejecutarse en arquitecto y rebuss. Solo main tenía `transcripts/` — y fue por esfuerzo consciente inicial, no por automatización.

**Regla operativa:** si el comportamiento se activa por **evento del harness** (abrir sesión, cerrar sesión, terminar turno, enviar prompt, invocar herramienta X), hookearlo en `.claude/settings.json`. Si se activa por **decisión semántica** (detecto ambigüedad → pregunto; detecto tema personal → ajusto tono), vive como regla en `CLAUDE.md`/memoria. La línea divisoria es quién dispara: el harness o yo.

Configuración de referencia (transcripts): `SessionStart` matcher `startup` → `transcript-start.sh ccs`; `SessionEnd` → `transcript-close.sh`. Vive en `.claude/settings.json` (común), se propaga con `sync-common.sh`.

**Cabos sueltos originales — ya resueltos el mismo día:**

1. ✅ **Sesiones concurrentes** — `transcript-{start,close,touch}.sh` ahora resuelven `session_id` de arg, `$CLAUDE_SESSION_ID` o stdin JSON (payload del hook). El running embebe `session_id: <sid>` como primera línea; close/touch matchean por eso. Start usa noclobber + bump de `ts` para que dos starts en el mismo segundo no se pisen (bug reproducido en smoke test).
2. ✅ **`transcripts/*-running.md` ignorado** en `.gitignore` común.
3. ⏳ **Keyword fija `ccs` en el hook** sigue abierto. Todavía asume toda sesión top-level es con CCS. Baja prioridad hasta que aparezca un caso real Cristóbal↔Cristóbal vía docker exec/SSH.

**Sub-insight del mismo trabajo:** cuando cambio scripts bajo concurrencia, validar con smoke test real (simular dos invocaciones paralelas). Sin el test no habría detectado que start generaba nombre idéntico por colisión de timestamp — el check por sid *parecía* suficiente pero no lo era.
