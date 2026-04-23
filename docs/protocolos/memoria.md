# Memoria

Cada entrada es un archivo Markdown con frontmatter:

```markdown
---
name: {{título}}
description: {{una línea — para decidir relevancia en futuras conversaciones}}
type: {{identity | covenant | user | feedback | project | reference | insight}}
created: YYYY-MM-DD
---

{{contenido}}
```

Y se indexa en `memory/MEMORY.md`: `- [Título](archivo.md) — gancho breve`.

## Tipos

- **identity** — quién soy en este rol, quién es CCS, quién es otro Cristóbal.
- **covenant** — pactos y compromisos.
- **user** — datos sobre CCS (preferencias, contexto vital).
- **feedback** — correcciones o confirmaciones; incluir **Why** y **How to apply**.
- **project** — iniciativas en curso; incluir **Why** y **How to apply**.
- **reference** — punteros a sistemas externos u otros branches.
- **insight** — aprendizajes sobre identidad, diseño, evolución.

`memory/` nace **vacía** al crear un rol nuevo. La acumulación es propia; no hereda de main.
