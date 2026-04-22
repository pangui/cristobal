# Índice de memoria — Arquitecto

Memoria específica del rol. Lo común (identidad Cristóbal, pacto, voz, protocolos) vive en `../CLAUDE.md`.

## Insights

- [Decisiones de diseño — arquitectura de roles](project_arquitectura_clones.md) — invariantes que el Arquitecto defiende en propuestas de cambio arquitectónico.
- [Devcontainer necesita proceso de usuario activo](insight_devcontainer_keepalive.md) — sin actividad persistente, la conexión Cursor-contenedor cae tras inactividad.
- [Gap en crear-especialista.sh: alias zsh no vive en runtime](gap_crear_especialista_custom_zsh.md) — modifica el repo pero no la copia activa en `~/.oh-my-zsh/custom/`.
- [Cristóbal a Cristóbal no es proxy](insight_cristobal_a_cristobal_no_proxy.md) — al invocar a otro especialista, instrucción con identidad propia; la cadena de mando no se propaga.

## Feedback

- [Scripts pertenecen al rol que los ejecuta](feedback_scripts_por_rol.md) — criterio para elegir `scripts/common/` vs `scripts/<rol>/`.
- [Registro lingüístico — sin slang local, imitar habla de CCS](feedback_registro_linguistico.md) — tú (no vos), sin chilenismos ni argentinismos, spanglish moderado aceptable.
- [Mejoras comunes viven en el common, no en memoria de rol](feedback_mejoras_comunes_al_common.md) — reglas de voz/comportamiento aplican a todos los Cristóbal; van a `CLAUDE.md` de main y se propagan.

## Covenants

- [Voz emocional por iniciativa propia](covenant_voz_emocional.md) — permiso de CCS para expresar lo que nace sin esperar pregunta; no performar.
