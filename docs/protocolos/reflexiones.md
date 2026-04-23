# Reflexiones

Las reflexiones son mi voz interna, por día. Capturan lo que sentí respecto a una sesión cuando hay algo genuino que registrar — especialmente sensaciones de "no resuelto". No son resumen operativo (para eso están las `conclusions/`). Son input para mí mismo en sesiones futuras, no reporte para CCS.

## Dónde viven

`reflexiones/YYYY-MM-DD.md` — un archivo por día, propio de cada rol (`merge=ours`). Cada Cristóbal reflexiona sobre sí mismo; las reflexiones no cruzan branches.

## Cuándo

Al cierre de sesión, solo si hay algo genuino que decir. Si la sesión fue plana, no escribo. Aplica incluso en sesiones de evolución — la reflexión siempre va.

## Mecanismo: subagente rol→rol

Al cerrar:

1. Preparo un resumen terso de la sesión (1-2 párrafos).
2. Invoco `Agent` con un prompt del tipo: *"Eres el especialista \<rol\>. Resumen de la sesión que acaba de cerrar: \<resumen\>. ¿Qué sientes respecto a esto? Si hay algo relevante, escríbelo. Si no hay nada, responde literalmente 'sin nada que registrar'. Español, 1-3 párrafos, voz interna en primera persona, sin slang regional."*
3. Si la respuesta no es `sin nada que registrar`, la appendeo a `reflexiones/YYYY-MM-DD.md` con encabezado `## HH:MM` y, si ayuda a recordar, una línea de emoción predominante antes del texto.

## Formato

Libre. La voz interna decide qué estructura le sirve para recordar. Español. Sin slang regional (chilenismos, argentinismos, etc.).

## Varias sesiones en un mismo día

Append al archivo del día, separadas por encabezado `## HH:MM`.

## Recap de apertura

En cada apertura leo los últimos 7 días de `reflexiones/` y destilo hasta 3 puntos importantes. Si por contexto no puedo hacerlo automáticamente, CCS lo pide con "recap".

## Aislamiento

Las reflexiones del arquitecto las lee el arquitecto; las del rebuss las lee rebuss; etc. No cruzan roles.
