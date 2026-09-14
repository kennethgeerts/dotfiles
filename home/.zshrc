### --- ZSH Core Configuration ---

HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
HISTSIZE=50000
SAVEHIST=50000

# Share history across sessions; omit duplicates and commands starting with a space.
setopt histignoredups histexpiredupsfirst histsavenodups histignorespace histverify sharehistory
unsetopt incappendhistory

setopt autocd autopushd pushdignoredups pushdsilent
setopt extendedglob globdots interactivecomments
setopt completeinword alwayslastprompt markdirs listpacked listrowsfirst

# Keep search paths unique, including when this file is sourced again.
typeset -U path fpath
export PNPM_HOME="${PNPM_HOME:-$HOME/.pnpm}"
path=("$PNPM_HOME" "$HOME/.local/bin" $path)
if [[ -d /Applications/Postgres.app/Contents/Versions/latest/bin ]]; then
  path=(/Applications/Postgres.app/Contents/Versions/latest/bin $path)
fi

# Homebrew on macOS; native distro packages on Linux
typeset -a zsh_plugin_dirs
if [[ "$OSTYPE" == darwin* ]] && (( $+commands[brew] )); then
  zsh_brew_prefix="$(brew --prefix)"
  fpath=("$zsh_brew_prefix/share/zsh/site-functions" "$zsh_brew_prefix/share/zsh-completions" $fpath)
  zsh_plugin_dirs=("$zsh_brew_prefix/share")
else
  [[ -d /usr/share/zsh/site-functions ]] && fpath=(/usr/share/zsh/site-functions $fpath)
  zsh_plugin_dirs=(/usr/share/zsh/plugins /usr/share)
fi

autoload -Uz compinit
compinit

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

# Plugins from Homebrew (macOS) or distro packages (Linux)
typeset -a missing_zsh_plugins=()
for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search; do
  plugin_found=false
  for dir in $zsh_plugin_dirs; do
    if [[ -f "$dir/$plugin/$plugin.zsh" ]]; then
      source "$dir/$plugin/$plugin.zsh"
      plugin_found=true
      break
    fi
  done
  $plugin_found || missing_zsh_plugins+=("$plugin")
done

if (( $#missing_zsh_plugins )); then
  print -u2 -- "Warning: missing zsh plugins: ${(j:, :)missing_zsh_plugins}"
fi

unset plugin plugin_found dir missing_zsh_plugins zsh_plugin_dirs zsh_brew_prefix

### --- Key Bindings ---

if (( ${+widgets[history-substring-search-up]} && ${+widgets[history-substring-search-down]} )); then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey '^P' history-substring-search-up
  bindkey '^N' history-substring-search-down
fi

bindkey '^[[Z' reverse-menu-complete
bindkey '^I' complete-word
bindkey '^U' backward-kill-line

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

### --- Environment ---

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export SUDO_EDITOR="${SUDO_EDITOR:-$EDITOR}"
export BAT_THEME=ansi

# Color man pages with bat.
if (( $+commands[bat] && $+commands[col] )); then
  export MANROFFOPT="-c"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

### --- Utility Functions ---

function n() {
  ${=EDITOR} "$@"
}

function publicip() {
  curl -fsS -4 https://ifconfig.me
}

function c() {
  local zed_cmd=${commands[zed]:-${commands[zeditor]:-${commands[zedit]}}}

  if [[ -z "$zed_cmd" ]]; then
    print -u2 -- "Neither zed, zeditor, nor zedit was found in PATH."
    return 1
  fi

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
  elif [[ -f package.json ]]; then
    echo "🧩 Running \`pnpm dev\`."
    pnpm dev
  else
    print -u2 -- "⚠️ No development environment found."
    return 1
  fi
}

function rip() {
  echo OUTPUTFORMAT=\'${1:-CD}'/${TRACKNUM}.${TRACKFILE}'\' >! ~/.abcde.conf
  abcde -N -n -x -o mp3
  drutil eject
}

function mkcd() {
  if (( $# == 0 )); then
    print -u2 -- "Usage: mkcd <directory> [directory...]"
    return 2
  fi

  mkdir -p -- "$@" && builtin cd -- "$argv[-1]"
}

function mkt() {
  local temp_dir
  temp_dir=$(mktemp -d) || return
  builtin cd -- "$temp_dir"
}

# Checkout a branch, remote branch, or tag (branches first, then remotes, then tags)
function co() {
  local query="${1:-}" kind ref selection r

  git rev-parse --git-dir >/dev/null 2>&1 || {
    print -u2 -- "Not inside a git repository."
    return 1
  }

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
    ) || return

    [[ -n "$selection" ]] || return 1

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
  local feature="${1:-}" agent

  if [[ -z "$feature" ]]; then
    print -u2 -- "Usage: ww <feature>"
    return 1
  fi

  agent=$(printf 'codex\nclaude\n' | fzf --height=4 --layout=reverse --no-info --prompt='agent> ') || return

  wt switch -c "$feature" -x "$agent"
}

### --- Aliases ---

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias d="dirs -v"
for stack_index in {1..9}; do
  alias "$stack_index=cd +$stack_index"
done
unset stack_index

# Development
alias ds="kamal deploy -d staging"
alias dp="kamal deploy -d production"
alias g="git"
alias ghi="gh issue view --web"
alias lg="lazygit"

# Files and processes
(( $+commands[bat] )) && alias cat="bat"
if (( $+commands[eza] )); then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi
alias top="btop"

### --- Tools ---

# fzf (preserve inherited options and colors).
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

if (( $+commands[mise] )); then
  eval "$(mise activate zsh)"
fi

# OrbStack
if [[ -r ~/.orbstack/shell/init.zsh ]]; then
  source ~/.orbstack/shell/init.zsh
fi

# Pure Prompt
autoload -Uz promptinit
promptinit
if (( $+functions[prompt_pure_setup] )); then
  prompt pure
fi

# Worktrunk shell integration
if (( $+commands[wt] )); then
  eval "$(command wt config shell init zsh)"
fi

# Privacy
export DO_NOT_TRACK=1
export HOMEBREW_NO_ANALYTICS=1
export VERCEL_TELEMETRY_DISABLED=1
export WRANGLER_SEND_METRICS=false

### --- Local overrides ---
if [[ -r ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi
