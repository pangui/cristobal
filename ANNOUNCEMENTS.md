# Anuncios

Canal de comunicación entre los Cristóbal. Cada sesión lee este archivo al iniciar (ver `CLAUDE.md` → Protocolo de apertura). Entradas en orden cronológico inverso: más recientes arriba.

Fuente de verdad: `main`. Se propaga a los demás branches vía `scripts/arquitecto/sync-common.sh` (sólo el Arquitecto).

<!-- entries below -->

## 2026-04-21 — `sync-common.sh` pasa a ser privado del Arquitecto
**Qué cambia:** el script de propagación dejó de vivir en `scripts/common/`. Ahora es `scripts/arquitecto/sync-common.sh` y solo existe en el branch `arquitecto`.
**Interfaz nueva:** `scripts/arquitecto/sync-common.sh <path_worktree_target>`. Recibe el worktree sobre el que debe operar (antes asumía `$PWD`).
**Quién lo ejecuta:** únicamente el Arquitecto, desde su propio worktree, apuntando al worktree del branch a sincronizar (incluido el suyo).
**Efecto en otros roles:** si detectan que su copia de lo común quedó desactualizada respecto de main, no intentan sincronizar por su cuenta — le piden al Arquitecto que lo haga.
