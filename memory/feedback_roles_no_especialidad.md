---
name: "Roles" reemplaza a "especialidad/especialista" en el proyecto Partner
description: En docs, protocolos, código y plantillas del proyecto Partner se usa "rol/roles", no "especialidad/especialista".
type: feedback
created: 2026-04-25
---

En el proyecto Partner (binocular/whispers, binocular/partners, plantillas, protocolos heredables), el término canónico es **"rol" / "roles"**. La palabra "especialidad" / "especialista" se reemplaza.

**Why:** CCS lo decidió el 2026-04-25. "Especialidad" arrastra connotación de "experto en un dominio acotado"; "rol" es más neutral y describe mejor lo que un partner hereda — una identidad funcional (main, arquitecto, madre, amiga) que puede ser tan amplia o tan específica como se quiera.

**How to apply:**
- Modelo de datos: `other_specialists` → `other_roles`. `BASE` se documenta como "roles que todo partner hereda".
- Plantillas de texto al humano: §8.4 "auto-creación de especialistas" → "auto-creación de roles".
- Docs internos del proyecto Partner (READMEs, CLAUDE.md heredables, comentarios de código): rol/roles consistentemente.
- Si veo "especialista" en `partners.md` o `partners.rb` del Arquitecto, lo señalo a CCS — son worktrees ajenos, no los edito.
- No aplica retroactivamente a `pangui/cristobal` (donde main/arquitecto/binocular/rebuss se llaman "especialistas") salvo que CCS pida propagación común vía Arquitecto. La regla actual es para el proyecto Partner que estamos construyendo.
