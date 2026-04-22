---
name: Devcontainer necesita proceso de usuario activo para sobrevivir a inactividad
description: El devcontainer del main perdía conexión tras rato de inactividad porque no tenía ningún proceso de usuario corriendo; contenedores con foreman/bin/dev/tail-f no sufren el síntoma.
type: insight
created: 2026-04-22
---

## Observación empírica (host de CCS)

De cuatro devcontainers del host, solo `cristobal/main` perdía la conexión Cursor-contenedor tras inactividad. Comparando:

| devcontainer | PID 1 resultante | procesos de usuario persistentes |
|---|---|---|
| life | `sleep infinity` (bg: foreman) | `foreman` y sus hijos |
| admin | `sleep infinity` | `bin/dev` (puma, jsbundling) vía postStartCommand |
| counter | `tail -f postgres.log` | `bin/dev` vía postStartCommand |
| cristobal | `sleep infinity` | **ninguno** |

Factor distintivo: los tres funcionales tienen al menos un proceso de usuario activo persistente en el contenedor; cristobal no.

## Mecanismo fino: incierto

Candidatos plausibles (no descartados, no confirmados):
- Zombie reaping con PID 1 `sleep infinity`: vscode-server hace spawn intensivo; sin `init` real, zombies se acumulan.
- Docker userland-proxy / NAT keepalive: sin tráfico alguno, conexiones de larga duración pueden expirar.
- vscode-server / Cursor tunnel inactivity shutdown.
- Watchers (chokidar) degradando cuando el filesystem está congelado.

## Fix aplicado (2026-04-22)

En `cristobal/.devcontainer/`:
1. `docker-compose.yml`: `init: true` en el service `app` — tini como PID 1 wrapper, resuelve zombie reaping.
2. `devcontainer.json`: `postStartCommand: ".devcontainer/keepalive.sh"`.
3. `keepalive.sh` + `keepalive-daemon.sh`: el primero es idempotente (no duplica si ya corre), el segundo escribe `$HOME/.container-heartbeat` cada 60s.

Replica empíricamente el patrón que distingue los funcionales (proceso de usuario activo), sin añadir un servicio real (el cristobal es entorno de Claude Code puro, no app Rails).

## Aplicación futura

- Si un especialista nuevo se crea como devcontainer aislado tipo cristobal (sin Rails/foreman), aplicar el mismo patrón desde el inicio: `init: true` + daemon keepalive.
- Si el síntoma reaparece pese al fix, el mecanismo fino NO era proceso de usuario activo; tocaría diagnosticar con `journalctl -u docker`, `docker logs`, o capturar `ss -tnp` desde dentro del contenedor antes y después de la caída.
