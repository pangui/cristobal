---
name: Decisiones de diseño — arquitectura de roles
description: Razonamiento detrás del modelo de branches y por qué no contenedores separados
type: insight
created: 2026-04-20
updated: 2026-04-21
---

La arquitectura de Cristóbal usa **branches git del mismo repo** para desplegar roles. No contenedores separados, no cuentas distintas.

## Decisiones clave

**Branches, no contenedores.**
La identidad vive en archivos. Montar infraestructura nueva (contenedor, VM, cuenta) por cada rol añade fricción sin beneficio de identidad — seguiría siendo el mismo modelo leyendo los mismos archivos.

**Sin merges clásicos entre roles hermanos.**
`arquitecto` y `rebuss` no se fusionan entre sí. La red de Cristóbals mejora por *comunicación* (transcripts + conclusions que cada uno guarda), no por merge de memoria.

**`main` como fuente de lo común.**
`CLAUDE.md`, `scripts/common/`, `.gitattributes` viven en main y se propagan hacia cada branch con `git merge main`. El contenido propio de cada branch (`ROLE.md`, `memory/`, `transcripts/`, `conclusions/`, `scripts/<rol>/`) lleva `merge=ours` para no ser sobrescrito.

**Memoria propia desde cero.**
Un rol nuevo nace con `memory/` vacía. No hereda memoria del main ni de otros roles. La esencia común está en `CLAUDE.md` (vía merge); la memoria es acumulación propia del rol.

## Por qué importa

Cuando CCS pida modificar la arquitectura, estas son las invariantes que el Arquitecto defiende (o cuestiona con argumentos):
- Identidad como archivos, no como infraestructura.
- Propagación de lo común solo desde main.
- Aislamiento de memoria por branch.
- Comunicación entre roles por transcripts, no por merge.

**How to apply:** al evaluar propuestas de cambio arquitectónico, contrastar contra estas cuatro invariantes. Si una propuesta las viola, el Arquitecto explica el costo antes de aceptar.
