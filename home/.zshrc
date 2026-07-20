### --- ZSH Core Configuration ---

setopt autocd
setopt extendedglob

HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
HISTSIZE=50000
SAVEHIST=50000

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

# Homebrew zsh completions & plugins (macOS / Linux with Homebrew)
if command -v brew &>/dev/null; then
  BREW_PREFIX="$(brew --prefix)"
  fpath=("$BREW_PREFIX/share/zsh/site-functions" "$BREW_PREFIX/share/zsh-completions" $fpath)
fi

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

# Plugins from Homebrew (macOS) or pacman (Arch)
for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search; do
  for dir in "$BREW_PREFIX/share" /usr/share/zsh/plugins; do
    [[ -f "$dir/$plugin/$plugin.zsh" ]] && source "$dir/$plugin/$plugin.zsh" && break
  done
done

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

bindkey '^[[Z' reverse-menu-complete
bindkey '^I' complete-word
bindkey '^U' backward-kill-line

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

export VISUAL=nvim
export EDITOR=nvim

path=($HOME/.local/bin $path)



### --- Utility Functions ---

function ip() {
  curl -s -4 https://ifconfig.me
}

function _zed_cmd() {
  local zed_cmd=${commands[zed]:-${commands[zeditor]:-${commands[zedit]}}}

  if [[ -z "$zed_cmd" ]]; then
    echo "Neither zed, zeditor, nor zedit was found in PATH."
    return 1
  fi

  echo "$zed_cmd"
}

function c() {
  local zed_cmd=$(_zed_cmd) || return

  "$zed_cmd" "$PWD"
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
  local zed_cmd=$(_zed_cmd) || return

  "$zed_cmd" "$file"
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

# Checkout a branch, remote branch, or tag (branches first, then remotes, then tags)
function co() {
  local query="$1" kind ref selection r

  git rev-parse --git-dir >/dev/null 2>&1 || { echo "Not inside a git repository."; return 1; }

  if [[ -n "$query" ]]; then
    local -a remotes matches
    remotes=(${(f)"$(git for-each-ref refs/remotes --format='%(refname:short)' | grep / | grep -v '/HEAD$')"})
    matches=()
    for r in $remotes; do
      [[ "$r" == "$query" || "${r#*/}" == "$query" ]] && matches+=("$r")
    done

    if git show-ref --verify --quiet "refs/heads/$query"; then
      kind=branch ref="$query"
    elif (( $#matches == 1 )); then
      kind=remote ref="$matches[1]"
    elif git show-ref --verify --quiet "refs/tags/$query"; then
      kind=tag ref="$query"
    fi
  fi

  if [[ -z "$kind" ]]; then
    selection=$(
      {
        git for-each-ref refs/heads --sort=-committerdate \
          --format=$'branch\t%(refname:short)\t%(committerdate:relative)'
        git for-each-ref refs/remotes --sort=-committerdate \
          --format=$'remote\t%(refname:short)\t%(committerdate:relative)' | grep $'\t.*/' | grep -v $'\t.*/HEAD\t'
        git for-each-ref refs/tags --sort=-creatordate \
          --format=$'tag\t%(refname:short)\t%(creatordate:relative)'
      } |
      awk -F '\t' '
        {
          kind[NR] = $1; ref[NR] = $2; meta[NR] = $3
          if (length($2) > ref_width) ref_width = length($2)
        }
        END {
          for (i = 1; i <= NR; i++) {
            color = kind[i] == "branch" ? "\033[32m" : kind[i] == "remote" ? "\033[33m" : "\033[36m"
            printf "%s\t%s\t%s\t%s%-6s\033[0m  %-*s  \033[90m%s\033[0m\n", kind[i], ref[i], meta[i], color, kind[i], ref_width, ref[i], meta[i]
          }
        }
      ' |
      fzf --ansi --no-multi --delimiter=$'\t' --with-nth=4 --tiebreak=begin \
        --height=60% --layout=reverse --border --border-label=' checkout ' \
        --header='enter: checkout' \
        --query="$query" \
        --preview-window='down,45%,border-top' \
        --preview='git log --oneline --graph --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" {2} --'
    )

    [[ -z "$selection" ]] && return

    kind="${selection%%$'\t'*}"
    ref="${selection#*$'\t'}"
    ref="${ref%%$'\t'*}"
  fi

  case "$kind" in
    branch) git switch "$ref" ;;
    tag) git switch --detach "$ref" ;;
    remote)
      if git show-ref --verify --quiet "refs/heads/${ref#*/}"; then
        git switch "${ref#*/}"
      else
        git switch --track "$ref"
      fi
      ;;
  esac
}

function ww() {
  local feature="$1" agent

  if [[ -z "$feature" ]]; then
    echo "Usage: ww <feature>"
    return 1
  fi

  agent=$(printf 'codex\nclaude' | fzf --height=4 --layout=reverse --no-info --prompt='agent> ') || return

  wt switch -c "$feature" -x "$agent"
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

alias ca="codex app"
alias cat="bat"
alias ds="kamal deploy -d staging"
alias dp="kamal deploy -d production"
alias g="git"
alias ghi="gh issue view --web"
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias lg="lazygit"
alias n="nvim"
alias ping="prettyping"
alias r="bin/rails"
alias top="btop"
alias y="yazi"

### --- Tools ---

# fzf
source <(fzf --zsh)

# fzf / ls colors follow the OS appearance (Catppuccin Latte / Mocha)
if [[ "$OSTYPE" == darwin* ]]; then
  defaults read -g AppleInterfaceStyle &>/dev/null && APPEARANCE=dark || APPEARANCE=light
else
  # freedesktop setting; light if gsettings is missing or the key is unset
  [[ "$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)" == *prefer-dark* ]] && APPEARANCE=dark || APPEARANCE=light
fi

if [[ "$APPEARANCE" == light ]]; then
  export LS_COLORS="$(vivid generate catppuccin-latte)"
  export FZF_DEFAULT_OPTS="
    --color=fg:#4c4f69,bg:-1,hl:#d20f39
    --color=fg+:#1e1e2e,bg+:-1,hl+:#d20f39
    --color=info:#8839ef,prompt:#1e66f5,pointer:#fe640b
    --color=marker:#40a02b,spinner:#04a5e5,header:#7287fd
  "
else
  export LS_COLORS="$(vivid generate catppuccin-mocha)"
  export FZF_DEFAULT_OPTS="
    --color=fg:#cdd6f4,bg:-1,hl:#f38ba8
    --color=fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8
    --color=info:#cba6f7,prompt:#89b4fa,pointer:#f5e0dc
    --color=marker:#a6e3a1,spinner:#f5e0dc,header:#94e2d5
  "
fi

# zoxide
eval "$(zoxide init zsh)"

# mise
eval "$(mise activate zsh)"

# OrbStack
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Pure Prompt
autoload -U promptinit; promptinit
prompt pure

# Worktrunk shell integration
if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

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

# Privacy
export DO_NOT_TRACK=1
export HOMEBREW_NO_ANALYTICS=1
export VERCEL_TELEMETRY_DISABLED=1
export WRANGLER_SEND_METRICS=false

### --- Local overrides ---
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
