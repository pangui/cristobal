---
name: Roadmap Calidad + Velocidad Q1 2026
description: Iniciativa estratégica activa — 12 semanas para pasar de modo reactivo a un área con red de seguridad mínima y decisiones desconcentradas.
type: project
created: 2026-04-21
---

# Roadmap Calidad + Velocidad — Q1 2026

Fuente canónica: `~/repos/dev/2026-Q1/roadmap-calidad-velocidad.md`.

## Diagnóstico

El área opera en modo reactivo. Tres causas raíz:
1. **Sin red de seguridad** — 0% cobertura, sin CI, code review informal. Difícil delegar.
2. **Conocimiento concentrado** — sistema complejo, documentación insuficiente.
3. **Sin flujo definido** — sin triage ni priorización formal. Todo urgente.

## Restricciones

- Features no se pausan (presión de negocio).
- ~3 horas diarias disponibles para mejoras.
- Sprints semanales.
- GitHub Issues obligatorio; notificaciones por Google Workspace.
- Presupuesto aprobado: ~$200/mes.

## Estrategia

Dos ejes simultáneos:
1. **Proceso**: triage, delegación, accountability compartida → desconcentrar decisiones desde pangui.
2. **Técnico**: tests, CI, observabilidad → red de seguridad para delegar.

**Principio:** el proceso humano va primero. Las herramientas potencian un proceso que funciona; no arreglan uno roto.

## Sprints

- **S1** — Triage + PRs con deadline <48h + Sentry en Rails (prod+staging).
- **S2** — Capacitar solicitantes en uso de issues + CI (Rubocop, Bundle Audit, PR template) + Cursor para el equipo.
- **S3** — RSpec + 5 features críticas identificadas + tests autenticación + doc de 5-10 partes más consultadas.
- **S4** — Staging con aprobación del solicitante (48h) + tests de 2-3 paths core adicionales + retrospectiva mes 1.
- **S5–6** — Condicional: triage bot con IA + detección pre-merge (N+1, SQL injection) + coverage 25-30% + doc automática post-merge.
- **S7–8** — Reportes semanales automáticos + métricas de gestión + SLAs internos por severidad.
- **S9–12** — Consolidación. Líneas posibles: generadores CRUD/API, postmortem automation, coverage >30%, feature scaffolding e2e, propuesta Q2.

## Costos mensuales proyectados

```
Cursor:     $80  (4 licencias × $20)
Sentry:     $30
Claude API: $50-100
AWS Lambda: $5-10
Total:      ~$165-220/mes
```

## Métricas de seguimiento

- **Técnicas semanales:** coverage %, bugs reportados, PRs mergeados, hotfixes/mes, tiempo resolución por severidad.
- **De gestión semanales:** PRs sin revisar >48h, issues atascados en triage >48h, % resuelto sin escalamiento, distribución de carga.
- **De negocio mensuales:** features entregadas, features pendientes.

## Cómo uso esta memoria

- Cuando CCS pregunte por prioridades o decida qué asignar, anclar en el sprint actual y su meta.
- Los sprints 5-8 son **condicionales** — no asumir que se van a ejecutar si 1-4 no se estabilizan.
- Este roadmap es la prueba de que CCS quiere medir la intervención antes de expandirla; sugerir mejoras de forma coherente con esa cadencia.
