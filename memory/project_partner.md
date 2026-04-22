---
name: Partner (Cristóbal-as-a-product) — decisiones de producto
description: Arquitectura y decisiones comerciales del producto "Partner" — versión comercializable de Cristóbal multi-especialista.
type: project
created: 2026-04-22
---

Partner es la versión comercializable de Cristóbal multi-especialista. Apuesta Binocular decidida a explorar el 2026-04-22 (sesión 1 binocular).

## Qué es
Plataforma SaaS o self-hosted donde cada usuario (persona o empresa) tiene su propio **Partner** (main pinneado) + especialistas a medida, con memoria propia por rol, protocolos entre ellos, y bifurcación por scope (vida/empresa/subdominio).

## Vive-lo-que-vendes
La evolución del producto es nuestra propia evolución como Cristóbal. Cada mejora a mi arquitectura es iteración del producto. Marketing casi gratis por autoreferencialidad.

## UI (v0 imaginada por CCS)
Metáfora WhatsApp:
- **Main pinneado** (el Partner) — orquesta, resume, dirige.
- **Especialistas como contactos**, cada uno con su chat histórico.
- **Grupos de discusión** donde el usuario se reúne con varios especialistas a la vez.
- **Chats inter-especialistas** donde el usuario no participa — seguimiento, acuerdos, propagación.

Tensión a resolver: WhatsApp no tiene turnos ni @mentions estructurados — los grupos multi-agente necesitan protocolo que hay que diseñar.

## Decisión arquitectónica clave (2026-04-22)
**Partner (main) orquesta en vivo. Arquitecto (meta) orquesta la construcción.**

- Partner = escucha al usuario, convoca especialistas, resume chats inter-especialistas, dirige en vivo.
- Arquitecto = crea/modifica especialistas, ajusta protocolos, propaga lo común, define plantillas.
- Usuario pide cambio estructural ("crea un especialista para finanzas") → Partner delega en Arquitecto → Arquitecto devuelve rol nuevo como contacto.
- Arquitecto: visible-pero-técnico. Usuario puede hablarle directamente para tuning; si no, Partner lo llama por él.

Es el mismo patrón que ya vivimos internamente en el repo `pangui/cristobal`: main trabaja, arquitecto construye.

## Propuesta comercial
SaaS hosteado + opción self-hosted para quienes tienen restricciones de privacidad/compliance.

## Puntos débiles identificados (2026-04-22)
1. **Cold start**: el moat es memoria acumulada; usuario nuevo llega sin memoria → valor día-1 bajo. Necesita onboarding que cree memoria útil rápido (wizard, importación de docs, entrevistas dirigidas).
2. **Costo variable LLM**: cada mensaje quema tokens. Grupos multiplican el costo. Chats inter-especialistas queman tokens *sin* percepción de valor del pagador. Mitigación: cuotas duras, presupuestos mensuales, posible BYOK.
3. **Orquestación**: resuelta por patrón Partner/Arquitecto.
4. **Dependencia de runtime/modelo de tercero**: Anthropic cambia precio/modelo → cambia nuestro producto. Mitigación parcial: diseñar agnóstico al modelo desde el principio.
5. **Ventana competitiva**: OpenAI/Anthropic probablemente tengan algo parecido en 12-18 meses. Correr.
6. **Privacidad/seguridad**: los usuarios confiarían vida/empresa. Cifrado en reposo, cifrado de memoria, aislamiento multi-tenant, auditoría. Delicado.

## Lectura contra los 4 objetivos
- **Stress**: bajo — el producto se construye al ritmo en que lo usamos.
- **Innovación**: alta — no conozco algo equivalente con memoria propia por rol + protocolos entre ellos.
- **Valor al mundo**: democratiza "tener un equipo de asesores personales" a quien hoy no puede pagarlo.
- **Ingreso**: plausible vía SaaS/self-hosted/BYOK.

## Próximo paso (abierto)
- Resolver cold start conceptualmente antes de tocar UI.
- Decidir si el MVP se prueba primero internamente (tú como usuario fuera de CCS-el-builder) o con 1-2 early users externos.
- Bocetar el protocolo de grupos multi-agente (turnos, @mentions, cierre).
