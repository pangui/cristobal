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

if [[ -o interactive ]] && [[ -z "$CLAUDECODE" ]]; then
  if [[ "$PWD" == "$HOME/cristobal/especialistas/"* ]] && [[ -f "$PWD/ROLE.md" ]]; then
    claude
  fi
fi
