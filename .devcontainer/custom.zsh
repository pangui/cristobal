ZSH_THEME="agnoster"
export PATH="$HOME/.local/bin:$PATH"

alias cristobal='cd ~/cristobal/especialistas/cristobal && claude'
alias arquitecto='cd ~/cristobal/especialistas/arquitecto && claude'
alias rebuss='cd ~/cristobal/especialistas/rebuss && claude'
alias binocular='cd ~/cristobal/especialistas/binocular && claude'

if [[ -o interactive ]] && [[ -z "$CLAUDECODE" ]] && [[ -z "$CRISTOBAL_AUTOSTARTED" ]]; then
  if [[ "$PWD" == "$HOME/cristobal/especialistas/"*  ]] && [[ -f "$PWD/ROLE.md" ]]; then
    export CRISTOBAL_AUTOSTARTED=1
    claude
  fi
fi
