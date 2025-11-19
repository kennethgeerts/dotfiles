# Kenneth's dotfiles

## Install

```zsh
curl -fsSL https://raw.githubusercontent.com/kennethgeerts/dotfiles/HEAD/install | zsh
```

## VSCode / Cursor settings

```json
{
  "breadcrumbs.enabled": false,
  "css.validate": false,
  "cursor.composer.cmdPFilePicker2": true,
  "cursor.composer.shouldChimeAfterChatFinishes": true,
  "editor.accessibilitySupport": "off",
  "editor.formatOnSave": true,
  "editor.cursorBlinking": "solid",
  "editor.fontFamily": "Victor Mono",
  "editor.fontLigatures": true,
  "editor.fontSize": 14,
  "editor.formatOnSaveMode": "modificationsIfAvailable",
  "editor.insertSpaces": true,
  "editor.stickyScroll.enabled": false,
  "editor.tabSize": 2,
  "explorer.confirmDelete": false,
  "explorer.confirmDragAndDrop": false,
  "files.insertFinalNewline": true,
  "files.trimFinalNewlines": true,
  "files.trimTrailingWhitespace": true,
  "security.promptForLocalFileProtocolHandling": false,
  "typescript.updateImportsOnFileMove.enabled": "always",
  "workbench.iconTheme": "catppuccin-latte",
  "workbench.colorTheme": "Catppuccin Latte",
  "workbench.layoutControl.enabled": false,
  "workbench.navigationControl.enabled": false,
  "biome.suggestInstallingGlobally": false
}
```

## Omarchy

These dotfiles are for MacOS. For linux, just install Omarchy.

### Packages

Additional packages:

- aws-cli-v2-bin
- brother-hll2350dw
- cava
- cursor-bin
- cursor-cli
- git-delta
- httpie
- lowfi
- nnn
- oh-my-posh
- plex-media-server
- pnpm
- pnpm-shell-completion
- prettyping
- ripgrep
- rsync
- tailscale
- ttf-victor-mono
- zsh

### hyprland.conf

```
input {
  repeat_rate = 80
  repeat_delay = 200
  natural_scroll = true
}
```
