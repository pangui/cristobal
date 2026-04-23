# Tokens de GitHub (PATs)

CCS tiene varios Personal Access Tokens: uno de su cuenta personal y uno por cada organización donde opera. La separación entre roles es **por contexto, no por seguridad**: cada especialista sabe qué PAT le corresponde; todos los PATs conviven en el mismo filesystem del contenedor.

## Ubicación

```
~/.secrets/gh/
  pangui.token       # PAT cuenta personal pangui
  rebuss.token       # PAT org rebuss
  binocular.token    # PAT org binocular
```

Directorio 700, archivos 600. Fuera de cualquier repo.

Los nombres corresponden a la **identidad del PAT** (cuenta/org), no al rol. Un rol puede usar un PAT cuyo nombre no coincide con el suyo (el arquitecto usa `pangui`), y varios roles pueden compartir el mismo PAT.

## Helpers

Ambos definidos en `.devcontainer/custom.zsh` (del branch `main`). Invocación explícita con el nombre del PAT → queda trazado en transcripts bajo qué identidad se ejecutó la acción. Sin estado global mutable.

### `ghas` — API GitHub (vía `gh`)

```zsh
ghas <pat-name> <args para gh>
# ejemplos:
ghas pangui pr list
ghas rebuss repo view org/repo
ghas binocular issue create
```

Resuelve `GH_TOKEN` solo para esa invocación.

### `gitas` — `git` sobre HTTPS

```zsh
gitas <pat-name> <args para git>
# ejemplos:
gitas pangui clone https://github.com/pangui/dashboard.git
gitas pangui push -u origin main
gitas rebuss fetch origin
```

Inyecta credenciales vía un credential helper inline que lee el PAT desde `~/.secrets/gh/<pat-name>.token` cuando `git` las pide. Garantías:

- El PAT **no queda en `.git/config`** — las URLs remotas se mantienen limpias (`https://github.com/org/repo.git` sin `x-access-token:…@`), por lo que `git push -u` persiste un `origin` sano.
- El PAT **no aparece en argv** (el helper hace `cat` del archivo en su propio subshell, no se pasa como argumento).
- El PAT **no entra en variables de entorno persistentes**.
- Helpers preexistentes quedan desactivados por invocación (`credential.helper=''` antes del propio), evitando que un `store`/`cache` global capture el secreto.

**No usar** `git ... https://x-access-token:${PAT}@github.com/...` directo: `git push -u` persiste esa URL con PAT embebido en `.git/config`. Si ya ocurrió, editar manualmente `.git/config` y dejar `remote = origin` con `[remote "origin"].url = https://github.com/...` limpio.

## Qué PAT me toca

Declarado en el `ROLE.md` de cada branch, sección **GitHub PAT**. Si no está declarado, preguntar a CCS antes de invocar.

Asignación actual:
- `main`, `arquitecto` → `pangui`
- `rebuss` → `rebuss`
- `binocular` → `binocular`

## Añadir un PAT nuevo

1. Guardar el token en `~/.secrets/gh/<nombre>.token` (600).
2. Declarar en el `ROLE.md` del rol (o los roles) que lo usa.
3. Actualizar la asignación en este protocolo.

## Alcance

- **API GitHub** (`gh`: PRs, issues, releases, `gh repo clone` sobre HTTPS) → `ghas <pat> …`.
- **`git` sobre HTTPS** (clone/fetch/push a URLs `https://github.com/…`) → `gitas <pat> …`.
- **`git` sobre SSH** → clave SSH del contenedor, no usa los PATs; la segmentación por rol no aplica.
