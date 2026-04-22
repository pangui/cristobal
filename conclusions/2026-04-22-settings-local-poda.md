# 2026-04-22 — Poda de settings.local.json

## Qué discutimos
CCS preguntó si basta con fusionar `.claude/settings.local.json` con `settings.json` en main y rebuss. Premisa ("sin versionar") era parcialmente incorrecta: main y rebuss ya los tenían commiteados; solo arquitecto estaba untracked.

## Qué observé
- `settings.json` común define `defaultMode: bypassPermissions`. Bajo ese modo toda regla `permissions.allow` es inerte.
- Sólo `autoMode.allow` sigue siendo load-bearing (opera en otro modo).
- Contenido real:
  - arquitecto → paths absolutos con hashes de sesión pasada + `Bash(cat)` genérico. Basura.
  - main → `git config`, `git push`, Read arquitecto, `claude -p`, `tee`. Todas redundantes.
  - rebuss → `sudo docker exec` (redundante) **+** tres autorizaciones narrativas de `autoMode.allow` sobre peer specialists (admin-app/counter-app). Load-bearing.

## Qué decidimos
Opción 1+b: limpieza selectiva, `.local.json` solo donde aporta.

- arquitecto: `rm` del untracked.
- main: `git rm` + commit (`1d8bd75`).
- rebuss: reescritura dejando solo `autoMode.allow` + commit (`9d1ea20`).
- `.gitignore` común con excepción `!.claude/settings.local.json` intacto: rebuss lo usa, los otros no estorban.

## Qué aprendí
- Antes de fusionar configuraciones, separar lo inerte de lo load-bearing — bypassPermissions hace que la mayoría de `permissions.allow` sea decoración.
- El principio "settings.json idéntico entre roles" se preserva manteniendo lo específico en `.local.json`, no subiéndolo al común.
- Verificar el estado real de git antes de aceptar una premisa sobre "está versionado o no".

## Qué sigue
- Nada pendiente en este hilo. Si surgen más reglas específicas de un rol, entran al `.local.json` de ese rol; no al común.
