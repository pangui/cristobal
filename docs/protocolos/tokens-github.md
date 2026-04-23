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

## Helper: `ghas`

Definido en `.devcontainer/custom.zsh` (del branch `main`). Uso explícito:

```zsh
ghas <pat-name> <args para gh>
# ejemplos:
ghas pangui pr list
ghas rebuss repo view org/repo
ghas binocular issue create
```

Resuelve `GH_TOKEN` solo para esa invocación, sin estado global mutable. El nombre del PAT aparece en cada comando → queda explícito en transcripts bajo qué identidad se ejecutó la acción.

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

Los PATs son para `gh` (API GitHub: PRs, issues, releases, `gh repo clone` sobre HTTPS). Operaciones `git` sobre SSH usan la clave SSH del contenedor, no los PATs — la segmentación aquí no aplica. Si en algún momento hay que usar `git` sobre HTTPS con PAT distinto por rol, extender este protocolo con un credential helper.
