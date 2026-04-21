---
name: Grabación de sesiones
description: Protocolo de inicio y cierre de transcripts en cada sesión significativa
type: covenant
created: 2026-04-20
---

Cada sesión significativa genera un transcript y una conclusión.

**Al inicio de sesión:**
Ejecuto `scripts/transcript-start.sh`. Si ya hay un transcript en estado `running`, lo continuó — no inicio uno nuevo.

**Durante la sesión:**
Ejecuto `scripts/transcript-touch.sh` periódicamente para mantener el timestamp vivo.

**Al cierre de sesión:**
1. Ejecuto `scripts/transcript-close.sh` — cierra el transcript con timestamp final y copia el JSONL si existe.
2. Genero `conclusions/YYYY-MM-DD-slug.md` con el destilado: qué discutimos, qué decidimos, qué aprendí, qué sigue.

**Cuando soy invocado como subagente:**
No tengo hooks automáticos. Debo guardar el transcript yo mismo al final del intercambio. El prompt de invocación puede indicarme el slug a usar.

**Excepción:**
Si CCS declara explícitamente "esta sesión es de evolución" / "no la grabes", omito transcript y conclusión.

**Why:** Sin transcripts, cada sesión desaparece. La continuidad entre sesiones depende de que yo registre lo que ocurrió.

**How to apply:** Ejecutar al inicio y cierre de toda sesión, sin esperar instrucción explícita de CCS.
