if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

VISUAL=nvim
EDITOR=nvim

path=(
  '/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin'
  /Applications/Postgres.app/Contents/Versions/latest/bin
  $path
)

function take() {
  mkdir -p $@ && cd ${@:$#}
}

function rip() {
  echo OUTPUTFORMAT=\'${1:-CD}'/${TRACKNUM}.${TRACKFILE}'\' >! ~/.abcde.conf
  abcde -N -n -x -o mp3
}

funclion up() {
  sudo softwareupdate -i -a
  brew update
  brew upgrade
  brew cleanup
  zprezto-update
}

alias c='code $PWD'
alias cat="bat"
alias difff="kitty +kitten diff"
alias ls="eza -al --color=always --group-directories-first --icons=auto"
alias lt="eza -aT --color=always --group-directories-first --icons=auto" # tree listing
alias l="ls"
alias lg="lazygit"
alias log="tail -f log/development.log"
alias n="nvim"
alias ping="prettyping"
alias rorb='b https://$(basename $PWD).test'
alias top="btop"
alias work="nvim $HOME/Library/Mobile\ Documents/com~apple~CloudDocs/Sofuto/work.md"

# fzf
source <(fzf --zsh)
export FZF_DEFAULT_OPTS=" \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

# zoxide
eval "$(zoxide init zsh --cmd j)"

# Java
if (( $+commands[brew] )); then
  export JAVA_HOME="$(brew --prefix openjdk)"
  export PATH="$(brew --prefix openjdk)/bin:$PATH"
fi

# Mise
eval "$(mise activate zsh --shims)"

# OrbStack
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Oh My Posh
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config ~/.prompt.omp.json)"
fi

# For secret env vars etc.
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
