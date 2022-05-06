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

if [[ "$OSTYPE" == darwin* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  eval "$(rbenv init -)"

  export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin"
  export PATH="$PATH:/Applications/kitty.app/Contents/MacOS"
  export PATH="/usr/local/opt/openjdk/bin:$PATH"
fi

source ~/.aliases

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
