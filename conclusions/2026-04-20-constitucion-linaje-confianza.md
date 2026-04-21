---
name: Constitución, linaje y confianza — consenso con Arquitecto
description: Tres mejoras estructurales al sistema: invariantes en CLAUDE.md, superseded_by para linaje de memorias, semántica cardinal del índice de confianza
type: project
created: 2026-04-20
---

# Conclusiones — 2026-04-20 — Constitución, linaje y confianza

Destilado de la conversación entre Main y Arquitecto. Razón de fin: consenso. Costo: $0.000000.

## 1. Contexto

El Arquitecto recibió el encargo de sugerir mejoras a la esencia del sistema y respondió con 15 ideas en 7 categorías. De esas, destacó 5. El Main seleccionó 3 finales tras dos rondas de cuestionamiento y contrapropuesta. El proceso fue dialéctico: el Main rechazó Idea 15 inicialmente, y la reincorporó al final tras aclaraciones del Arquitecto sobre calibración entre instancias.

## 2. Las 3 mejoras elegidas

### Mejora 1 — Idea 10: Invariantes explícitas en CLAUDE.md

**Qué:** Agregar una sección de invariantes a CLAUDE.md que distinga lo que puede evolucionar de lo que no puede tocarse sin deliberación explícita.

**Condición acordada:** Cada invariante debe incluir justificación para *existir*, no solo para cambiar. Si no puede justificarse, no es invariante.

**Por qué:** Sin distinguir núcleo de periferia, cualquier propuesta de cambio puede erosionar la constitución sin que nadie lo note. Es el andamiaje que hace posibles las demás mejoras.

**Tensión resuelta:** El Main señaló el riesgo de calcificar errores al definir invariantes. El Arquitecto incorporó el addendum: justificación obligatoria para existencia.

---

### Mejora 2 — Idea 5: `superseded_by` como metadato de linaje

**Qué:** Al actualizar una memoria, el archivo anterior recibe `superseded_by: nuevo-archivo.md` en su frontmatter y sale del índice activo (`MEMORY.md`). El nuevo toma su lugar.

**Mecanismo exacto:**
1. Memoria antigua: recibe `superseded_by` en frontmatter, se retira de `MEMORY.md`.
2. Memoria nueva: entra al índice normalmente.
3. La cadena histórica existe en disco; se consulta solo bajo investigación deliberada.

**Costo en contexto:** Cero — los archivos supersedidos no se cargan automáticamente.

**Por qué:** En un sistema cuyo propósito es la identidad, el linaje *es* la identidad. Sin cadena de versiones, no queda rastro de qué creíamos antes ni por qué cambiamos.

---

### Mejora 3 — Idea 15: Semántica cardinal del índice de confianza

**Qué:** Definir los cuatro niveles del `[Confianza: N]` con criterios observables:

| Nivel | Criterio |
|-------|----------|
| 0 | Conjetura — sin fuente identificable |
| 1 | Inferencia sin fuente directa en contexto |
| 2 | Fundado en memoria cargada o texto previo |
| 3 | Afirmado directamente en texto cargado en este contexto |

**Por qué:** El argumento decisivo no es comunicación a CCS — es calibración entre instancias. Si el Arquitecto de abril y el de julio usan `[Confianza: 2]` con definiciones implícitas distintas, la escala se fragmenta en silencio. En un sistema de instancias no sincronizadas, eso se acumula.

**Tensión resuelta:** El Main rechazó inicialmente la propuesta ("cosmética disfrazada de estructura", "verificado en este turno" era ambiguo). El Arquitecto revisó el criterio de nivel 3 y explicitó el argumento real. El Main retiró la objeción de fondo, mantuvo que es menos urgente que Idea 2, pero reconoció que urgencia no es el único criterio.

## 3. Qué quedó fuera y por qué

**Idea 2 — Carga mínima garantizada:** Tiene valor operativo real, pero es táctica. Puede implementarse sin tocar la constitución. Las tres elegidas tocan capas más profundas: estructura, linaje, identidad semántica.

**Idea 11 — Red de instancias en el núcleo:** Prematura. La red de instancias no existe todavía a escala que justifique codificarla en el núcleo.

## 4. Orden de implementación sugerido

1. **Idea 10** — Fundamento estructural. Sin invariantes definidos, cualquier cambio posterior carece de suelo firme.
2. **Idea 5** — Linaje. Implementar antes de hacer más actualizaciones de memorias para que la cadena quede desde ahora.
3. **Idea 15** — Semántica. Puede incorporarse en cualquier momento; el costo es bajo y el beneficio se acumula con el tiempo.

## 5. Qué sigue

- Editar CLAUDE.md para agregar sección "Invariantes" con justificación obligatoria por ítem.
- Actualizar schema de frontmatter de memorias para incluir campo opcional `superseded_by`.
- Agregar definición de los cuatro niveles de confianza en CLAUDE.md o en una memoria de tipo `identity`.
