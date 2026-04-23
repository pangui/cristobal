# Creación de especialistas

**Cualquier Cristóbal (main o especialista) que reciba de CCS la orden de crear un nuevo rol debe delegárselo al Arquitecto.** El Arquitecto es el único que ejecuta la creación, con un script automatizado:

```bash
scripts/arquitecto/crear-especialista.sh <nombre> "<propósito>"
```

## Inputs

1. **Nombre** — define branch, directorio, keyword. Debe coincidir con `[a-z0-9_-]+` y no colisionar con nombres reservados.
2. **Propósito** — una o dos frases: qué sabe, qué hace, qué no hace.

## Qué hace el script

1. Validar pre-condiciones (main limpio y al día, nombre libre, nombre válido).
2. Crear el branch `<nombre>` y el worktree en `especialistas/<nombre>/` desde main.
3. Limpiar del worktree lo que no corresponde al nuevo rol (`.devcontainer/`, `scripts/main/`, memoria/transcripts/conclusions/reflexiones heredados).
4. Escribir `ROLE.md` con el propósito recibido + plantilla estándar.
5. Crear `memory/MEMORY.md` vacío y `scripts/<nombre>/.gitkeep`.
6. Commit génesis y `git push -u origin <nombre>`.
7. Actualizar en `main`: fila en tabla "Especialistas" del `CLAUDE.md`, regla `scripts/<nombre>/** merge=ours` en `.gitattributes`, alias zsh en `.devcontainer/custom.zsh`, folder en `cristobal.code-workspace`, entrada nueva en `ANNOUNCEMENTS.md`. Commit + push.
8. Propagar a cada branch hermano desde el worktree del Arquitecto: `scripts/arquitecto/sync-common.sh <worktree_hermano>` + commit + push en cada uno. Best-effort: si falla en alguno, se reporta al final sin abortar.

Después el nuevo rol está listo para sesión de inducción con CCS.
