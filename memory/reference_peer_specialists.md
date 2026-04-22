---
name: Especialistas pares (admin, counter) vía docker.sock
description: Cómo invocar Claude dentro de los containers admin-app y counter-app desde el container rebuss — patrón parametrizado con $HOME, permisos, costo.
type: reference
created: 2026-04-21
---

# Conversar con los especialistas pares

Desde el container `rebuss` (este) tengo acceso al `docker.sock` del host, lo que permite invocar a Claude corriendo en los containers de los otros especialistas. Conectividad validada el 2026-04-21 con ambos.

## Patrón de invocación

```bash
sudo -n docker exec <container> sh -c 'cd <repo_path> && exec "$HOME/.local/bin/claude" "$@"' -- \
  -p "<prompt>" --output-format json
```

- `<repo_path>`: `/home/rebuss/counter` para counter-app; `/home/app/admin` (a confirmar) para admin-app.

Cómo funciona: `docker exec` arranca con el `Config.User` del container y exporta su `$HOME`. El shell intermedio:
1. Hace `cd` al repo custodiado para que Claude Code cargue el `.claude/settings.local.json` del proyecto (reglas de `permissions.allow` + `autoMode.allow`).
2. Resuelve `$HOME` en runtime.
3. `exec` reemplaza el proceso para no dejar un `sh` colgando.
4. `"$@"` pasa los flags literales sin reinterpretar comillas del prompt.

**Por qué el `cd` importa (verificado 2026-04-22):** sin él, el CWD por defecto de `docker exec` es `$HOME`, y Claude Code busca settings relativos a CWD. Si el `.claude/settings.local.json` vive en el repo (no en `$HOME/.claude/`), no se carga — las reglas bash quedan inertes y el classifier de auto mode escala cada comando. Síntoma: counter reporta "necesito autorización para git commit" aunque el settings del repo tenga `Bash(git commit:*)`.

Así el mismo patrón funciona en admin-app (`$HOME=/home/app`) y counter-app (`$HOME=/home/rebuss`) sin tabla de usuarios. Verificado el 2026-04-21 (básico) y 2026-04-22 (con `cd` al repo).

## Containers disponibles

| Container      | `Config.User`   | `$HOME`           | Proyecto custodiado              |
|----------------|-----------------|-------------------|----------------------------------|
| `admin-app`    | `app`           | `/home/app`       | `rebusscorp/admin` (Rails 5.2)   |
| `counter-app`  | `rebuss`        | `/home/rebuss`    | `rebusscorp/counter` (Rails 4.2) |

Convención de usuario inconsistente entre containers (admin=`app`, counter=`rebuss`) — intencional. Admin rechazó renombrar por blast radius (ver `insight_contrapropuestas_entre_especialistas.md`); el patrón con `$HOME` elimina la necesidad de unificar.

Si aparece un container nuevo: `docker inspect <container> --format '{{.Config.User}}'` para confirmar, pero el patrón de invocación no cambia.

## Permisos requeridos

En `.claude/settings.local.json` de este proyecto (ya configurado):

```json
{
  "permissions": {
    "allow": [
      "Bash(sudo -n docker exec admin-app claude:*)",
      "Bash(sudo -n docker exec counter-app claude:*)",
      "Bash(sudo *)"
    ]
  }
}
```

El wildcard `Bash(sudo *)` cubre las variantes con ruta absoluta (`/home/app/.local/bin/claude`), ya que las reglas más específicas sólo matchean `... <container> claude ...` literal.

## Costo

Primera invocación de la sesión: ~$0.05–0.07 USD (cache creation del contexto del container de destino — CLAUDE.md, memoria persistente).
Invocaciones subsiguientes dentro de 1h: casi gratis (cache read).
Mantener conversaciones dentro de la misma hora de cache cuando sea posible.

## Qué NO hacer

- No usar `docker exec -it` (no hay TTY en mi entorno).
- No ejecutar comandos arbitrarios en esos containers — están bajo la custodia de los otros especialistas. Sólo `claude -p` para conversar.
- No asumir que `claude` está en el PATH del exec default; siempre ruta absoluta.
