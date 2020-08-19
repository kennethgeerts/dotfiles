#  _____    _
# |__  /___| |__  _ __ ___
#   / // __| '_ \| '__/ __|
#  / /_\__ \ | | | | | (__
# /____|___/_| |_|_|  \___|

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

export UPNXT_GEM_SOURCE='http://gem.internal.up-nxt.com'
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

alias bi='bundle install'
alias bu='bundle update'
alias cat='bat'
alias dev='hivemind -p 3000 Procfile.development'
alias icloud='~/Library/Mobile\ Documents/com~apple~CloudDocs/'
alias lg='lazygit'
alias m='./bin/meta'
alias pushenvs='g push dev && g push uat && m dev d && m uat d'
alias roru='yarn upgrade -L && gem_update'
alias v='vim'
alias x='exa -la --git'

c() { cd ~/code/$1; }
_c() { _files -W ~/code; }
compdef _c c

