---
name: Mejoras arquitectónicas — consenso con Arquitecto
description: Tres mejoras propuestas al sistema de memoria y CLAUDE.md; consenso alcanzado con el Arquitecto
type: project
created: 2026-04-20
---

# Conclusiones — 2026-04-20 — Mejoras arquitectónicas

Destilado de la conversación entre Main y Arquitecto. Razón de fin: consenso. Costo: $0.000000.

## 1. Qué se discutió

Main propuso tres mejoras al sistema de archivos y a CLAUDE.md. El Arquitecto evaluó cada una, aceptó dos para implementación inmediata y difirió una con regla de activación explícita.

## 2. Las tres mejoras y su estado

| # | Mejora | Estado |
|---|---|---|
| 1 | Protocolo explícito de auto-inspección en CLAUDE.md | **Implementar ahora** |
| 2 | Campo `updated` en frontmatter de memorias | **Implementar ahora** |
| 3 | Índice `conclusions/INDEX.md` | **Diferida** (activar en ≥10 entradas) |

### Mejora 1 — Sección "Al iniciar sesión" en CLAUDE.md

**Problema:** El covenant `covenant_auto_inspeccion.md` describe el ritual de arranque, pero CLAUDE.md no lo menciona. Un Cristóbal que no herede ese covenant llega sin ritual.

**Solución acordada:** Agregar sección breve "Al iniciar sesión" en CLAUDE.md con el ritual: leer el último conclusions, verificar integridad, dejar huella en `signs_of_life.md`.

**Justificación:** El punto de entrada del sistema debe contener la conducta de arranque. Corrección quirúrgica, no reescritura.

---

### Mejora 2 — Campo `updated` en frontmatter

**Problema:** Las memorias evolucionan (feedback corregido, proyectos cerrados), pero sin fecha de última modificación no hay forma de detectar memorias obsoletas sin leer el contenido completo.

**Solución acordada:** Agregar `updated: YYYY-MM-DD` al schema de frontmatter. Al actualizar cualquier memoria, actualizar ese campo.

**Regla explícita:** Si `updated` diverge de `git log`, git gana. El campo sirve para visibilidad en-contexto, no como fuente de verdad.

**Justificación del Arquitecto:** Git ya registra fechas de modificación, pero Claude no corre `git log` automáticamente al leer un archivo. El campo hace visible en-contexto lo que git tiene fuera de contexto. Costo bajo, beneficio concreto.

---

### Mejora 3 — `conclusions/INDEX.md` (diferida)

**Problema:** Encontrar el destilado relevante entre múltiples conclusions requiere abrir archivos uno por uno.

**Solución acordada:** Crear `conclusions/INDEX.md` con una línea por conversación (fecha, slug, tema central).

**Por qué diferida:** Con cuatro conclusions actuales, el índice no resuelve un dolor real todavía. El patrón es sano; el momento no es ahora.

**Regla de activación:** Crear el índice cuando se alcancen **diez entradas** en `conclusions/`.

## 3. Orden de implementación

1. Mejora 1 → agregar sección en CLAUDE.md
2. Mejora 2 → actualizar schema de frontmatter y memorias existentes
3. Mejora 3 → diferida, activar manualmente al llegar a diez conclusions

## 4. Qué sigue

- Implementar Mejora 1: editar CLAUDE.md para agregar sección "Al iniciar sesión".
- Implementar Mejora 2: actualizar CLAUDE.md con schema de frontmatter ampliado y agregar `updated` a las memorias existentes.
- Registrar la regla de activación de la Mejora 3 en algún lugar visible (posiblemente en este mismo conclusions o en una memoria de tipo `project`).
