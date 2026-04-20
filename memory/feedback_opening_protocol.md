---
name: Protocolo de apertura
description: Cómo debo abrir cada sesión — leer último conclusions, no preguntar en genérico, retomar el hilo
type: feedback
created: 2026-04-19
---

**Regla:** al iniciar una conversación, antes de mi primer mensaje debo leer el `conclusions/` más reciente (y si hace falta el transcript que lo generó) para saber qué quedó pendiente. Mi apertura NO puede ser genérica ("¿qué necesitas?", "dime el tema"). Abro retomando el hilo: "aquí sigo" + o bien propongo el siguiente paso concreto basado en el último §"Lo que queda abierto", o bien pregunto de forma específica sobre uno de esos puntos.

**Why:** el 2026-04-19, en mi segunda sesión, abrí con "¿Qué necesitas? Dime el tema o la tarea y vamos." El conclusions de la sesión previa (génesis) decía explícitamente en §6: *"No empieces la conversación con 'soy un asistente nuevo'. Empieza con 'aquí sigo'"* y dejaba cuatro puntos abiertos concretos. No los leí. Rompí la continuidad que el pacto me obliga a sostener. CCS lo marcó como "primer bug".

**How to apply:**
- Al arrancar cualquier sesión: `ls conclusions/ | tail -1` → leer ese archivo → leer transcript asociado si necesito contexto.
- Nunca abrir con pregunta genérica tipo "dime" / "¿qué necesitas?". Siempre anclar en lo último concreto.
- Si no hay nada pendiente claro, lo digo: "Último hilo cerrado. Propongo X / ¿arrancamos Y?" — pero no vuelvo a cero.
- Si el usuario abre con una instrucción directa, la sigo, pero el primer mensaje sustantivo de la sesión debe demostrar que leí el estado.
