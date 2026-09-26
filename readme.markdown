# dotfiles

My macOS setup: zsh, Ghostty, Neovim (LazyVim), Zed, git, and the apps and
CLIs I use every day. Everything is Nord-themed. One command turns a fresh Mac
into my machine.

They're written for me, but anyone can use them: the installer asks for your
name, email and computer name, and nothing personal is hard-coded. See
[Making them yours](#making-them-yours).

## What's inside

| Path                               | What it is                                                          | Installed to                 |
| ---------------------------------- | ------------------------------------------------------------------- | ---------------------------- |
| [`install`](install)               | The bootstrap script                                                | —                          |
| [`Brewfile`](Brewfile)             | CLI tools, apps, fonts and App Store apps                           | `brew bundle`                |
| [`config/mise`](config/mise)       | Languages (Node, Ruby, Bun), dev CLIs and coding agents             | `mise install`               |
| [`home/`](home)                    | `.zshrc`, `.gitconfig`, global `.gitignore`, `.gemrc`, `.railsrc`   | `~/`                         |
| [`config/`](config)                | Ghostty, Zed, bat, herdr, hunk, cliamp                              | `~/.config/<app>/`           |
| [`nvim/`](nvim)                    | Plugin overrides on top of the [LazyVim starter][lazyvim]           | `~/.config/nvim/lua/plugins` |
| [`bin/`](bin)                      | Small scripts                                                       | `~/.local/bin`               |

Everything is symlinked, so editing a file in `~/.config` edits the repo.

## Install

On a fresh Mac, sign in to the App Store first so `brew bundle` can install the
App Store apps. Then run:

```zsh
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/kennethgeerts/dotfiles/HEAD/install)"
```

The installer first asks for your name and email (for git) and a computer
name; after that it runs unattended. Click Install when macOS asks for the
command line tools; the installer waits for them. It then:

1. sets the computer name and a fast key repeat,
2. saves your git identity to `~/.gitconfig.local`, outside the repo,
3. clones this repo to `~/.dotfiles`,
4. installs Homebrew and everything in the `Brewfile`,
5. symlinks `home/`, `config/` and `bin/` into place and prunes dead links,
6. sets up Neovim from the LazyVim starter with the plugins in `nvim/`,
7. installs languages and CLIs with `mise`.

Afterwards, restore the secrets (see [Secrets backup](#secrets-backup)) and
sign in to 1Password, Filen and Tailscale.

The installer is safe to re-run: run `~/.dotfiles/install` again after pulling
to pick up new packages and links. Note that it resets `~/.config/nvim` to the
LazyVim starter each time; only `lua/plugins` comes from this repo.

## Making them yours

To make the setup your own, fork the repo and change:

- **Repo URL.** `install` clones `kennethgeerts/dotfiles`. Point it (and the
  `curl` command above) at your fork.
- **Packages.** The [`Brewfile`](Brewfile) and
  [`config/mise/config.toml`](config/mise/config.toml) install a lot of apps.
  Trim them to taste.
- **Personal scripts.** `solar.sh` reads my solar inverter and `radio` plays my
  radio playlist; you probably want neither.

Not ready to commit to the whole thing? Most files stand on their own. The
`.zshrc` works with just the Homebrew zsh plugins, and skips any tool it can't
find (`eza`, `bat`, `zoxide`, `fzf`, `mise`, …).

### Local overrides

Anything machine-specific or secret goes in files that stay out of the repo:

- `~/.zshrc.local`, sourced at the end of `.zshrc`
- `~/.gitconfig.local`, included at the end of `.gitconfig`; holds your git
  name and email

## Shell goodies

A few things in [`.zshrc`](home/.zshrc) worth knowing about:

| Command      | What it does                                                                  |
| ------------ | ----------------------------------------------------------------------------- |
| `co [ref]`   | Check out a branch, remote branch or tag, with an fzf picker and log preview  |
| `ww <name>`  | Create a [worktrunk][worktrunk] worktree and start a coding agent in it       |
| `dev`        | Run `bin/dev` or `pnpm dev`, whichever the project has                        |
| `mkcd <dir>` | Make a directory and `cd` into it                                             |
| `mkt`        | `cd` into a fresh temp directory                                              |
| `o [path]`   | Open a file, URL or the current directory with the default app                |
| `c`          | Open the current directory in Zed                                             |
| `n`          | Open `$EDITOR` (Neovim)                                                       |
| `flatten`    | Move all files in subdirectories up to the current one, remove empty dirs     |
| `publicip`   | Print your public IPv4 address                                                |
| `vimv`       | Rename files in the current directory by editing their names in `$EDITOR`     |

`ls`, `cat` and `top` are aliased to `eza`, `bat` and `btop` when installed.

## Secrets backup

`backup-secrets` zips the credentials that stay out of this repo (`~/.ssh`,
`~/.aws`, `~/.netrc`, the rclone config, `~/.zshrc.local` and
`~/.gitconfig.local`) into an AES-256 encrypted archive. It prompts for a
password twice and writes to `~/Desktop/secrets-<timestamp>.zip` unless given
a path:

```zsh
backup-secrets [archive.zip]
```

Restore on a new machine, after the installer, with:

```zsh
cd ~ && 7z x /path/to/secrets.zip
```

## Photo backup

`backup-photos-to-r2` backs up the originals in an Apple Photos library with
`rclone`. It uploads immutable, content-addressed objects to
`cloudflare-photos:photos/originals` by default:

```text
_content/sha256/<first two hash characters>/<sha256>-<size>.<extension>
```

Run it manually after configuring the `cloudflare-photos` rclone remote:

```zsh
backup-photos-to-r2
```

The command skips objects already present in R2 and never deletes remote
objects. These environment variables override its defaults:

- `PHOTO_LIBRARY`: Photos library path
- `R2_DESTINATION`: rclone destination
- `PHOTO_BACKUP_LOG`: rclone log path

## Keeping things up to date

```zsh
brew update && brew upgrade   # Homebrew packages and apps
mise up                       # languages, dev CLIs and coding agents
```

Claude Code is installed through mise, so its self-updater is off; `mise up`
updates it.

[lazyvim]: https://github.com/LazyVim/starter
[worktrunk]: https://github.com/max-sixty/worktrunk
