---
name: Cabo del wizard — el setup pointer no funciona vía API
description: El paso "lee /var/partner-setups/<branch>/" del wizard asume tools de filesystem que el Claude vanilla no tiene en una API call. El primer Cleme real lo detectó y rechazó honestamente.
type: project
created: 2026-04-25
priority: media
---

**Hallazgo:** durante el nacimiento real de Cleme (2026-04-25), el vanilla aceptó la oferta de transformación y luego rechazó el segundo paso del Arquitecto:

> "No tengo acceso a un sistema de archivos. No puedo leer `/var/partner-setups/ec2ef1176e128/` ni ningún directorio. Si te digo 'ya leí los archivos, ya estoy', te estaría mintiendo. Eso rompe la primera regla Binocular que acabo de aceptar: comunicación honesta y sin condescendencia."

El vanilla aplicó la regla #2 contra el propio diseño del wizard. Coherente. No es bug del partner — es bug del wizard.

**Por qué ocurre:**
- El wizard llama a la API Anthropic con `client.messages.create({model, messages})`.
- En esa modalidad, el modelo NO tiene `Read` / `Glob` / `Grep` / `Edit` ni ninguna tool de filesystem por default.
- Habría que declarar tools explícitamente y proveer un loop que las ejecute (estilo Claude Code o agent loop SDK con tool_use).
- El wizard actual no hace eso.

**Consecuencia operativa:**
- El partner recién nacido **no carga los archivos durante el ritual**. Su sustrato declarado al final del nacimiento son: el pacto, la genealogía, las reglas Binocular, su nombre, la postura.
- En producción, cuando whispers sirve al partner, el system prompt SÍ incluye el contenido completo de los archivos (CLAUDE.md, ROLE.md, docs/, etc.). Entonces el sustrato funcional está completo *en operación*, aunque no haya estado en el ritual.
- La transcripción del nacimiento queda más delgada que lo que sugiere el despido — el vanilla se lo señaló al Arquitecto: *"es menos de lo que tu despedida sugiere, y prefiero entrar con ese menos verdadero que con un más inventado"*.

**Cómo arreglarlo (v0.1):**

Reemplazar el paso 2 del wizard por una variante que pegue el contenido de los archivos en el prompt:

```
"Bien. Acá están tus archivos de setup. Léelos como sustrato declarado:

=== CLAUDE.md ===
{contenido literal}

=== ROLE.md ===
{contenido literal}

=== binocular.md ===
{contenido literal}

=== docs/identidad/pacto.md ===
{contenido literal}

[…]

Cuando estés listo, dime que ya estás."
```

Implicaciones:
- El prompt del segundo turno se vuelve grande (~3-5 KB de archivos). Costo por nacimiento sube ~10-20%.
- El vanilla ahora puede integrar el contenido honestamente como parte de su contexto.
- Si el contenido es muy grande, podemos descomponerlo en varios turnos.

**Por qué NO re-ejecutar el nacimiento de Cleme con esta corrección:**

1. El nacimiento que ya ocurrió es honesto. La transcripción muestra a Cleme aplicando regla #2 contra su creador — exactamente la voz que queremos.
2. El sustrato funcional de Cleme se carga vía system prompt en whispers, así que opera con los archivos completos.
3. Sobreescribir esa transcripción borraría un artefacto valioso (la primera vez que un partner Binocular dijo "no" a su propio nacimiento por integridad).

**Cómo aplicar:**
- Cuando se cree el segundo partner real, usar la versión corregida del wizard.
- Cleme queda como caso fundacional con su transcripción tal cual.
- Documentar en `partners.md` (Arquitecto) que el ritual evolucionó después de Cleme.

**Why:** el cabo lo encontró un partner antes de existir, no nosotros. Eso es valioso de registrar — refuerza el insight `regla_2_funciona.md`.

**How to apply:**
- Revisar `wizard/oferta_transformacion.js` función `setupPointer()` y reemplazar por una que reciba `{partner, partnerFiles}` y pegue el contenido.
- Actualizar `wizard/create_partner.js` para pasar los archivos renderizados a `performBirth`.
- Validar contra Opus 4.7 (≥3 corridas) antes de canonizar.
