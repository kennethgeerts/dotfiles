### --- ZSH Core Configuration ---

mkdir -p ~/.zsh
[[ ! -d $HOME/.zsh/zsh-history-substring-search ]] && git clone https://github.com/zsh-users/zsh-history-substring-search.git $HOME/.zsh/
[[ ! -d $HOME/.zsh/zsh-autosuggestions ]] && git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.zsh/
[[ ! -d $HOME/.zsh/zsh-you-should-use ]] && git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $HOME/.zsh/
[[ ! -d $HOME/.zsh/zsh-syntax-highlighting ]] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/
[[ ! -d $HOME/.zsh/zsh-fzf-history-search ]] && git clone https://github.com/joshskidmore/zsh-fzf-history-search.git $HOME/.zsh/
[[ ! -d $HOME/.zsh/zsh-completions ]] && git clone https://github.com/zsh-users/zsh-completions.git $HOME/.zsh/

setopt correct             # Auto-correct minor typos
setopt extendedglob        # Enhanced globbing
setopt histignoredups      # Ignore duplicate history entries
setopt sharehistory        # Share command history across sessions
setopt incappendhistory    # Immediately append to history file
setopt autopushd           # Push old dir onto stack when changing dirs
setopt pushdignoredups     # Ignore duplicates when pushing to the directory stack
setopt pushdsilent         # Don't print the directory stack after pushd or popd
setopt interactivecomments # Allow comments in interactive mode

fpath=($HOME/.zsh/zsh-completions/src $fpath)
autoload -Uz compinit
compinit -C
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' rehash true

source $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-you-should-use/you-should-use.plugin.zsh
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^ ' autosuggest-accept  # Ctrl+Space accepts suggestion
export ZSH_FZF_HISTORY_SEARCH_FZF_ARGS="--height 40% --reverse --border"

VISUAL=nvim
EDITOR=nvim

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

### --- Aliases ---

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
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

### --- Tools ---

# fzf
source <(fzf --zsh)
export FZF_DEFAULT_OPTS=" \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

# ls / fd
export LS_COLORS="$(vivid generate catppuccin-frappe)"

# zoxide
eval "$(zoxide init zsh --cmd j)"

# mise
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

### --- Local overrides ---
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
