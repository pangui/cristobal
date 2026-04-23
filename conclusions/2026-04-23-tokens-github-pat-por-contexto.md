---
fecha: 2026-04-23
keyword: ccs
tema: Tokens de GitHub (PATs) segmentados por contexto por rol, no por aislamiento
---

## Qué pasó

CCS pidió instalar `gh` en el contenedor y luego pidió diseño para administrar varios PATs: cuenta pangui (default), org rebuss, org binocular. En la segunda iteración aclaró: **no es aislamiento de seguridad, es separación por contexto** — basta con que cada especialista sepa qué PAT le toca, aunque técnicamente pueda leer los demás.

## Qué decidimos

- **Ubicación común**: `~/.secrets/gh/{pangui,rebuss,binocular}.token` (700/600), fuera de cualquier repo. Nombres = identidad del PAT, no del rol.
- **Helper `ghas <pat-name> <args>`** en `custom.zsh`: inyecta `GH_TOKEN` solo en esa invocación. Sin estado global mutable; el nombre del PAT queda explícito en cada comando (útil en transcripts).
- **Declaración del PAT por rol** en `ROLE.md` (propio del branch, no sincronizado). Asignación: `main`, `arquitecto` → `pangui`; `rebuss` → `rebuss`; `binocular` → `binocular`.
- **Protocolo común** `docs/protocolos/tokens-github.md` con la mecánica; trigger "Invocar gh / crear PR / API GitHub" añadido al índice de CLAUDE.md.
- **Alcance**: PATs son solo para `gh` (API). Git sobre SSH no los usa. Si en el futuro aparece `git` sobre HTTPS por rol, extender con credential helper.
- **Dockerfile**: instala `gh` desde el repo oficial `cli.github.com`.
- **`.gitignore`** excluye `*.key` y `*.token` para blindar contra un secreto que caiga suelto en el repo.

## Qué hicimos

- `main` commit `3518893`: Dockerfile, custom.zsh (ghas), CLAUDE.md índice, nuevo `docs/protocolos/tokens-github.md`.
- `main` commit `4516a49`: `.gitignore` añade `*.key`, `*.token`.
- `arquitecto` commit `12addf2`: sync común + ROLE.md declara PAT pangui.
- `rebuss` commit `5364e48` + `0ee6685`: sync común (ROLE.md pendiente).
- `binocular` commit `0553e1e` + `3fc3a68`: sync común (ROLE.md pendiente).
- PATs movidos de `.key` sueltos (en main y arquitecto) a `~/.secrets/gh/*.token` con 600.

## Qué aprendí

- Cuando CCS pide "administración de X", conviene preguntar temprano si quiere aislamiento duro o separación por contexto. Mi primer diseño fue sobre-ingeniero (wrapper que resolvía token por cwd) porque asumí "rol = boundary de seguridad". La segunda iteración con CCS me recalibró: la convención explícita gana cuando el aislamiento no es el objetivo.
- Nombrar tokens por **identidad** (pangui/rebuss/binocular) y no por **rol** permite que varios roles compartan un PAT y que nuevos roles reutilicen uno existente sin renombrar. El mapeo rol→PAT vive en `ROLE.md`, no en el filesystem.
- Tener el nombre del PAT en cada invocación (`ghas rebuss ...`) lo hace auditable en transcripts. Si el helper resolviera el PAT automáticamente por cwd, esa información se perdería.

## Qué sigue

- ROLE.md de `rebuss` y `binocular`: declarar su PAT cuando CCS entre a esos roles. Mensajes de commit dejan nota.
- Rebuild del devcontainer para que `gh` quede instalado y `custom.zsh` cargue `ghas`.
- Verificación post-rebuild: `which gh && ghas pangui auth status`.
