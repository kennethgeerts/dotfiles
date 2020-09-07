if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

c() { cd ~/code/$1; }
_c() { _files -W ~/code; }
compdef _c c

export UPNXT_GEM_SOURCE='http://gem.internal.up-nxt.com'
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin:/Applications/kitty.app/Contents/MacOS

source .aliases

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
