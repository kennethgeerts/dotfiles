# Kenneth's dotfiles

## Install

```zsh
curl -fsSL https://raw.githubusercontent.com/kennethgeerts/dotfiles/HEAD/install | zsh
```

## Cursor settings

```json
{
  "breadcrumbs.enabled": false,
  "css.validate": false,
  "cursor.composer.cmdPFilePicker2": true,
  "cursor.composer.queueMessageDefaultBehavior": "stop-and-send",
  "cursor.composer.shouldChimeAfterChatFinishes": true,
  "cursor.composer.usageSummaryDisplay": "always",
  "editor.accessibilitySupport": "off",
  "editor.cursorBlinking": "solid",
  "editor.fontFamily": "MonoLisa",
  "editor.fontLigatures": "'ss02','ss11', 'liga', 'calt', 'ss07', 'ss08'",
  "editor.fontSize": 13,
  "editor.formatOnSave": true,
  "editor.formatOnSaveMode": "file",
  "editor.insertSpaces": true,
  "editor.stickyScroll.enabled": false,
  "editor.tabSize": 2,
  "explorer.confirmDelete": false,
  "explorer.confirmDragAndDrop": false,
  "files.insertFinalNewline": true,
  "files.trimFinalNewlines": true,
  "files.trimTrailingWhitespace": true,
  "javascript.updateImportsOnFileMove.enabled": "always",
  "security.promptForLocalFileProtocolHandling": false,
  "typescript.updateImportsOnFileMove.enabled": "always",
  "update.releaseTrack": "prerelease",
  "window.autoDetectColorScheme": true,
  "window.confirmSaveUntitledWorkspace": false,
  "workbench.layoutControl.enabled": false,
  "workbench.navigationControl.enabled": false,
  "workbench.preferredLightColorTheme": "Cursor Light"
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
