#!/usr/bin/env zsh

#Hostname
HOSTNAME=sofuto
sudo scutil --set ComputerName $HOSTNAME
sudo scutil --set HostName $HOSTNAME
sudo scutil --set LocalHostName $HOSTNAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $HOSTNAME

# Prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB # Why doesn't this work?
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done


# Dotfiles
cd "$HOME/code/dotfiles"
DOTFILES=(gemrc gitconfig gitignore tmux.conf vimrc zpreztorc zprofile zshrc)
for file in $DOTFILES; do
  rm -f "$HOME/.$file"
  ln -s "$HOME/code/dotfiles/$file" "$HOME/.$file"
done
ln -s "$HOME/code/dotfiles/kitty" "$HOME/.config/kitty"

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew bundle

# Ruby
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl)"
local RUBY_VERSION="$(rbenv install -l | sed -n '/^[[:space:]]*[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}[[:space:]]*$/ h;${g;p;}')"
rbenv install $RUBY_VERSION &> /dev/null
rbenv global $RUBY_VERSION &> /dev/null
