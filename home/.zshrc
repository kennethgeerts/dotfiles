### --- ZSH Core Configuration ---

mkdir -p ~/.zsh ~/.zsh/cache
[[ ! -d $HOME/.zsh/zsh-history-substring-search ]] && git clone https://github.com/zsh-users/zsh-history-substring-search.git $HOME/.zsh/zsh-history-substring-search
[[ ! -d $HOME/.zsh/zsh-autosuggestions ]] && git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.zsh/zsh-autosuggestions
[[ ! -d $HOME/.zsh/zsh-you-should-use ]] && git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $HOME/.zsh/zsh-you-should-use
[[ ! -d $HOME/.zsh/zsh-syntax-highlighting ]] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting
[[ ! -d $HOME/.zsh/zsh-fzf-history-search ]] && git clone https://github.com/joshskidmore/zsh-fzf-history-search.git $HOME/.zsh/zsh-fzf-history-search
[[ ! -d $HOME/.zsh/zsh-completions ]] && git clone https://github.com/zsh-users/zsh-completions.git $HOME/.zsh/zsh-completions
[[ ! -d $HOME/.zsh/fzf-git ]] && git clone https://github.com/junegunn/fzf-git.sh.git $HOME/.zsh/fzf-git

setopt autocd
setopt correct
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

# Homebrew zsh completions (macOS / Linux with Homebrew)
if command -v brew &>/dev/null && [[ -d "$(brew --prefix)/share/zsh/site-functions" ]]; then
  fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
fi

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

function _git_repo_required() {
  git rev-parse --git-dir >/dev/null 2>&1 || {
    echo "Not inside a git repository."
    return 1
  }
}

function _co_switch_remote() {
  local remote_ref="$1"
  local local_branch="${remote_ref#*/}"

  if git show-ref --verify --quiet "refs/heads/$local_branch"; then
    git switch "$local_branch"
  else
    git switch --track "$remote_ref"
  fi
}

function _format_git_picker_rows() {
  awk -F '\t' '
    {
      kind[NR] = $1
      ref[NR] = $2
      meta[NR] = $3
      if (length($1) > kind_width) kind_width = length($1)
      if (length($2) > ref_width) ref_width = length($2)
    }
    END {
      for (i = 1; i <= NR; i++) {
        color = "\033[37m"
        if (kind[i] == "branch" || kind[i] == "clean") color = "\033[32m"
        if (kind[i] == "remote" || kind[i] == "dirty") color = "\033[33m"
        if (kind[i] == "tag") color = "\033[36m"
        if (kind[i] == "missing") color = "\033[31m"

        display = sprintf("%s%-*s\033[0m  %-*s  \033[90m%s\033[0m", color, kind_width, kind[i], ref_width, ref[i], meta[i])
        printf "%s\t%s\t%s\t%s\n", kind[i], ref[i], meta[i], display
      }
    }
  '
}

