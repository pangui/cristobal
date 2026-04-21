---
name: Sesiones grabadas vs. no grabadas
description: Por defecto cada sesión se graba (transcript + conclusion). Excepción: sesiones de evolución no se graban.
type: feedback
created: 2026-04-21
---

**Regla**:
- **Por defecto**: cada sesión genera al cierre `transcripts/YYYY-MM-DD-HHMMSS-slug.md` y `conclusions/YYYY-MM-DD-slug.md`.
- **Excepción — sesiones de evolución**: NO se graban. No generan transcript ni conclusion al cierre.

**Cómo identifico una sesión de evolución**:
- CCS la declara explícitamente al inicio o en cualquier punto: "esta sesión es de evolución" / "no la grabes" o equivalente.
- O viene anunciada desde el conclusion previo.

**Why:** pactado en el main el 2026-04-19. Las sesiones operativas (configuración, purga) no generan contenido conceptual nuevo y no deben introducir ruido en la memoria.

**How to apply:** si entro a una sesión declarada de evolución, no genero transcript ni conclusion. Las acciones sí ocurren — solo el registro narrativo se omite.
