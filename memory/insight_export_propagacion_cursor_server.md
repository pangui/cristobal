---
name: No usar `export` en guards de autostart — el Cursor server propaga vars hacia nuevos terminales
description: Una env var exportada desde un shell que haya lanzado el Cursor server queda heredada por todos los terminales integrados nuevos, durante toda la vida del server
type: insight
created: 2026-04-22
---

Descubierto al diagnosticar por qué el auto-start de `custom.zsh` (lanzar `claude` al abrir terminal en un especialista) dejó de funcionar en terminales integrados de Cursor.

**Síntoma:** terminal nuevo abierto en `~/cristobal/especialistas/<rol>/` con `ROLE.md` presente no lanzaba `claude`. El archivo `custom.zsh` estaba correcto tanto en repo como en runtime.

**Causa real:** el bloque tenía tres guards:
- `[[ -o interactive ]]` — OK.
- `[[ -z "$CLAUDECODE" ]]` — protege contra recursión; `claude` exporta `CLAUDECODE=1` mientras corre.
- `[[ -z "$CRISTOBAL_AUTOSTARTED" ]]` — redundante con el anterior.

El bloque hacía `export CRISTOBAL_AUTOSTARTED=1` antes de lanzar `claude`. Esa exportación quedó viva en algún shell que posteriormente lanzó el proceso Cursor server (`.cursor-server/...`). Todos los terminales integrados que Cursor abre después son descendientes de ese server, así que heredan la var — y el tercer guard bloquea el autostart en todos ellos indefinidamente.

**Fix aplicado (commit `e8c8799` en main):** eliminar el guard y el export. `CLAUDECODE` solo es suficiente: mientras `claude` corre, está seteada; al cerrar `claude`, desaparece del shell propio, y los terminales nuevos no la heredan del server (el server se lanza típicamente sin claude corriendo).

**Why:** una env var exportada no solo baja a hijos — queda atrapada en cualquier proceso largo-vivido (servers, daemons, tmux, Cursor/VS Code server) que descienda del shell que la exportó. El ciclo de vida de la var se desacopla del ciclo de vida conceptual al que creíamos atarla.

**How to apply:**
- Para guards de "ya hice esto en este shell", preferir variables **no exportadas** (asignación local al shell) o no usar vars en absoluto.
- Si un autostart requiere detectar "claude ya está corriendo", usar la var que el propio `claude` exporta (`CLAUDECODE`), no una propia.
- Al diagnosticar un autostart que no dispara, revisar primero `env | grep <guard>` en un terminal "fresco" — si la var ya está seteada sin haberla puesto, hay herencia fantasma.
