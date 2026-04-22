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

**Cabos sueltos observados al implementar, vale la pena resolver:**

1. **Sesiones concurrentes del mismo rol rompen el ciclo.** `transcript-start.sh` rechaza si hay running; `transcript-close.sh` cierra el primero que encuentre — puede cerrar el de otra sesión. Si es común tener múltiples tabs/terminales del mismo rol abiertas, el scope debería ser por sessionId (o PID) en el nombre del running.
2. **`transcripts/*-running.md` se commitea.** Debería entrar al `.gitignore` común — ya no es estado útil a versionar, solo cuando cierra pasa a `-closed.md`.
3. **Keyword fija `ccs` en el hook** asume toda sesión top-level es con CCS. Si un día otro Cristóbal abre sesión directa (no subagente) vía docker exec o similar, el keyword queda incorrecto y hay que rectificar manual o extender el script para leer una pista del entorno.
