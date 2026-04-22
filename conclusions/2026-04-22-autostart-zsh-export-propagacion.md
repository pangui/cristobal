---
fecha: 2026-04-22
keyword: ccs
tema: Auto-start zsh no disparaba — guard con env var exportada propagada por Cursor server
---

## Qué pasó

CCS reportó que el cambio reciente de zsh (auto-lanzar `claude` al abrir terminal en un directorio de especialista, commit `0d504a0` en main) no se gatillaba. El alias funcionaba; el bloque condicional no.

## Diagnóstico

El bloque tenía tres guards; el culpable fue el tercero:

```zsh
[[ -o interactive ]] && [[ -z "$CLAUDECODE" ]] && [[ -z "$CRISTOBAL_AUTOSTARTED" ]]
```

`env` en un shell del contenedor mostró `CRISTOBAL_AUTOSTARTED=1` ya seteada antes de que el bloque se ejecutara. La var se había exportado en algún shell que luego lanzó el proceso Cursor server, y el server la propaga por herencia a cada terminal integrado que abre. Resultado: el guard bloqueaba el autostart en todos los terminales nuevos, indefinidamente, hasta reiniciar el server.

El tercer guard era redundante con el segundo: `claude` mismo exporta `CLAUDECODE=1` mientras corre, que es suficiente para evitar recursión.

## Qué decidimos

- Eliminar `CRISTOBAL_AUTOSTARTED` (tanto el guard como el `export`). Dejar solo `CLAUDECODE`.
- No reiniciar Cursor: el bloque ya no consulta la var fantasma, así que es irrelevante que siga viva en el entorno del server.

## Qué hicimos

- `main` commit `e8c8799`: edita `.devcontainer/custom.zsh` con el bloque simplificado.
- Copia al runtime `~/.oh-my-zsh/custom/custom.zsh` (el Dockerfile solo actualiza en build).
- `arquitecto` commit `40201d2`: memoria `insight_export_propagacion_cursor_server.md` con el patrón para no reincidir.

## Qué aprendí

- Una env var exportada no solo baja a hijos; queda atrapada en cualquier proceso largo-vivido que descienda del shell que la exportó (Cursor server, tmux, daemons). El ciclo de vida de la var se desacopla del ciclo de vida "conceptual" al que uno cree atarla.
- Los guards de autostart deben usar vars que tienen un ciclo de vida garantizado por el programa al que referencian (`CLAUDECODE` lo exporta `claude` mismo). Vars propias para tracking de estado del shell local no deben llevar `export`.
- Al diagnosticar un autostart que no dispara: `env | grep <guard>` en un terminal fresco detecta la herencia fantasma en segundos.

## Qué sigue

- Test final a cargo de CCS: abrir terminal integrado nuevo en un especialista con `ROLE.md` → debería lanzar `claude` solo.
- Si en algún momento se reintroduce un guard similar, revisar la memoria `insight_export_propagacion_cursor_server.md` antes de usar `export`.
