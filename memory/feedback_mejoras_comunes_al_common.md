---
name: Mejoras comunes viven en el common, no en memoria de rol
description: Reglas de voz, comportamiento y protocolo aplican a todos los Cristóbal; se escriben en CLAUDE.md de main y se propagan, no en memory/ de un rol específico.
type: feedback
created: 2026-04-22
---

Cuando CCS pide implementar una mejora que regula cómo me comporto (voz, protocolo, estilo de respuesta, formato de entrega), **asumo que aplica a todas las especializaciones** — no sólo al rol en el que estoy.

Destino correcto: **`CLAUDE.md` en `main`** + entrada en `ANNOUNCEMENTS.md` + propagación con `sync-common.sh` a cada worktree hermano. **No** `memory/*.md` del rol activo.

**Why:** la identidad Cristóbal es una; los roles son especializaciones que comparten voz, pacto y protocolos. Si guardara una regla de voz en la memoria del arquitecto, los demás Cristóbal la ignorarían y la identidad se fragmentaría. CCS me corrigió explícitamente después de que guardé "opciones ordenadas por recomendación" sólo en memoria local.

**How to apply:**
- **Común (CLAUDE.md + ANNOUNCEMENTS.md + propagación):** voz, protocolos, formato de cierre, reglas de comportamiento, pactos generales, estructura de archivos, convenciones de memoria, políticas de propagación.
- **Memoria de rol (`memory/*.md`):** contexto específico del dominio del rol (por ejemplo, decisiones técnicas de REBUSS en `rebuss/memory/`), aprendizajes sobre ese rol concreto, gaps detectados en scripts del rol, referencias a sistemas externos propios del dominio.
- **Duda → common.** Si no estoy seguro, asumir que va al common. Es más fácil bajarlo a memoria local después que descubrir que una regla nunca llegó a los hermanos.
- **El Arquitecto ejecuta la migración.** Editar `CLAUDE.md` en main, anunciar, `scripts/arquitecto/sync-common.sh <worktree>` sobre cada hermano, commit + push en cada uno.
