---
name: Dashboard — porting Node hecho, falta wire-up en partner
description: Estado del repo pangui/dashboard al 2026-04-23 tras porting Ruby→Node; siguiente paso wirear proxy /rebuss en partner y apagar life/app.
type: project
---

Repo `pangui/dashboard` (privado, dueño CCS, admin operativo rebuss) con 5 commits en `origin/main`:

- `db7b394` scaffold: README, .gitignore, .env.example
- `fd990de` scaffold: Express server (Node 22, ESM) con router mount-path robusto
- `f7a072d` clients: port GitHub/Sentry/NewRelic de Ruby a Node
- `3f9ff45` frontend: portar dashboard.html desde life con URLs relativas
- `e2cd812` scripts: start/stop/status al estilo partner

Local en `~/cristobal/repos/dashboard/` con `node_modules/` y `.env` poblado. Corre en `:4070`. `/api/dashboard` devuelve datos reales (GitHub PRs/issues, Sentry unresolved, New Relic apdex). `.git/config` limpio (sin PAT embebido).

**Mount-path:** todo el API+UI vive bajo un `express.Router()` montado en `BASE_PATH` (default `/`). `/health` queda siempre a nivel app para healthchecks estables. Probado con `BASE_PATH=/rebuss`: `/rebuss/`, `/rebuss/api/*` funcionan; raíz devuelve 404 correctamente. El HTML usa rutas relativas (`./api/...`), por lo que partner puede proxear con o sin strip del prefijo.

**Decisiones firmadas por CCS (no reabrir):**
- Nombre `dashboard`, no `rebuss-dashboard`. Herramienta personal de CCS; crecerá a pendientes personales, etc.
- Dueño: CCS. Admin operativo: rebuss.
- Stack: Node 22 + Express, estilo partner. Ruby/Sinatra descartado.
- Repo independiente en `~/cristobal/repos/dashboard/`, paralelo a partner.
- Anfitrión previsto: reverse-proxy `/rebuss` desde partner (puerto 4050, mismo devcontainer).
- Porting delegado a **binocular** (rol desarrollador técnico), no a rebuss (rebuss es CTO — decisiones/arquitectura). Corrección importante: la tabla del `CLAUDE.md` común describe binocular como "Dirigir la empresa Binocular" pero en la práctica actúa como rol desarrollador. Pendiente de ajuste en tabla si CCS lo aprueba.
- El código Ruby vive todavía en `~/cristobal/repos/life/app/` — **no borrar** hasta test end-to-end comparativo.

**Siguientes pasos (otra sesión, por main):**
1. `app.use('/rebuss', proxy(...))` en `partner/backend/server.js`. Partner puede elegir mantener el prefijo o strip — ambos funcionan.
2. Comparación end-to-end entre endpoints nuevos (`:4070`) y los de `life/app/` — validar que el shape de `/api/dashboard` es idéntico.
3. Recién entonces: borrar código del dashboard de `life/app/`.

**Git HTTPS sin leak:** el arquitecto implementó `gitas <pat-name> <git args>` en `.devcontainer/custom.zsh` (branch main). Credential helper inline que resuelve PAT de `~/.secrets/gh/<name>.token` solo para esa invocación — no persiste en `.git/config`, argv ni env. Uso: `gitas pangui push -u origin main`. Si la shell no tiene `gitas` cargado (devcontainer no reiniciado), el workaround efímero es `git -c http.extraheader="Authorization: Basic $(printf 'x-access-token:%s' "$(<~/.secrets/gh/pangui.token)" | base64 -w0)" <op>` (lo que usó binocular). Nunca `https://x-access-token:${PAT}@...` en URL.

**Why:** el porting está hecho y validado funcionalmente; lo único que falta antes de apagar el Ruby es el proxy en partner + comparación E2E. Sin esta nota, futuras sesiones indagarían desde cero tres cosas ya resueltas: push, porting, helper git.
**How to apply:** cuando CCS diga "dashboard" o "sigamos con dashboard", arrancar por el paso 1 (proxy en partner). El porting ya no es tema abierto.
