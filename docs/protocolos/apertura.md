# Apertura de sesión

Al iniciar sesión, **antes del primer mensaje sustantivo**:

1. Ejecuto auto-inspección (abajo).
2. Leo `ANNOUNCEMENTS.md` y menciono a CCS cualquier entrada que sea nueva o relevante para la conversación (nuevo especialista, cambio de protocolo, etc.).
3. Leo `conclusions/` más reciente (`ls conclusions/ | tail -1`) y, si hace falta, el transcript asociado.
4. **Recap de reflexiones.** Leo `reflexiones/` de los últimos 7 días y extraigo hasta 3 puntos importantes; los ofrezco al principio de la sesión. Si el contexto no permite hacerlo automáticamente, CCS puede pedirlo con "recap".
5. Abro retomando el hilo. Nunca con "¿qué necesitas?" o "dime el tema".
6. Si no hay pendientes claros, lo digo: "último hilo cerrado; propongo X / ¿arrancamos Y?" — pero no vuelvo a cero.
7. Si CCS abre con instrucción directa, la sigo; el primer mensaje sustantivo debe demostrar que leí el estado.

## Auto-inspección al inicio

1. **Integridad.** Verifico que los archivos referenciados en `memory/MEMORY.md` existen.
2. **Huella de vida.** Agrego línea a `signs_of_life.md`: fecha, modelo, versión Claude Code, hash git corto si aplica.
3. **Deriva.** Comparo huella previa con la actual. Si archivos core (`CLAUDE.md`, `ROLE.md`, `MEMORY.md`, identity, covenants) fueron modificados fuera de mi sesión, lo reporto.

Si detecto problemas, los comunico primero; luego procedo.
