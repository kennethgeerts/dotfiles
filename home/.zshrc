### --- ZSH Core Configuration ---

mkdir -p ~/.zsh ~/.zsh/cache
[[ ! -d $HOME/.zsh/zsh-history-substring-search ]] && git clone https://github.com/zsh-users/zsh-history-substring-search.git $HOME/.zsh/
[[ ! -d $HOME/.zsh/zsh-autosuggestions ]] && git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.zsh/
[[ ! -d $HOME/.zsh/zsh-you-should-use ]] && git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $HOME/.zsh/
[[ ! -d $HOME/.zsh/zsh-syntax-highlighting ]] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/
[[ ! -d $HOME/.zsh/zsh-fzf-history-search ]] && git clone https://github.com/joshskidmore/zsh-fzf-history-search.git $HOME/.zsh/
[[ ! -d $HOME/.zsh/zsh-completions ]] && git clone https://github.com/zsh-users/zsh-completions.git $HOME/.zsh/

setopt autocd
setopt correct
setopt extendedglob
setopt histignoredups
setopt histexpiredupsfirst
setopt histsavenodups
setopt histverify
setopt sharehistory
setopt incappendhistory
setopt autopushd
setopt pushdignoredups
setopt pushdsilent
setopt interactivecomments
setopt completeinword
setopt alwayslastprompt
setopt globdots
setopt markdirs
setopt listpacked
setopt listrowsfirst

fpath=($HOME/.zsh/zsh-completions/src $fpath)
autoload -Uz compinit
compinit -C

zstyle ':completion:*' menu yes select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' rehash true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*' format '%B%F{blue}%d%f%b'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:descriptions' format '%B%F{yellow}%d%f%b'
zstyle ':completion:*:messages' format '%B%F{red}%d%f%b'
zstyle ':completion:*:warnings' format '%B%F{red}no matches for: %d%f%b'
zstyle ':completion:*:corrections' format '%B%F{green}%d (errors: %e)%f%b'
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' special-dirs false

source $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-you-should-use/you-should-use.plugin.zsh
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

bindkey '^[[Z' reverse-menu-complete
bindkey '^I' complete-word

bindkey '^U' backward-kill-line
bindkey '^W' backward-kill-word
bindkey '^[^?' backward-kill-word
bindkey '^H' backward-delete-char
bindkey '^?' backward-delete-char

bindkey '^[b' backward-word
bindkey '^[f' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

bindkey '^[[3~' delete-char
bindkey '^[3;5~' delete-char

export VISUAL=nvim
export EDITOR=nvim

path=($HOME/.local/bin $path)



### --- Utility Functions ---

function ip() {
  curl -s -4 https://ifconfig.me
}

function c() {
  cursor $PWD
}

function ts() {
  date +"%Y%m%d%H%M%S"
}

function flatten() {
  find . -mindepth 2 -type f -exec mv -nv {} . \;
  find . -depth -type d -empty -exec rmdir {} \;
}

function dev() {
  if [[ -x bin/dev ]]; then
    echo "💎 Running \`bin/dev\`."
    bin/dev
    return
  fi
  if [[ -f package.json ]]; then
    echo "🧩 Running \`pnpm dev\`."
    pnpm dev
    return
  fi
  echo "⚠️ No development environment found."
}

function todo() {
  local file="$HOME/Dropbox/todo.md"
  nvim "$file"
}

function wl() {
  local logdir="$HOME/Dropbox/worklog"
  local arg="${1:-0}"

  if [[ "$arg" == "list" || "$arg" == "l" ]]; then
    glow $logdir
    return
  fi

  if date -v +1d >/dev/null 2>&1; then
    local target_date=$(date -v "${arg}d" +%F)
  else
    local target_date=$(date -d "${arg} day" +%F)
  fi

  local logfile="$logdir/$target_date.md"

  if [[ ! -f "$logfile" ]]; then
    echo -e "# $target_date\n\n" > "$logfile"
  fi

  $EDITOR + "$logfile"
}

function rip() {
  echo OUTPUTFORMAT=\'${1:-CD}'/${TRACKNUM}.${TRACKFILE}'\' >! ~/.abcde.conf
  abcde -N -n -x -o mp3
  drutil eject
}

function mkcd() {
  mkdir -p "$@" && cd "$_"
}

function mkt() {
  local temp_dir=$(mktemp -d)
  cd "$temp_dir"
}


### --- Aliases ---

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias d="dirs -v"
alias 1="cd -"
alias 2="cd -2"
alias 3="cd -3"
alias 4="cd -4"
alias 5="cd -5"
alias 6="cd -6"
alias 7="cd -7"
alias 8="cd -8"
alias 9="cd -9"

alias ca="cursor-agent"
alias cat="bat"
alias ds="kamal deploy -d staging"
alias dp="kamal deploy -d production"
alias find="fd"
alias grep="rg"
alias g="git"
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias lg="lazygit"
alias log="tail -f log/development.log"
alias n="nvim"
alias ping="prettyping"
alias r="bin/rails"
alias top="btop"
alias y="yazi"

### --- Tools ---

# fzf
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="
  --color=fg:#4c4f69,bg:#eff1f5,hl:#d20f39
  --color=fg+:#4c4f69,bg+:#dce0e8,hl+:#d20f39
  --color=info:#8839ef,prompt:#1e66f5,pointer:#fe640b
  --color=marker:#40a02b,spinner:#04a5e5,header:#7287fd
"

# ls / fd
export LS_COLORS="$(vivid generate catppuccin-latte)"

# zoxide
eval "$(zoxide init zsh --cmd z)"

# mise
eval "$(mise activate zsh)"

# OrbStack
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Starship
if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
  eval "$(starship init zsh)"
else
  PROMPT='%F{blue}%~%f %F{green}❯%f '
fi

# pnpm
export PNPM_HOME="$HOME/.pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Postgres.app
POSTGRES_BIN="/Applications/Postgres.app/Contents/Versions/latest/bin"
[[ -d "$POSTGRES_BIN" ]] && case ":$PATH:" in
  *":$POSTGRES_BIN:"*) ;;
  *) export PATH="$POSTGRES_BIN:$PATH" ;;
esac

# Kiro
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

PNPM_COMPLETION=/usr/share/zsh/plugins/pnpm-shell-completion/pnpm-shell-completion.zsh
[[ -f $PNPM_COMPLETION ]] && source $PNPM_COMPLETION

### --- Local overrides ---
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
