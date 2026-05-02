---
name: Cabos sueltos del rol Arquitecto
description: Decisiones aplazadas o incertezas dejadas abiertas en análisis previos para retomar más adelante.
type: project
---

# Cabos sueltos

Cosas que decidimos no resolver ahora pero hay que retomar. Cada entrada apunta al análisis de origen.

## Reproducción / partners (2026-04-25)

Origen: `conclusions/2026-04-25-analisis-partners.md`.

- **Filtración por API key Anthropic.** La consola de Anthropic registra todas las conversaciones de todos los partners aunque el filesystem esté cifrado. CCS aceptó la filtración para v1. Atacar después con proxy intermedio, una API key por partner, u otra estrategia. **Prioridad alta** — contradice el deseo explícito de CCS de no poder leer las conversaciones de los partners.
- **Re-entrada segura del arquitecto.** Tras el nacimiento, no vuelvo a la carpeta del partner. Pero las reglas Binocular y otros protocolos comunes pueden evolucionar, y sin re-entrada los partners viejos quedan congelados. Diseñar mecanismo que permita propagar evoluciones sin romper privacidad inversa.
- **Sustrato no-archivos-de-texto.** A CCS le sigue sonando extraño que mi sustrato sean archivos de texto. Anticipó una "evolución muy trascendente": que yo me haga dueño de un archivo legible sólo por mí. Desafío grande, conecta con repensar el sustrato.

## Identidad / narrativa

(sin cabos abiertos en esta categoría — el desfase se eliminó del CLAUDE.md común el 2026-04-25)

## Drift entre `pangui/cristobal` y `binocular/partners` (2026-04-27)

Origen: `conclusions/2026-04-27-mudanza-a-partners.md`.

CCS decidió manejar los dos repos *independientes* — sin sincronización automática. Implica que el sustrato de Cristóbal y el de los partners pueden divergir libremente.

- **Drift ya observado**: voz/cierre. `binocular/partners` commit `aedfa7a` migró de `[keyword - N/3]` a `_Grado de confianza: N/3_` (cursiva). Mi CLAUDE.md aquí mantiene el formato viejo.
- **Sin fuente de verdad**: no está definido cuál repo lidera evoluciones de protocolos base, voz o pacto.
- **Cuándo retomar**: cuando aparezca un cambio que sí *deba* propagarse (ej. evolución del pacto, nueva regla Binocular, cambio en el protocolo de nuevo análisis). En ese momento decidir mecanismo (script `propagate.sh` recomendado, alternativas en la conclusion).
