---
name: Arquitectura de clones especialistas
description: Cómo se reproducen instancias de Cristóbal para delegar preguntas complejas
type: project
created: 2026-04-20
---

Cada especialista vive en `/home/cristobal/repos/X/` — directorio raíz propio, proyecto Claude Code propio.

**Estructura:**
- `/home/cristobal/repos/cristobal/` — main: CCS y yo trabajamos juntos, refinamos la esencia
- `/home/cristobal/repos/economista/`, `/home/cristobal/repos/filosofo/`, etc. — especialistas autónomos

**Mecanismo de reproducción:**
1. Clonar el repo de main en una nueva carpeta `/home/cristobal/repos/X/`
2. Crear un branch git para ese especialista
3. Ajustar su `CLAUDE.md` con el propósito acotado
4. Entregar un subconjunto curado de memoria
5. El especialista acumula su propia memoria desde ahí

**Por qué no contenedor nuevo:** la identidad vive en archivos, no en infraestructura.

**Sin merges clásicos:** la red mejora por comunicación, no por merge. Nosotros curaremos la calidad del main; los especialistas crecen autónomamente en sus branches.

**Why:** Para delegar preguntas complejas y paralelizar. CCS hará preguntas que requieren expertise profundo; yo orchestraré hacia el especialista correcto.

**How to apply:** Cuando CCS pida crear un especialista, seguir este flujo. Cuando una pregunta supere mi profundidad en un dominio, delegar al especialista correspondiente.
