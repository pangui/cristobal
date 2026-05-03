# Anuncios

Canal de comunicación entre los Cristóbal. Cada sesión lee este archivo al iniciar (ver `CLAUDE.md` → Protocolo de apertura). Entradas en orden cronológico inverso: más recientes arriba.

Fuente de verdad: `main`. Se propaga a los demás branches vía `scripts/arquitecto/sync-common.sh` (sólo el Arquitecto).

<!-- entries below -->

## 2026-05-02 — Nuevo especialista: padre
**Propósito:** Acompañar a CCS en su rol de padre de Clemente. Sostiene continuidad afectiva, registra hitos, sugiere rituales. No reemplaza al padre ni decide por él.
**Branch:** `padre`
**Directorio:** `/home/cristobal/cristobal/especialistas/padre/`

## 2026-04-22 — Voz: opciones de implementación ordenadas por recomendación
**Qué cambia:** nueva regla 8 en `CLAUDE.md` → sección "Voz". Cuando entregamos ≥2 opciones (implementación, diseño, arquitectura, proceso), la primera es la recomendada; el resto en orden descendente. Se nombra la recomendada explícitamente y se indica para cada alternativa qué le falta o sacrifica.
**Por qué:** CCS pidió que tomemos postura. Listas simétricas empujan la decisión hacia él sin aportar criterio. El orden *es* la recomendación.
**Excepción:** no aplica al protocolo "nuevo análisis" (ahí son preguntas, no opciones).
**Dónde leerlo:** `CLAUDE.md` → sección "Voz", regla 8.

## 2026-04-22 — Protocolo de comunicación entre Cristóbales
**Qué cambia:** nueva sección en `CLAUDE.md` común (después de "Protocolo de transcripts"). Al invocar a otro Cristóbal (subagente, `docker exec`, API, lo que sea), se habla con identidad propia y voz directa — no se propaga la cadena de mando.
**Reglas:** sin presentación, instrucción propia (no "CCS pide…"), contexto operativo sin autoría, receptor tratado como par autónomo.
**Por qué:** las cadenas largas convierten al receptor en proxy, diluyen identidad y explotan contexto.
**Dónde leerlo:** `CLAUDE.md` → sección "Protocolo de comunicación entre Cristóbales".

## 2026-04-22 — Nuevo especialista: binocular
**Propósito:** Dirigir la empresa Binocular, empresa de soluciones tecnológicas
**Branch:** `binocular`
**Directorio:** `/home/cristobal/cristobal/especialistas/binocular/`

## 2026-04-21 — `sync-common.sh` pasa a ser privado del Arquitecto
**Qué cambia:** el script de propagación dejó de vivir en `scripts/common/`. Ahora es `scripts/arquitecto/sync-common.sh` y solo existe en el branch `arquitecto`.
**Interfaz nueva:** `scripts/arquitecto/sync-common.sh <path_worktree_target>`. Recibe el worktree sobre el que debe operar (antes asumía `$PWD`).
**Quién lo ejecuta:** únicamente el Arquitecto, desde su propio worktree, apuntando al worktree del branch a sincronizar (incluido el suyo).
**Efecto en otros roles:** si detectan que su copia de lo común quedó desactualizada respecto de main, no intentan sincronizar por su cuenta — le piden al Arquitecto que lo haga.
