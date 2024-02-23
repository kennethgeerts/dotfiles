# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

alias c="nvim ."
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
alias wm="yabai --start-service"
alias wms="yabai --stop-service"
alias work="nvim $HOME/Library/Mobile\ Documents/com~apple~CloudDocs/Sofuto/work.md"

# JRuby
alias jsr='JAVA_HOME="$(brew --prefix openjdk@8)" LANG= LC_ALL= bin/rails'
alias jsbe='JAVA_HOME="$(brew --prefix openjdk@8)" LANG= LC_ALL= bundle exec'


# fzf

export FZF_DEFAULT_OPTS=" \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

# Java
if (( $+commands[brew] )); then
  export JAVA_HOME="$(brew --prefix openjdk)"
  export PATH="$(brew --prefix openjdk)/bin:$PATH"
fi

# OrbStack
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
