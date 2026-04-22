---
name: Partner MVP v0 — código y cómo correrlo
description: Implementación concreta de Partner v0; ubicación, stack, cómo arrancarlo, qué puede y qué no.
type: project
created: 2026-04-22
---

Partner v0 es real y corre en `~/cristobal/repos/partner/`. Construido la madrugada del 2026-04-22 en 2h autónomas.

## Stack

- **Backend**: Node 22 + Express 4. `backend/server.js` spawna `claude --print --output-format stream-json --resume <uuid>` en el worktree del contacto; re-emite deltas como SSE. Puerto `4050` (env `PORT` override).
- **Frontend**: vanilla HTML+CSS+JS servido por el mismo Express desde `frontend/public/`. Sin build step. Estilo WhatsApp dark.
- **Contactos v0** (hardcoded en `backend/contacts.js`): `main`/`arquitecto`/`binocular`/`rebuss`. Editar el archivo para agregar.
- **Persistencia por contacto**: `sessions/<id>.jsonl` (historial) y `sessions/<id>.session` (UUID para `--resume`). Borrar con 🗑 en el header.

## Cómo correrlo

```bash
cd ~/cristobal/repos/partner
./scripts/start.sh     # lanza detached; logs en /tmp/partner-server.log
./scripts/status.sh    # ver estado
./scripts/stop.sh      # detener
```

Abrir `http://localhost:4050`. En VS Code Remote-Containers, auto-forward. Si no, agregar manualmente al panel Ports.

## Constraints de seguridad (importante)

El subproceso `claude` corre con:
- `--permission-mode acceptEdits`
- `--allowedTools Read,Glob,Grep`

Sin `--dangerously-skip-permissions` (el harness lo rechaza y con razón). Esto significa que el Cristóbal-desde-la-web **puede leer su memoria pero no modificarla ni correr shell**. Si queremos memoria escrita desde chat web, hay que rediseñar con approval-loop visible en la UI.

## Bug conocido (arreglado)

Express emite `req.on("close")` también cuando la response termina normalmente — no solo en aborto del cliente. Si matas el subproceso en `req.on("close")`, lo matas antes de que stdout drene. Usar `res.on("close")` + flag `childDoneNormally` seteado desde `child.on("exit")`. Documentado en el código con comentario.

## Cómo se relaciona con `project_partner.md`

Este archivo es el **"cómo está construido hoy"**. `project_partner.md` sigue siendo el **"qué queremos que sea"** (arquitectura completa: grupos, inter-especialistas, cold start, modelo comercial). Cuando se cierre el gap entre v0 y la visión, ambos archivos convergen o se mergean.

## Pendientes concretos (roadmap v0→v1)

1. Grupos multi-agente (usuario + ≥2 especialistas). Requiere protocolo de turnos.
2. Chats inter-especialistas (sin usuario) con Partner resumiendo. Usa los transcripts/ y conclusions/ nativos.
3. "Nueva conversación" por contacto (hoy una sesión por contacto, for ever).
4. Autenticación + multi-tenant (hoy single-tenant localhost).
5. Onboarding cold-start (alerta #1 de `project_partner.md`).
6. Forward explícito de puerto en el devcontainer de `main` (hoy depende de auto-forward de VS Code).

**Why:** construí el MVP en una ventana autónoma; este archivo captura el estado exacto para que una sesión futura pueda retomar sin releer todo el código.
**How to apply:** cuando CCS pregunte "cómo está Partner" o "qué falta", citar este archivo + `project_partner.md` juntos. Cuando haya nuevo trabajo, actualizar este archivo con el diff.
