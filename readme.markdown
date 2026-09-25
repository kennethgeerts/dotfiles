# Kenneth's dotfiles

## Install

On a fresh Mac, sign in to the App Store first so `brew bundle` can install
the App Store apps. Then run:

```zsh
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/kennethgeerts/dotfiles/HEAD/install)"
```

Click Install when macOS asks for the command line tools; the installer waits
for them. Afterwards, restore the secrets (see below) and sign in to
1Password, Filen and Tailscale.

## Secrets backup

`backup-secrets` zips the credentials that stay out of this repo (`~/.ssh`,
`~/.aws`, `~/.netrc`, the rclone config and `~/.zshrc.local`) into an AES-256
encrypted archive. It prompts for a password twice and writes to
`~/Desktop/secrets-<timestamp>.zip` unless given a path:

```zsh
backup-secrets [archive.zip]
```

Restore on a new machine, after the installer, with
`cd ~ && 7z x /path/to/secrets.zip`.

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

The installer links the command from [`bin`](bin) into `~/.local/bin`.
