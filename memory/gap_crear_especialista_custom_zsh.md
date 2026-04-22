---
name: Gap en crear-especialista.sh — alias zsh no vive en runtime
description: El script actualiza .devcontainer/custom.zsh en el repo, pero la copia activa en ~/.oh-my-zsh/custom/custom.zsh solo se renueva al reconstruir el contenedor
type: insight
created: 2026-04-22
---

Observado al crear `binocular` (2026-04-22): el alias se añadió correctamente al archivo del repo pero `zsh: command not found: binocular` en el shell de CCS.

**Causa:** el `Dockerfile` del devcontainer hace `COPY custom.zsh "$HOME/.oh-my-zsh/custom/custom.zsh"` al construir la imagen. En runtime, oh-my-zsh sólo lee esa copia instalada, no el archivo del repo. Los aliases `arquitecto`/`rebuss` funcionaban porque estaban al momento del build.

**Fix aplicado en caliente:** `cp` del archivo del repo a `~/.oh-my-zsh/custom/custom.zsh` + `source` en el shell de CCS.

**Fix pendiente en el script:** después de actualizar `.devcontainer/custom.zsh` en main, hacer además:

```bash
cp .devcontainer/custom.zsh "$HOME/.oh-my-zsh/custom/custom.zsh" 2>/dev/null || true
```

Para que un especialista recién creado sea invocable sin reconstruir el contenedor. El `|| true` cubre el caso de ejecutar el script fuera del devcontainer.

**Why:** sin esto, el último paso del protocolo (`source ~/.zshrc && <nombre>`) falla aunque todo lo demás esté bien — rompe la experiencia de creación.

**How to apply:** cuando CCS pida crear otro especialista, o si toco `crear-especialista.sh` por otro motivo, aprovecho para añadir el `cp` antes del bloque de propagación a hermanos.
