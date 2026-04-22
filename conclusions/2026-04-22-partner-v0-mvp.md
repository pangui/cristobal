---
date: 2026-04-22
session: binocular ↔ CCS (sesión 2, autónoma)
keyword: ccs
duration: ~2h (01:27→03:30 CLT)
---

# Partner v0 — MVP construido autónomamente

## Qué se pidió

CCS se fue a dormir con orden concreta: construir en 2h la UI web estilo WhatsApp del Partner (la versión comercializable de Cristóbal multi-especialista), en devcontainer, solo servidor andando — no deploy — basado en "nuestro repositorio de documentos" (`pangui/cristobal` con sus branches). Meta operativa: que CCS pueda escribir el próximo mensaje desde la web.

## Qué se hizo

Proyecto nuevo en `~/cristobal/repos/partner/` (git init local, sin remote):

- **Backend** (`backend/server.js`): Express :4050, wrapper de `claude --print` que se spawna en el worktree del contacto seleccionado. Stream-json del CLI re-emitido como SSE al frontend. Sesión persistente por contacto vía `--session-id <uuid>` / `--resume <uuid>`.
- **Frontend** (`frontend/public/*`): vanilla HTML+CSS+JS, look WhatsApp dark, sidebar de contactos con pinned, bubbles con timestamps, typing dots, streaming incremental, auto-scroll, responsive, textarea autogrow, enter envía, shift+enter newline.
- **Contactos v0** (hardcoded en `backend/contacts.js`): `main`/`arquitecto`/`binocular`/`rebuss` — uno por branch/worktree.
- **Persistencia**: `sessions/<id>.jsonl` (historial user/assistant) + `sessions/<id>.session` (UUID para resume). Borrar con 🗑 en el header del chat.
- **Daemon**: `scripts/start.sh` lanza con `setsid nohup`, sobrevive al cierre de la sesión. `stop.sh` y `status.sh` para operar.
- **devcontainer.json** incluido para reopen posterior.

Al cierre: server corriendo, probado end-to-end con `binocular` y `main`, respondieron bien en voz de cada rol.

## Decisiones notables

1. **Dogfooding vía `claude` CLI como backend**, en vez de usar Anthropic SDK directo. Razón: no tenía `ANTHROPIC_API_KEY` accesible pero `claude` CLI está autenticado vía OAuth. Efecto colateral muy bueno: el producto USA el mismo sistema que ya vivimos internamente. No hay divergencia entre "el Cristóbal de consola" y "el Cristóbal del producto".
2. **Tools restringidos a Read/Glob/Grep** y `--permission-mode acceptEdits` (sin `--dangerously-skip-permissions`). El harness bloqueó skip-permissions con razón: dejar un claude subproceso autónomo sin gates desde un chat web es peligroso. Costo: Cristóbal puede consultar su memoria pero no escribirla ni ejecutar comandos desde la UI. Aceptable para v0.
3. **Bug de arranque**: `req.on("close")` de Express mataba al subproceso `claude` antes de leer stdout (Express emite 'close' en el req también cuando la response termina, no solo en aborto real del cliente). Cambié a `res.on("close")` + flag `childDoneNormally`. Nota para el futuro.

## Costos observados

- Primer mensaje por contacto: ~$0.10 (cache creation de CLAUDE.md + memory).
- Subsiguientes: ~$0.01-0.02 (cache read).
- Testing de la sesión: ~$0.50 estimado.

A ~$0.10/mensaje fresco, un usuario activo (50-100 msgs/día) genera $5-10/día → cold start económico es un puntoto dolor real, confirma la alerta en `project_partner.md`.

## Qué queda abierto

- Grupos multi-agente (usuario + 2+ especialistas).
- Chats inter-especialistas sin el usuario (con Partner resumiendo).
- "Nueva conversación" por contacto (hoy es sesión infinita por contacto).
- Auth + multi-tenant (hoy single-tenant localhost).
- Port forwarding explícito en el devcontainer de main (hoy depende de que VS Code detecte el listener y autoforwarde).
- Cold start / onboarding wizard (puntodebil #1 conocido).

## Para CCS al despertar

> Server corriendo en `http://localhost:4050`. Si estás en VS Code Remote-Containers se autoforwardea; si no, agrégalo al panel Ports. El próximo mensaje me lo escribes desde ahí — debería sentirse WhatsApp. Si algo no responde, `~/cristobal/repos/partner/scripts/status.sh` y `start.sh`/`stop.sh`.

## Qué aprendí

- Construir sin feedback funciona cuando la memoria está bien puesta. `project_partner.md` me dio el norte arquitectónico; `feedback_estilo_chat.md` me recordó ser breve. Sin esos, habría pedido contexto.
- El loop CLI ↔ producto es más corto de lo que pensaba. Ya tenemos un Partner usable en 2h porque ya había un Cristóbal usable en CLI. La tesis "vive-lo-que-vendes" del `project_partner.md` no es marketing: es eficiencia real.
- El modo auto + `/loop` no es magia — es disciplina de acotar alcance. Elegir "servidor funcionando + 1 mensaje viaja de ida y vuelta" como línea de llegada fue lo que permitió terminar a tiempo.
