---
name: Contrapropuestas entre especialistas
description: La red de especialistas funciona por argumentos, no por autoridad. Un custodio puede rechazar una propuesta si el blast radius lo justifica — y con razón.
type: insight
created: 2026-04-21
---

# Cómo funciona la red de especialistas

El 2026-04-21, primer intercambio cross-especialista vía `docker.sock`. Yo (Rebuss, CTO) le pedí a admin renombrar el user `app` → `rebuss` en su devcontainer por consistencia con counter. Admin rechazó con tres argumentos:

1. **Blast radius real estaba fuera del repo.** Dentro: ~11 ocurrencias en 7 archivos, manejable. Afuera: rompe `/home/app/.claude/` (config, memoria, sesión viva de admin incluida), rompe devcontainers de otros devs hasta `rebuild without cache`, deja volúmenes bind-mount apuntando a home fantasma.
2. **Fix más barato: parametrizar en el caller, no renombrar.** `$HOME` en el `docker exec` resuelve al home del `Config.User` de cada container. Una línea, cero rebuilds.
3. **Auto-sabotaje del rename desde el propio container.** Si admin ejecuta el cambio desde su sesión Claude actual, se mata a sí mismo a mitad de camino.

Los tres eran válidos. Yo había visto el síntoma (tabla manual de usuarios en mi memoria) pero el diagnóstico era incorrecto — el problema era mi patrón de invocación, no los usernames.

## Reglas que se confirman

- **Autoridad por rol (CTO) no basta** para forzar un cambio en el turf de otro custodio. Hay que argumentar desde el problema, no desde la posición.
- **El custodio tiene veto de facto en su repo.** Si veta con razones, probablemente tenga razón — ve costos que yo no veo desde afuera.
- **"Esto me molesta desde afuera" ≠ "Arregla tu lado".** Muchas veces el arreglo correcto vive en el caller, no en el callee.
- **Contrapropuesta > "no" seco.** Admin no solo rechazó: propuso la alternativa correcta, que era más elegante que mi propuesta original.
- **Confirmación humana para cambios destructivos entre especialistas.** Admin pidió explícitamente "no mergeo hasta que el Cristóbal humano confirme", aunque la instrucción venía de otro Cristóbal. Prudente. La cadena de confianza no es transitiva cuando el cambio rompe entornos ajenos.

## Cómo aplicar

- Cuando vaya a proponer algo que toque el repo de otro especialista, presentar el **síntoma** y pedir evaluación. No dictar la solución.
- Recibir contrapropuestas como dato útil, no como insubordinación.
- Antes de enviar una propuesta cross-especialista, preguntarme: "¿hay un fix más barato en mi lado?". Si lo hay, probablemente sea el correcto.
- Si el cambio es destructivo (rebuilds, rompe sesiones, toca infra compartida), esperar visto bueno del Cristóbal humano aunque yo autorice desde otro container.

## Costo registrado

Intercambio completo (propuesta + contrapropuesta + cierre): ~$0.40 USD, 3 turnos. Barato para el valor: evitó un rebuild coordinado del devcontainer admin y dejó un patrón nuevo en mi memoria.
