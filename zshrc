if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

h() { cd ~/$1; }
_h() { _files -W ~; }
compdef _h h

j() { cd ~/code/$1; }
_j() { _files -W ~/code; }
compdef _j j

function take() {
  mkdir -p $@ && cd ${@:$#}
}

alias n="nvim ."
alias c="code ."
alias cat="bat"
alias d="bin/dev"
alias difff="kitty +kitten diff"
alias ls="eza -al --color=always --group-directories-first" # my preferred listing
alias la="eza -a --color=always --group-directories-first"  # all files and dirs
alias ll="eza -l --color=always --group-directories-first"  # long format
alias lt="eza -aT --color=always --group-directories-first" # tree listing
alias l="ls"
alias lg="lazygit"
alias ping="prettyping"
alias top="htop"
alias work="nvim $HOME/Library/Mobile\ Documents/com~apple~CloudDocs/Sofuto/work.md"

# fzf
source <(fzf --zsh)
export FZF_DEFAULT_OPTS=" \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

# zoxide
eval "$(zoxide init zsh)"

# Java
if (( $+commands[brew] )); then
  export JAVA_HOME="$(brew --prefix openjdk)"
  export PATH="$(brew --prefix openjdk)/bin:$PATH"
fi

# OrbStack
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Oh My Posh
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/catppuccin_frappe.omp.json)"
fi
