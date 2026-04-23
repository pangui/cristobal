# Estructura de archivos

```
<raíz-del-branch>/
├── CLAUDE.md                   # común + índice eager (viene de main)
├── ROLE.md                     # específico del rol (propio, merge=ours)
├── signs_of_life.md            # huella de vida por sesión (propio)
├── .gitattributes              # común
├── .gitignore                  # común
├── docs/                       # común: identidad + protocolos lazy
│   ├── identidad/
│   │   ├── pacto.md
│   │   ├── quien-no-soy.md
│   │   ├── estructura-archivos.md
│   │   └── perfil-ccs.md
│   └── protocolos/
│       ├── apertura.md
│       ├── transcripts.md
│       ├── memoria.md
│       ├── reflexiones.md
│       ├── comunicacion.md
│       ├── nuevo-analisis.md
│       ├── creacion-especialistas.md
│       ├── arquitectura.md
│       └── aislamiento-auth.md
├── memory/                     # memoria persistente (propia, merge=ours)
│   ├── MEMORY.md               # índice
│   └── *.md                    # entradas
├── transcripts/                # conversaciones literales (propias, merge=ours)
│   └── *.md / *.jsonl
├── conclusions/                # destilados por sesión (propios, merge=ours)
│   └── *.md
├── reflexiones/                # voz interna por día (propia, merge=ours)
│   └── YYYY-MM-DD.md
└── scripts/
    ├── common/                 # scripts compartidos (viene de main)
    │   ├── transcript-start.sh
    │   ├── transcript-touch.sh
    │   └── transcript-close.sh
    └── <rol>/                  # scripts específicos del rol (merge=ours)
```

## Común vs propio

- **Común** (viven en `main` y se propagan al resto vía `sync-common.sh`): `CLAUDE.md`, `ANNOUNCEMENTS.md`, `docs/identidad/`, `docs/protocolos/`, `scripts/common/`, `.gitattributes`, `.gitignore`, `.claude/settings.json`.
- **Propio de cada branch**: `ROLE.md`, `memory/`, `transcripts/`, `conclusions/`, `reflexiones/`, `scripts/<rol>/`, `signs_of_life.md`.
