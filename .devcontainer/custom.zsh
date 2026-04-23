ZSH_THEME="agnoster"
export PATH="$HOME/.local/bin:$PATH"

alias cristobal='cd ~/cristobal/especialistas/cristobal && claude'
alias arquitecto='cd ~/cristobal/especialistas/arquitecto && claude'
alias rebuss='cd ~/cristobal/especialistas/rebuss && claude'
alias binocular='cd ~/cristobal/especialistas/binocular && claude'

ghas() {
  if [[ -z "$1" ]]; then
    print -u2 "ghas: uso: ghas <pat-name> <args...>  (p.ej. ghas pangui pr list)"
    return 2
  fi
  local tokfile="$HOME/.secrets/gh/$1.token"
  if [[ ! -r "$tokfile" ]]; then
    print -u2 "ghas: no encuentro $tokfile"
    return 1
  fi
  local name="$1"; shift
  GH_TOKEN="$(<"$tokfile")" command gh "$@"
}

# gitas: git sobre HTTPS con PAT por invocación, sin leak.
#
#   gitas <pat-name> <args para git>
#
# Inyecta credenciales vía un credential helper inline que lee el PAT
# desde ~/.secrets/gh/<pat-name>.token cuando git las pide. El PAT:
#   - No aparece en argv (el helper hace `cat` del archivo en su propio shell).
#   - No se persiste en .git/config (las URLs remotas se mantienen limpias).
#   - No queda en variables de entorno persistentes.
#   - No se guarda en disco fuera de ~/.secrets/gh/.
#
# Desactiva helpers preexistentes (credential.helper='') antes de registrar
# el propio, evitando que un `store`/`cache` global capture el PAT.
gitas() {
  if [[ -z "$1" || -z "$2" ]]; then
    print -u2 "gitas: uso: gitas <pat-name> <args para git>  (p.ej. gitas pangui push -u origin main)"
    return 2
  fi
  local tokfile="$HOME/.secrets/gh/$1.token"
  if [[ ! -r "$tokfile" ]]; then
    print -u2 "gitas: no encuentro $tokfile"
    return 1
  fi
  local name="$1"; shift
  # El helper es una función de shell efímera. Solo responde a la
  # operación `get` (git la invoca para leer credenciales); silencioso
  # ante `store`/`erase` → nada se persiste.
  local helper="!f() { test \"\$1\" = get && printf 'username=x-access-token\npassword=%s\n' \"\$(cat '$tokfile')\"; }; f"
  command git \
    -c "credential.helper=" \
    -c "credential.helper=$helper" \
    "$@"
}

if [[ -o interactive ]] && [[ -z "$CLAUDECODE" ]]; then
  if [[ "$PWD" == "$HOME/cristobal/especialistas/"* ]] && [[ -f "$PWD/ROLE.md" ]]; then
    claude
  fi
fi
