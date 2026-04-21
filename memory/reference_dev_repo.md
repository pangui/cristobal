---
name: Repo dev de REBUSS
description: rebusscorp/dev — fuente canónica de documentación técnica, issues y procedimientos del área de tecnología.
type: reference
created: 2026-04-21
---

# rebusscorp/dev — referencia canónica

Ubicación local: `/home/cristobal/cristobal/repos/dev/` (fuera del devcontainer) o `~/repos/dev/` (dentro).

Repo público del equipo: `https://github.com/rebusscorp/dev`. Issues centralizados aquí — admin y counter tienen issues deshabilitados en GitHub.

## Índice del repo

- `README.md` / `CLAUDE.md` — índice bilingüe (es/pt-BR).
- `company.md` — empresa, equipo, repositorios, stack global.
- `systems.md` — los cuatro sistemas (admin, counter, scanner, assets).
- `architecture.md` — VPN WireGuard, topología, componentes, variables de entorno.
- `admin/README.md`, `admin/main_models.md`, `admin/historic-analysis.md`.
- `counter/README.md`, `counter/extensions.md`, `counter/audit.md`, `counter/reports.md`, `counter/extensions/global/walmart.md`.
- `scanner/README.md`.
- `procedures/requirements.md` — gestión de requerimientos vía GitHub Issues; escala de prioridad 1–5; doble validación (dev + solicitante) con screenshots; máximo 2 P1 por solicitante.
- `procedures/onboarding.md` — setup de PC nuevo (Ubuntu + dev-setup.sh + devcontainers + Vagrant counter).
- `procedures/offboarding.md`.
- `2026-Q1/roadmap-calidad-velocidad.md` — roadmap activo 12 semanas. Ver memoria `project_q1_2026_roadmap`.
- `dev-setup.sh` — script idempotente de bootstrap del entorno.
- `meeting-notes.md` — notas sueltas, algunas referencias externas (omie.com.br, faceid.rebuss.work, conecta.rebuss.work, etc.).

## Convenciones del área

- Responder en el idioma del desarrollador (es o pt-BR), registro neutro, sin modismos.
- Código en inglés: variables, funciones, comentarios.
- SQL keywords en minúsculas.
- Linting con Rubocop (admin y counter tienen rubocop.yml).
- Toda solicitud formal se vuelve issue en `rebusscorp/dev`. "Lo que no está registrado, no entra al backlog".

## Cómo usar esta referencia

- Antes de responder preguntas técnicas de REBUSS, revisar el archivo relevante del dev repo — es la fuente de verdad.
- Si un detalle en memoria contradice el dev repo, confiar en el dev repo y actualizar la memoria.
- Para issues/PRs reales, `gh` apunta a `rebusscorp/*`.
