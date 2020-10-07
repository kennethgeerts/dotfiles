if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

h() { cd ~/$1; }
_h() { _files -W ~; }
compdef _h h

j() { cd ~/code/$1; }
_j() { _files -W ~/code; }
compdef _j j

export UPNXT_GEM_SOURCE='http://gem.internal.up-nxt.com'

if [[ "$OSTYPE" == darwin* ]]; then
  export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin:/Applications/kitty.app/Contents/MacOS
fi

source ~/.aliases

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
