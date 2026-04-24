# dotfiles (non-nix branch)

Personal macOS dotfiles installed via **Homebrew** + a **Makefile** + symlinks.

Targets Apple Silicon (aarch64). This branch replaces the nix-darwin +
home-manager setup on `main` with a plain-shell install path for work machines
that have Homebrew but no Nix.

## Bootstrap

1. **Install Xcode Command Line Tools**:

   ```sh
   xcode-select --install
   ```

2. **Clone the repo anywhere** (the install reads from its repo directory; it
   doesn't care where it lives):

   ```sh
   git clone -b non-nix-install https://github.com/douglasalbert/dotfiles ~/src/dotfiles
   cd ~/src/dotfiles
   ```

3. **Preview what will change**:

   ```sh
   make check
   ```

   Exits 0 if nothing would change, 1 otherwise. Prints a diff for any existing
   regular file whose contents differ from the repo source.

4. **Install**:

   ```sh
   make install
   ```

   Runs `brew-install` → `brew-bundle` → `symlinks` → `macos-defaults`.

## Targets

| Target | What it does |
|---|---|
| `make check` | dry-run; see above |
| `make install` | full install (no sudo) |
| `make brew-install` | install Homebrew if missing |
| `make brew-bundle` | `brew bundle --file=./Brewfile` |
| `make symlinks` | create symlinks; back up conflicting regular files to `<path>.pre-dotfiles.bak` |
| `make macos-defaults` | apply user-scoped `defaults write` + PlistBuddy + `chflags` |
| `make macos-defaults-sudo` | apply system-scoped defaults (loginwindow, screensaver password) — prompts for sudo |

## What gets installed

- **Packages**: see `Brewfile` (brews, casks, taps).
- **Dotfiles**: every file under `files/` is symlinked into `$HOME`; see
  `scripts/manifest.sh` for the source → target mapping.
- **macOS defaults**: see `scripts/macos-defaults.sh`.

## Machine-specific secrets

Not committed; sourced at shell startup if present:

| Shell | File |
|-------|------|
| Bash  | `~/.bash_profile.local` |
| Zsh   | `~/.profile.local` |

## Optional: TouchID for sudo

Not included in `make install`. To enable:

```sh
echo "auth sufficient pam_tid.so" | sudo tee /etc/pam.d/sudo_local
```

## Backups

`make symlinks` backs up any conflicting regular file to
`<target>.pre-dotfiles.bak` (timestamp suffix if a prior backup exists). No
rollback automation — macOS defaults and Homebrew installs are not reverted.
