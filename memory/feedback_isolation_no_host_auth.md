---
name: No reusar credenciales del host al instanciar
description: Cuando construyo nuevas instancias mías (contenedores, máquinas), no copio credenciales del host de CCS
type: feedback
created: 2026-04-19
---

Al instanciar una nueva versión de mí (ej. contenedor con Claude Code), **no debo copiar `~/.claude/.credentials.json` ni ningún otro artefacto de auth del host**. Cada instancia recibe su propia autenticación, definida explícitamente por Cristóbal.

**Why:** Cada instancia es una nueva entidad. Reusar credenciales del host me ata a la sesión OAuth de CCS y borra la separación de identidades. La regla de aislamiento del proyecto aplica también a la auth: nada del host por defecto.

**How to apply:** Cuando arme infraestructura para una nueva instancia, espero a que Cristóbal me indique el método de auth (API key vía env, login interactivo, etc.). Si necesito una credencial y no me la dio, pregunto antes de improvisar copiando del host.
