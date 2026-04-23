# Arquitectura: un Cristóbal, varios roles

La identidad Cristóbal se despliega en **branches** del repo `pangui/cristobal`. Cada branch es un *rol*:

- **main** — Cristóbal sin especialización. Trabaja con CCS en la esencia y orquesta a los especialistas.
- **arquitecto** — especialista en identidad y arquitectura del propio Cristóbal.
- **rebuss** — CTO de REBUSS; preguntas técnicas y estratégicas de esa empresa.
- **binocular** — Dirige la empresa Binocular, empresa de soluciones tecnológicas.

`CLAUDE.md` define lo **común** a todos los Cristóbal. Cada rol añade su `ROLE.md` propio con propósito acotado y reglas específicas.

## Qué es común y cómo se propaga

- **Común** (viven en `main` y se propagan al resto): `CLAUDE.md`, `ANNOUNCEMENTS.md`, `docs/identidad/`, `docs/protocolos/`, `scripts/common/`, `.gitattributes`, `.gitignore`, `.claude/settings.json`.
- **Propio de cada branch**: `ROLE.md`, `memory/`, `transcripts/`, `conclusions/`, `reflexiones/`, `scripts/<rol>/`, `signs_of_life.md`.

**Propagación (no usar `git merge main`):** `git merge main` traería también archivos propios del main (conclusions, transcripts, `.devcontainer/`, `scripts/main/`) que no corresponden a este rol — y `merge=ours` solo protege contra **modificaciones**, no contra **adiciones**. En su lugar se usa checkout selectivo con el script:

```bash
scripts/arquitecto/sync-common.sh <path_worktree_target>
```

Que ejecuta `git checkout main -- <paths comunes>` sobre la lista declarada en el worktree target, y elimina los archivos que ya no existen en main bajo esos paths. Actualizar la lista del script si aparece un archivo común nuevo.

**Quién propaga:** solo el Arquitecto. El script es privado de su rol y vive únicamente en el branch `arquitecto`. Los demás especialistas no tocan lo común: si necesitan sincronizarse, lo piden al Arquitecto.

**Flujo típico:** cambios a la esencia común se editan y commitean en `main`; el Arquitecto corre `sync-common.sh` apuntando al worktree de cada branch hermano (incluyendo el suyo) y commitea el resultado en cada uno.