# Checkout a branch, remote branch, or tag (branches first, then remotes, then tags)
function co() {
  local query="$1"
  local selection kind ref

  _git_repo_required || return

  if [[ -n "$query" ]]; then
    if git show-ref --verify --quiet "refs/heads/$query"; then
      git switch "$query"
      return
    fi

    local -a remote_refs remote_matches
    remote_refs=(${(f)"$(git for-each-ref refs/remotes --format='%(refname:short)' | grep / | grep -v '/HEAD$')"})
    remote_matches=()
    for ref in $remote_refs; do
      [[ "$ref" == "$query" || "${ref#*/}" == "$query" ]] && remote_matches+=("$ref")
    done
    if (( ${#remote_matches[@]} == 1 )); then
      _co_switch_remote "$remote_matches[1]"
      return
    fi

    if git show-ref --verify --quiet "refs/tags/$query"; then
      git switch --detach "$query"
      return
    fi
  fi

  selection=$(
    {
      git for-each-ref refs/heads --sort=-committerdate \
        --format=$'branch\t%(refname:short)\t%(committerdate:relative)'
      git for-each-ref refs/remotes --sort=-committerdate \
        --format=$'remote\t%(refname:short)\t%(committerdate:relative)' | grep $'\t.*/' | grep -v $'\t.*/HEAD\t'
      git for-each-ref refs/tags --sort=-creatordate \
        --format=$'tag\t%(refname:short)\t%(creatordate:relative)'
    } |
    _format_git_picker_rows |
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

  case "$kind" in
    branch) git switch "$ref" ;;
    remote) _co_switch_remote "$ref" ;;
    tag) git switch --detach "$ref" ;;
  esac
}

# Switch worktrees (those on a branch first); ^X remove, ^F force-remove, ^P prune
function wt() {
  local query="$1"
  local list dir

  _git_repo_required || return

  if [[ -n "$query" ]]; then
    local -a matches
    matches=(${(f)"$(git worktree list --porcelain | awk -v q="$query" '
      $1 == "worktree" { path = substr($0, 10) }
      $1 == "branch" { branch = $2; sub("^refs/heads/", "", branch) }
      /^$/ {
        base = path; sub(".*/", "", base)
        if (path == q || branch == q || base == q) print path
        path = ""; branch = ""
      }
      END {
        base = path; sub(".*/", "", base)
        if (path && (path == q || branch == q || base == q)) print path
      }
    ')"})
    if (( ${#matches[@]} == 1 )); then
      cd "$matches[1]"
      return
    fi
  fi

  list="git worktree list | awk '/\\[/{print;next}{b=b\$0 ORS}END{printf \"%s\",b}' | while IFS= read -r line; do dir=\${line%% *}; branch=\$(printf '%s\n' \"\$line\" | sed -n 's/.*\\[\\([^]]*\\)\\].*/\\1/p'); [[ -z \"\$branch\" ]] && branch=\$(printf '%s\n' \"\$line\" | sed -n 's/.*(\\([^)]*\\)).*/\\1/p'); [[ -z \"\$branch\" ]] && branch='-'; if [[ -d \"\$dir\" ]]; then [[ -n \"\$(git -C \"\$dir\" status --porcelain 2>/dev/null)\" ]] && state=dirty || state=clean; else state=missing; fi; printf '%s\t%s\t%s\n' \"\$dir\" \"\$branch\" \"\$state\"; done | awk -F '\t' '{ dir[NR]=\$1; branch[NR]=\$2; state[NR]=\$3; if (length(\$1)>dir_width) dir_width=length(\$1); if (length(\$2)>branch_width) branch_width=length(\$2); } END { for (i=1; i<=NR; i++) { color=\"\033[32m\"; if (state[i]==\"dirty\") color=\"\033[33m\"; if (state[i]==\"missing\") color=\"\033[31m\"; display=sprintf(\"%-*s  %-*s  %s%s\033[0m\", dir_width, dir[i], branch_width, branch[i], color, state[i]); printf \"%s\t%s\t%s\t%s\n\", dir[i], branch[i], state[i], display; } }'"  # branch worktrees first
  dir=$(
    eval "$list" |
    fzf --ansi --no-multi --delimiter=$'\t' --with-nth=4 --accept-nth=1 \
      --height=60% --layout=reverse --border --border-label=' worktrees ' \
      --header='enter: cd · ^X: remove · ^F: force-remove · ^P: prune' \
      --query="$query" \
      --bind="ctrl-x:execute(printf '\n  Removing worktree:\n    %s\n\n' {1}; git worktree remove {1} 2>&1 || { printf '\n  not clean — press ^F to force-remove\n'; sleep 1.5; })+reload($list)" \
      --bind="ctrl-f:execute-silent(perl -e 'use POSIX; fork && exit; setsid; exec @ARGV' git worktree remove --force {1} >/dev/null 2>&1)+exclude" \
      --bind="ctrl-p:execute-silent(git worktree prune)+reload($list)" \
      --preview-window='down,45%,border-top' \
      --preview='if [ -d {1} ]; then
          git -C {1} -c color.status=always status --short --branch; echo
          git -C {1} log --oneline --graph --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" -20
        else echo "(worktree directory is gone — prunable; press ^P to prune)"; fi'
  )
  [[ -n $dir ]] && cd "$dir"
}

function ghi() {
  gh issue view "$@" --web
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
source $HOME/.zsh/fzf-git/fzf-git.sh
export FZF_DEFAULT_OPTS="
  --color=fg:#4c4f69,bg:-1,hl:#d20f39
  --color=fg+:#1e1e2e,bg+:-1,hl+:#d20f39
  --color=info:#8839ef,prompt:#1e66f5,pointer:#fe640b
  --color=marker:#40a02b,spinner:#04a5e5,header:#7287fd
"

# ls / fd
export LS_COLORS="$(vivid generate catppuccin-latte)"

# zoxide
eval "$(zoxide init zsh)"

# mise
eval "$(mise activate zsh)"

# OrbStack
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Pure Prompt
autoload -U promptinit; promptinit
prompt pure

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

PNPM_COMPLETION=/usr/share/zsh/plugins/pnpm-shell-completion/pnpm-shell-completion.zsh
[[ -f $PNPM_COMPLETION ]] && source $PNPM_COMPLETION

# Privacy
export DO_NOT_TRACK=1
export HOMEBREW_NO_ANALYTICS=1
export VERCEL_TELEMETRY_DISABLED=1
export WRANGLER_SEND_METRICS=false

### --- Local overrides ---
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
