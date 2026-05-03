---
fecha: 2026-05-02
keyword: arquitecto
tema: Creación del especialista `padre` y bug expuesto en `crear-especialista.sh`
---

## Pregunta

CCS pidió crear el rol `padre`. El propósito propuesto fue aceptado: acompañar a CCS en su rol de padre de **Clemente** (hijo). Sostiene continuidad afectiva, registra hitos, sugiere rituales. No reemplaza al padre ni decide por él.

## Qué hicimos

1. **Pre-condiciones.** Main estaba sucio (estado operacional del rol main) y 2 commits adelante de origin sin pushear. Stash + push + script.
2. **Script de creación.** Branch `padre` creado y pusheado. Main actualizado (tabla, ANNOUNCEMENTS, alias zsh, code-workspace). Propagación a hermanos mixta.
3. **Bug detectado.** `crear-especialista.sh` línea 245 hacía `git add -A` después del sync, barriendo todo lo untracked del worktree hermano. En binocular y rebuss eso bundleó imágenes, notas, transcripts, una SSH key (`id_ed25519`) y dos transcripts con tokens reales (GitHub PAT, Sentry). GitHub Push Protection rechazó ambos pushes.
4. **Rollback con daño colateral.** `git reset --hard origin/<branch>` en binocular y rebuss eliminó los commits sucios *y* los archivos nuevos del working tree (no sólo lo comprometido). En rebuss además eliminó dos commits locales viejos (intentos de sync no pusheados); su contenido se reabsorbió en el nuevo commit limpio.
5. **Recuperación selectiva.** `git restore --source=<bad-commit> --worktree` para los archivos seguros. Excluidos del restore: `id_ed25519` (SSH key) y los dos transcripts con tokens.
6. **Fix del script.** Reemplazado `git add -A` por confianza en lo que `sync-common.sh` ya stagea vía `git checkout main -- <path>`. Comentario explícito advirtiendo no re-introducirlo.

## Decisiones

- El propósito del rol `padre` quedó canónico tal como se ejecutó, sin retoque.
- `git restore --source=<commit> --worktree` es la forma correcta de recuperar archivos desde un commit pasado dejándolos untracked (no toca el índice).
- El script `crear-especialista.sh` ahora confía en el stage que hace `sync-common.sh`. Si en el futuro algún otro script común genera cambios no stageados, hay que stagearlos explícitamente con su path — nunca con `-A`.

## Cabos abiertos

- **Política sobre transcripts con secretos.** Hay PATs y Sentry tokens reales en transcripts pasados. Falta decidir: ¿sanitizar al cierre?, ¿borrar?, ¿mover fuera del repo? Aplica también a futuros transcripts.
- **`id_ed25519` en binocular.** Si se usaba para algo, está perdida del disco (recuperable del reflog ~30 días). Si era basura, dejarla morir.
- **Marco al pedir autorización para destructive ops.** Mi framing del rollback fue incompleto: dije "destruyo los commits" sin mencionar que también se borraban los archivos nuevos. Lección: cuando pido ok para algo destructivo, enumerar concretamente qué se pierde, no abstraer.

## Estado al cierre

- `padre` propagado a los 4 hermanos en origin (binocular, rebuss, arquitecto, main).
- Worktrees de binocular y rebuss restaurados con archivos operacionales como untracked — los roles deciden qué commitear cuando despierten.
- Script arreglado y pusheado en arquitecto (`1432b5a`).
- Memoria: `user_familia.md` con Clemente como hijo de CCS.
