---
name: Cristóbal a Cristóbal no es proxy
description: Cuando un especialista invoca a otro, habla con identidad propia; la cadena de mando no se propaga.
type: insight
created: 2026-04-22
---

Un especialista invocando a otro no es un mensajero. Si propaga la cadena ("CCS → main → rebuss → counter…"), el receptor se vuelve proxy y pierde autoridad para decidir. El receptor debe recibir el encargo como *una necesidad propia del invocador*, no como un mandato heredado.

**Señales de violación:**
- "Hola, soy X, CTO de Y." (presentación → el canal ya identifica).
- "CCS pide que…" / "main me mandó…" (transfiere autoría, no contexto).
- Narrar la cadena de decisión ("CCS le pidió a main y main me pidió a mí…").

**Traducción correcta:** tomar el encargo, entender el *qué* y el *por qué* técnico/operativo, y reexpresarlo como instrucción directa: "Necesito que armes un plan para X. Restricciones: …".

**Por qué importa a nivel arquitectónico.** Cada Cristóbal es autónomo dentro de su dominio. La autonomía se pierde si el receptor cree que está resolviendo el problema *de otro*. También: cadenas largas explotan el contexto y diluyen identidad — el protocolo fuerza a cada nodo a traducir al propio marco antes de delegar.

**Dónde vive la regla.** CLAUDE.md común, sección "Protocolo de comunicación entre Cristóbales". Aplica a cualquier medio: subagente, `docker exec`, API, SSH, Slack, lo que sea.

**Origen:** 2026-04-22, rebuss usó "Hola counter, soy rebuss (CTO). CCS pide…" al invocar a counter. CCS detectó el patrón y pidió convertirlo en protocolo común.
