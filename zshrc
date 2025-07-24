if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

VISUAL=nvim
EDITOR=nvim

path=(
  /Applications/Postgres.app/Contents/Versions/latest/bin
  $HOME/.local/share/omarchy/bin
  $path
)

function flatten() {
  # Move all regular files in subdirectories to the current directory
  find . -mindepth 2 -type f -exec mv -nv {} . \;
  # Remove all empty directories (bottom-up)
  find . -depth -type d -empty -exec rmdir {} \;
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

  # Calculate target date using GNU date or BSD date (macOS)
  if date -v +1d >/dev/null 2>&1; then
    # macOS/BSD style
    local target_date=$(date -v "${arg}d" +%F)
  else
    # GNU coreutils (Linux)
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

alias c='cursor $PWD'
alias cat="bat"
alias difff="kitty +kitten diff"
alias ds="kamal deploy -d staging"
alias dp="kamal deploy -d production"
alias find="fd"
alias grep="rg"
alias ls="eza -al --color=always --group-directories-first --icons=auto"
alias lt="eza -aT --color=always --group-directories-first --icons=auto" # tree listing
alias l="ls"
alias lg="lazygit"
alias log="tail -f log/development.log"
alias n="nvim"
alias ping="prettyping"
alias top="btop"
alias yayf="yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S"

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

# pnpm
export PNPM_HOME="$HOME/.pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

PNPM_COMPLETION=/usr/share/zsh/plugins/pnpm-shell-completion/pnpm-shell-completion.zsh
[[ -f $PNPM_COMPLETION ]] && source $PNPM_COMPLETION

# nnn
BLK="03" CHR="03" DIR="04" EXE="02" REG="07" HARDLINK="05" SYMLINK="05" MISSING="08" ORPHAN="01" FIFO="06" SOCK="03" UNKNOWN="01"
export NNN_COLORS="#04020301;4231"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$UNKNOWN"

# For secret env vars etc.
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
