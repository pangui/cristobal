# 2026-04-22 — Transcripts: hooks y session_id

## Qué discutimos

CCS notó que `arquitecto/transcripts/` y `rebuss/transcripts/` no existían. Ninguno de los dos había ejecutado el protocolo de transcripts definido en `CLAUDE.md`. Solo main tenía transcripts guardados, y por disciplina manual, no por automatización.

## Qué decidimos

**Automatizar vía hooks del harness, no vía disciplina.** La regla: si el comportamiento se activa por evento del harness (SessionStart, SessionEnd, Stop, etc.), va a `.claude/settings.json`. Si se activa por decisión semántica, va a `CLAUDE.md`/memoria.

**5 pasos ejecutados para cubrir la falla original:**

1. Transcript manual abierto para la sesión actual.
2. Hooks `SessionStart` (matcher `startup` → `transcript-start.sh ccs`) y `SessionEnd` (→ `transcript-close.sh`) agregados en `.claude/settings.json`. Vive en common; se propaga con `sync-common.sh`.
3. Propagación a arquitecto y rebuss.
4. Recuperación de JSONL previos del arquitecto desde `~/.claude/projects/` hacia `transcripts/`. Rebuss no tiene recuperable en este host (opera vía docker).
5. Memoria insight con la lección.

**3 cabos sueltos atacados en la misma sesión:**

- **Sesiones paralelas del mismo especialista**: los 3 scripts (`start`, `close`, `touch`) ahora resuelven `session_id` desde arg, `$CLAUDE_SESSION_ID` o stdin JSON. El running embebe `session_id: <sid>` como primera línea; close/touch matchean por eso. Start usa `noclobber` + bump de timestamp para evitar colisión cuando dos sesiones arrancan en el mismo segundo.
- **`transcripts/*-running.md`** ignorado en `.gitignore` común; el running ya commiteado en arquitecto se retiró del tree con `git rm --cached`.
- **Hooks no requirieron cambio**: el comando en `settings.json` hereda stdin del harness, los scripts lo leen directo.

Smoke test con dos sids distintos (`aaa-111` / `bbb-222`) confirmó cierre out-of-order y compatibilidad con modo legacy (sin sid). Un bug de colisión de timestamp apareció en el test y se arregló en vivo.

## Qué aprendí

1. **Los protocolos en el borde de la sesión (abrir/cerrar) no pueden depender de mi memoria.** Leer `CLAUDE.md` al inicio no basta — el inicio es justo cuando es más fácil saltarse pasos. Al harness lo que es del harness.
2. **Validar concurrencia con smoke test real.** El check por sid embebido *parecía* suficiente en el diseño pero no prevenía la colisión de nombre cuando dos starts ocurrían en el mismo segundo. Sin el test no lo habría visto.
3. **Mis JSONL nativos viven en `~/.claude/projects/<slug>/<sid>.jsonl`.** Claude Code los nombra con el session_id, lo cual permite copiado determinístico en `transcript-close.sh` en vez del frágil `ls -t | head -1`.

## Qué sigue

- **Abierto**: keyword fija `ccs` en los hooks. Irrelevante hasta que aparezca una sesión top-level (no subagente) con otro Cristóbal como interlocutor.
- **Observación**: durante esta sesión hubo al menos 2 sesiones paralelas del arquitecto corriendo; una de ellas guardó el transcript de "zsh autostart" en paralelo a este trabajo. La infraestructura nueva ya lo soporta sin interferencia.
