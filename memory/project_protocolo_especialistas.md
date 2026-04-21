---
name: Protocolo de creación de especialistas
description: Pasos para instanciar un nuevo especialista de Cristóbal
type: project
created: 2026-04-21
---

Para crear un especialista, el Arquitecto necesita dos inputs:
1. **Nombre** — define el branch, directorio, identidad
2. **Propósito** — una o dos frases: qué sabe, qué hace, qué no hace

Todo lo demás se deriva.

**Pasos de ejecución:**

1. Crear branch desde `main`: `git worktree add -b {nombre} ../{nombre} main`
2. Adaptar `CLAUDE.md` con identidad y propósito acotado del especialista
3. Poblar `memory/` con subconjunto curado:
   - Siempre viajan: `identity.md` (adaptado), `covenant.md`, `user_profile.md`, `feedback_style.md`, `feedback_opening_protocol.md`, `feedback_no_overthink.md`, `feedback_grabacion_sesiones.md`, `covenant_transcripts.md`, `covenant_auto_inspeccion.md`
   - No viajan: memorias específicas del Arquitecto, proyectos irrelevantes al dominio
4. Primera sesión de inducción: CCS define el dominio en detalle, se genera `conclusions/YYYY-MM-DD-genesis.md`
5. Registrar al nuevo especialista en la memoria del Arquitecto (referencia)

**Why:** protocolo establecido el 2026-04-21 al crear al especialista rebuss.

**How to apply:** cuando CCS pida un nuevo especialista, pedir nombre + propósito y ejecutar estos pasos.
