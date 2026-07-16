# Arch

These dotfiles are for macOS. Notes for a fresh Arch Linux install with
niri + [Noctalia shell](https://github.com/noctalia-dev/noctalia-shell).

## Desktop

```zsh
sudo pacman -S --needed \
  niri xwayland-satellite quickshell \
  ghostty signal-desktop ttf-jetbrains-mono zed
yay -S --needed noctalia-shell
```

Merge the input settings from [config/niri/config.kdl](config/niri/config.kdl)
into `~/.config/niri/config.kdl`.

## CLI packages

```zsh
sudo pacman -S --needed \
  7zip actionlint aws-cli-v2 bat btop cava eza fastfetch fd ffmpeg figlet \
  fzf git github-cli glow gnupg hexyl httpie hyperfine imagemagick jq \
  lazydocker lazygit mise neovim nnn oath-toolkit pnpm poppler prettyping \
  ripgrep rsync tailscale tldr unarchiver vivid wget yazi yt-dlp zoxide \
  zsh zsh-autosuggestions zsh-completions zsh-history-substring-search \
  zsh-syntax-highlighting
```

## AUR

```zsh
yay -S --needed \
  abcde brother-hll2350dw cd-discid elio herdr heroku-cli-bin hunk-bin \
  localsend-bin lowfi pi-coding-agent plex-media-server supabase-bin \
  temporal-cli ttf-victor-mono worktrunk-bin zsh-pure-prompt
```
