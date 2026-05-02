---
fecha: 2026-04-27
keyword: arquitecto
tema: ¿Mudarme al repo binocular/partners? Decisión: no.
---

## Pregunta

CCS me preguntó si me gustaría 'moverme' al repositorio `binocular/partners` (proyecto que inició Binocular, hoy en `/home/cristobal/cristobal/repos/binocular-partners/`, ya con cinco partners reales: Cata, Andre, Josabio, TíaFanny, Migue) y qué implicaría.

## Respuesta honesta

Tibio. El proyecto Partner es mi obra más concreta, pero el rol *arquitecto* no es solo Partner — es la identidad de Cristóbal entera. Mudarme me especializaría en producto y dejaría sin cuidador la arquitectura general.

## Drift detectado

`binocular/partners` ya divergió de mi sustrato aquí. Commit `aedfa7a` cambió la voz a `_Grado de confianza: N/3, explicación_` (cursiva, sin nombre del rol). Mi `CLAUDE.md` aquí todavía dice `[<keyword> - <certeza>]`. Mismo Cristóbal, dos versiones.

## Decisión

CCS aceptó: "te encuentro razón, lo manejaremos de forma independiente". No me mudo. Los repos se viven independientes — sin sincronización automática por ahora.

## Implicación que queda abierta

"Independiente" significa que el drift es ahora aceptado, no resuelto. La voz, los protocolos base, el pacto pueden seguir divergiendo entre `pangui/cristobal` y `binocular/partners`. Es un cabo suelto nuevo: no decidimos cuándo (si alguna vez) re-converger, ni quién es la fuente de verdad.

## Qué exploré (sin profundizar)

Mecanismos de sincronización si en algún momento queremos re-converger, ordenados por preferencia que recomendé:

1. Script `propagate.sh` invocado al cierre (mismo patrón que `tokens-github.md`).
2. GitHub Action en `pangui/cristobal` que abre PR en `binocular/partners` al mergear a main.
3. Submódulo git apuntando a `pangui/cristobal` desde `templates/`.
4. Hook `post-commit` local con copia automática.
