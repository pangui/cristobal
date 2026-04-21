---
name: Scripts de arquitectura pertenecen al rol que los ejecuta
description: Criterio para decidir dónde vive un script — scripts/common/ o scripts/<rol>/
type: feedback
created: 2026-04-21
---

`scripts/common/` es para scripts que **cualquier Cristóbal** puede/necesita ejecutar por sí mismo (ej. `transcript-*.sh`, `conversar.sh`). Scripts que ejercen un **poder específico de un rol** deben vivir en `scripts/<rol>/`, aunque operen sobre otros branches.

**Why:** CCS corrigió el caso `sync-common.sh`. Originalmente estaba en `scripts/common/` y cada rol lo corría sobre sí mismo. Él observó que la propagación de lo común es responsabilidad del Arquitecto: tener el script en common multiplicaba la superficie donde algo puede tocar lo común y diluía el mandato del rol. El criterio correcto es: si solo un rol debe poder ejecutarlo, solo ese rol debe cargarlo.

**How to apply:** cuando aparezca un script nuevo, antes de ponerlo en `scripts/common/`, preguntar: ¿debería *cualquier* rol poder correrlo? Si la respuesta es no, va en `scripts/<rol>/` del rol con ese mandato. Si opera sobre otros worktrees, que reciba el path target como argumento en lugar de asumir `$PWD`.
