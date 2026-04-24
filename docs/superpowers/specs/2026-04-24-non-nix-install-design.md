# Non-nix Install Path — Design

Date: 2026-04-24
Status: draft
Scope: local-only branch of `personal/dotfiles`; never merged to `main` (nix config stays authoritative on `main`).

## Goal

Replace the `nix-darwin` + `home-manager` install path with a plain Makefile + Homebrew + symlink workflow, so this repo can be installed on a work macOS machine that has Homebrew but no Nix.

## Non-goals

- Supporting Linux / non-macOS targets.
- Keeping the `nix` path working alongside the new one on this branch (it's a replacement, not a coexistence).
- Porting Mac App Store apps (`masApps`) — handled separately by the user.
- Porting `security.pam.services.sudo_local.touchIdAuth` (TouchID for sudo) or `home.activation.piTools`. A one-line manual TouchID snippet goes in `README.md`; piTools is dropped.
- Cross-machine templating, secrets management, or declarative state (no `chezmoi`, no `stow`).

## Package inventory (final)

### Casks (GUI apps)

`aerospace`, `claude`, `granola`, `zed`, `lm-studio`

Dropped from the nix config for this target: `ghostty`, `google-chrome`, `mac-mouse-fix`, `rustdesk`, `handbrake-app`, `gstreamer-runtime`, `discord`, `transmission`, `signal`, `tailscale-app`, `iina`, `obsidian`.

### Brews

Work-machine tools from the nix config:
`arthur-ficial/tap/apfel`, `eugene1g/safehouse/agent-safehouse`, `gemini-cli`, `container`, `mas`, `macos-trash`, `mole`, `oven-sh/bun/bun`, `colima`, `devcontainer`, `docker`.

CLI tools moved from `nixpkgs` to Homebrew:
`actionlint`, `ast-grep`, `docker-compose`, `fd`, `gh`, `go`, `jq`, `just`, `libdvdcss`, `markdownlint-cli2`, `mediainfo`, `mosh`, `node@22`, `pnpm`, `ripgrep`, `shellcheck`, `shfmt`, `television`, `tree`, `uv`, `wget`, `zizmor`, `zsh-completions`.

Dropped: `nil` (nix LSP — useless without nix), `gst_all_1.gstreamer` (media), `signal-cli` (personal messaging).

Shell integrations (replacing home-manager's `programs.*.enable`):
`starship`, `zoxide`, `fzf`, `carapace`, `zsh-syntax-highlighting`.

Added for the non-nix path:
- `bash` — Apple's stock bash 3.2 doesn't support `globstar`; brew bash 5 matches the nix behavior.
- `git-lfs` — was `programs.git.lfs.enable = true` under home-manager.
- `neovim` — was `programs.neovim.enable = true` under home-manager.

### Taps

`arthur-ficial/tap`, `eugene1g/safehouse`, `nikitabobko/tap`, `osx-cross/arm`, `osx-cross/avr`.

### Mac App Store

Skipped entirely. User handles separately.

### Known risks

- `container` (Apple's container CLI) may require a specific tap that isn't declared above; verify at install time and add the tap if brew can't resolve the formula.
- `libdvdcss` is in Homebrew core in most versions but historically lived on the `videolan` tap; verify at install time.

## Repo layout (after the branch changes)

```
dotfiles/
  Makefile
  Brewfile
  scripts/
    manifest.sh          # shared: defines REPO_ROOT + SYMLINKS array
    check.sh             # dry-run: diff existing files vs. what install would do
    symlinks.sh          # create symlinks, back up conflicting regular files
    brew-install.sh      # install Homebrew if missing
    macos-defaults.sh    # user-scoped `defaults write` + PlistBuddy + chflags
    macos-defaults-sudo.sh   # two system-scoped defaults (opt-in)
  files/
    profile.common       # NEW — shared env/PATH/aliases/functions (sourced by zsh + bash)
    zshrc                # NEW
    bashrc               # NEW
    bash_profile         # NEW
    gitconfig            # NEW
    gitignore_global     # NEW
    tmux.conf            # NEW
    vimrc                # EDITED — vim-plug block prepended inline
    ssh_config           # NEW
    aerospace.toml       # unchanged from main
    colima.yaml          # unchanged from main
    ghostty/
      config             # NEW (extracted from home/ghostty.nix)
      themes/
        dark-ergo        # NEW
        light-ergo       # NEW
    bash_prompt          # kept as-is, not used (unused on main too)
    zsh_prompt           # kept as-is, not used
  docs/
    superpowers/specs/2026-04-24-non-nix-install-design.md   # this doc
  README.md              # rewritten: nix references removed, Makefile workflow documented
  CLAUDE.md              # rewritten: architecture section matches new layout
  .gitignore

DELETED on this branch: flake.nix, flake.lock, .envrc, home/, hosts/
```

## Makefile

```make
.PHONY: help install check brew-install brew-bundle symlinks macos-defaults macos-defaults-sudo

help:
	@echo "Targets:"
	@echo "  check                 Dry-run: show per-file diff without modifying anything"
	@echo "  install               Full install (brew + bundle + symlinks + macos-defaults)"
	@echo "  brew-install          Install Homebrew if missing"
	@echo "  brew-bundle           brew bundle --file=./Brewfile"
	@echo "  symlinks              Create symlinks per scripts/manifest.sh"
	@echo "  macos-defaults        Apply user-scoped macOS defaults"
	@echo "  macos-defaults-sudo   Apply system-scoped macOS defaults (prompts for sudo)"

install: brew-install brew-bundle symlinks macos-defaults

check:
	@./scripts/check.sh

brew-install:
	@./scripts/brew-install.sh

brew-bundle:
	@brew bundle --file=./Brewfile

symlinks:
	@./scripts/symlinks.sh

macos-defaults:
	@./scripts/macos-defaults.sh

macos-defaults-sudo:
	@./scripts/macos-defaults-sudo.sh
```

## Manifest (`scripts/manifest.sh`)

Single source of truth for symlink mappings. Sourced by both `symlinks.sh` and `check.sh`.

```bash
#!/usr/bin/env bash
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SYMLINKS=(
  "$REPO_ROOT/files/profile.common:$HOME/.config/dotfiles/profile.common"
  "$REPO_ROOT/files/zshrc:$HOME/.zshrc"
  "$REPO_ROOT/files/bashrc:$HOME/.bashrc"
  "$REPO_ROOT/files/bash_profile:$HOME/.bash_profile"
  "$REPO_ROOT/files/gitconfig:$HOME/.gitconfig"
  "$REPO_ROOT/files/gitignore_global:$HOME/.gitignore_global"
  "$REPO_ROOT/files/tmux.conf:$HOME/.tmux.conf"
  "$REPO_ROOT/files/vimrc:$HOME/.vimrc"
  "$REPO_ROOT/files/vimrc:$HOME/.config/nvim/init.vim"
  "$REPO_ROOT/files/ssh_config:$HOME/.ssh/config"
  "$REPO_ROOT/files/aerospace.toml:$HOME/.config/aerospace/aerospace.toml"
  "$REPO_ROOT/files/colima.yaml:$HOME/.colima/default/colima.yaml"
  "$REPO_ROOT/files/ghostty/config:$HOME/.config/ghostty/config"
  "$REPO_ROOT/files/ghostty/themes/dark-ergo:$HOME/.config/ghostty/themes/dark-ergo"
  "$REPO_ROOT/files/ghostty/themes/light-ergo:$HOME/.config/ghostty/themes/light-ergo"
)
```

The `profile.common` target sits at `~/.config/dotfiles/profile.common` (decision from brainstorming: decouple the source path from where the repo lives, so `zshrc`/`bashrc` can reference a known path).

## `check.sh` behavior

Iterates over `SYMLINKS` and reports one line per entry, plus a unified diff for any differing regular files.

Per-target state → output:

| Current state of target | Output |
|---|---|
| Target doesn't exist | `+ create   <target> → <source>` |
| Target is a symlink pointing at correct source | `= ok       <target> → <source>` |
| Target is a symlink pointing elsewhere | `~ retarget <target> (was → <old>, will → <source>)` |
| Target is a regular file, content identical to source | `= match    <target> (content matches, would swap to symlink)` |
| Target is a regular file, content differs | `~ differ   <target>` followed by `diff -u <target> <source>` inline |

Exit code:
- `0` — nothing would change (all entries are `=`)
- `1` — at least one entry is `+` or `~` (scriptable: `make check || echo "drift"`)

`check.sh` does **not** diff Brewfile state or macOS defaults. Scope is file-level only.

## `symlinks.sh` behavior

For each entry:
1. `mkdir -p "$(dirname "$target")"`.
2. If target exists and is a directory, abort with an error message naming the path — the user must resolve manually (script does not recursively delete user data).
3. If target exists and is a regular file whose content differs from source, move it to `<target>.pre-dotfiles.bak` (if that path already exists, use `<target>.pre-dotfiles.bak.YYYYMMDDhhmmss`).
4. If target exists and is a regular file whose content matches source, remove it (no backup needed) before linking.
5. If target exists and is a symlink pointing elsewhere, remove it.
6. `ln -sfn "$source" "$target"`.
7. For `~/.ssh/config`: `chmod 700 ~/.ssh` before, `chmod 600 ~/.ssh/config` after (operates on the link target via `chmod` which follows symlinks).

After all symlinks:
- Create `~/.vim/{backups,swaps,colors}` if missing.
- Bootstrap `vim-plug`:
  - `curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/0.14.0/plug.vim`
  - `curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/0.14.0/plug.vim`
- Run `vim +PlugInstall +qall` and `nvim +PlugInstall +qall` (best-effort; skipped if `vim` / `nvim` missing).

## `brew-install.sh` behavior

1. If `command -v brew` succeeds, no-op.
2. Otherwise, run the official installer: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`.
3. Print a reminder that a new shell session is needed to pick up `/opt/homebrew/bin` on PATH.

## `macos-defaults.sh` behavior

Applies every user-scoped entry from `hosts/default.nix` as-is, grouped by domain. Uses `set -u` (not `set -e`) so individual `defaults` commands that fail (e.g., keys Apple removed on a macOS upgrade) don't abort the rest.

Blocks, in order:
1. `NSGlobalDomain` — 24 keys from `NSGlobalDomain = {...}`.
2. Dock — 13 keys from `dock = {...}`.
3. Finder — 9 keys from `finder = {...}`.
4. Trackpad — `Clicking = true` written to both `com.apple.AppleMultitouchTrackpad` and `com.apple.driver.AppleBluetoothMultitouch.trackpad` (mirrors what nix-darwin does).
5. Screen capture — 3 keys (`location`, `type`, `disable-shadow`).
6. `CustomUserPreferences` — ~20 entries across 10 domains (Messages, ActivityMonitor, TextEdit, DiskUtility, SoftwareUpdate, TimeMachine, desktopservices, print.PrintingPrefs, commerce, LaunchServices, NetworkBrowser, QuickTimePlayerX). Dict values use `-dict-add`.
7. PostActivation:
   - `chflags nohidden ~/Library || true`
   - `chflags nohidden /Volumes || true`
   - 9× PlistBuddy on `~/Library/Preferences/com.apple.finder.plist` with `2>/dev/null || true` (Finder icon view settings: showItemInfo, arrangeBy grid, gridSpacing, iconSize, labelOnBottom).
8. Restart affected apps: `killall cfprefsd Dock Finder SystemUIServer 2>/dev/null || true`.

Final message: "Done. Some settings (Dock autohide, Finder view) may need a logout to fully apply."

## `macos-defaults-sudo.sh` behavior

Separate from `macos-defaults.sh` because it requires root and we want `make install` to be non-interactive by default.

```bash
#!/usr/bin/env bash
set -u
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false
sudo defaults write com.apple.screensaver askForPassword -int 1
sudo defaults write com.apple.screensaver askForPasswordDelay -int 0
```

Opt-in via `make macos-defaults-sudo`.

## Dotfile translations from nix

### `files/profile.common`

Shared env/PATH/aliases/function. Sourced as the first line of both `zshrc` and `bashrc`.

```sh
# Homebrew shellenv — sets HOMEBREW_PREFIX and adds /opt/homebrew/{bin,sbin} to PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# Session variables (from home.sessionVariables)
export HISTSIZE=50000000
export HISTFILESIZE=50000000
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export MANPAGER="less -X"
export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"

# PATH (from home.sessionPath; obsidian path dropped since cask is dropped)
export PATH="$HOME/.local/bin:$PATH"

# Aliases (from shellAliases)
alias dk="docker"
alias dkps="docker ps"
alias dki="docker inspect"
alias dkr="docker restart"
alias dkl="docker logs --tail=20 -f"
alias dkc="docker-compose"
alias l="ls -hFG"
alias ls="ls -hFG"
alias ll="ls -lhFG"
alias la="ls -Al"
alias lk="ls -lSr"
alias lc="ls -ltcr"
alias lu="ls -ltur"
alias lt="ls -ltr"
alias lm="ls -al |more"
alias lr="ls -lR"
alias tree="tree -Csu"
alias ..="cd .."

dotcleanunmount() {
  dot_clean -m "$1"
  [ -d "$1/.Spotlight-V100" ] && rm -rf "$1/.Spotlight-V100"
  [ -d "$1/Trashes" ]         && rm -rf "$1/Trashes"
  [ -d "$1/.fseventsd" ]      && rm -rf "$1/.fseventsd"
  diskutil unmount "$1"
}
```

### `files/zshrc`

```zsh
[ -r "$HOME/.config/dotfiles/profile.common" ] && source "$HOME/.config/dotfiles/profile.common"

# History
HISTSIZE=50000000
SAVEHIST=50000000
HISTFILE="$HOME/.zsh_history"
setopt EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# Options (from initContent)
unsetopt menu_complete flowcontrol
setopt prompt_subst always_to_end auto_menu complete_in_word hist_verify interactivecomments

# zsh-completions (from brew) — must precede compinit
fpath=("$HOMEBREW_PREFIX/share/zsh-completions" "$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)

# Completion
zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list "" "m:{[:lower:][:upper:]}={[:upper:][:lower:]}" "+l:|=* r:|=*"
autoload -U compinit && compinit
zmodload -i zsh/complist

# Vi keybindings with emacs line-nav
bindkey -v
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# Shell integrations (syntax-highlighting MUST be last)
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ] && source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" ]   && source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
source <(carapace _carapace zsh)

source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Local overrides
[[ -r "$HOME/.profile.local" && -f "$HOME/.profile.local" ]] && source "$HOME/.profile.local"
```

### `files/bashrc`

```bash
[ -r "$HOME/.config/dotfiles/profile.common" ] && source "$HOME/.config/dotfiles/profile.common"

# Shell options (from programs.bash.shellOptions) — globstar requires bash 4+, hence brew bash
shopt -s checkwinsize nocaseglob histappend cdspell autocd globstar

# Shell integrations
eval "$(starship init bash)"
eval "$(zoxide init bash)"
[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.bash" ] && source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.bash"
[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/completion.bash" ]   && source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.bash"
source <(carapace _carapace bash)

# SSH hostname completion
[[ -e "$HOME/.ssh/config" ]] && complete -o "default" -o "nospace" \
  -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" \
  scp sftp ssh

# kubectl completion
command -v kubectl >/dev/null && source <(kubectl completion bash)

# Local overrides
[[ -r "$HOME/.bash_profile.local" && -f "$HOME/.bash_profile.local" ]] && source "$HOME/.bash_profile.local"
```

### `files/bash_profile`

```bash
[ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"
```

### `files/gitconfig`

INI translation of every field in `home/git.nix` → `programs.git.settings`. Key difference from `main`:

- `user.email = dalbert@guidewire.com` (was personal email on `main`).
- `user.name = Douglas Albert` (unchanged).
- `github.user = douglasalbert` (unchanged; if a different work handle is needed, revise during implementation).
- `core.excludesfile = ~/.gitignore_global` added so `ignores = [...]` has somewhere to live.
- `[filter "lfs"]` stanza added (was provided by `programs.git.lfs.enable = true`).

All aliases, `apply`, `diff`, `fetch`, `help`, `merge`, `pull`, `push`, `status`, `url.*`, `rerere`, and `credential.*` blocks carry over unchanged.

### `files/gitignore_global`

Every entry from `programs.git.ignores` — one per line, in the same order as `git.nix`.

### `files/tmux.conf`

```tmux
set-option -g default-terminal "screen-256color"
set -g mouse on
setw -g mode-keys vi
```

…followed by the verbatim contents of `extraConfig` from `home/tmux.nix` (split bindings, Alt-arrow pane switching, status bar styling, message/mode styling, quiet options).

### `files/ssh_config`

```sshconfig
Host *
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_ed25519
```

### `files/vimrc`

The existing `files/vimrc` gets edited in place: the `vimPlugHeader` block from `home/vim.nix` is prepended inline so it loads for both `vim` and `nvim` without nix-managed plugins:

```vim
call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline-themes'
Plug 'sheerun/vim-polyglot'
Plug 'nanotee/zoxide.vim'
call plug#end()

" (existing vimrc contents follow unchanged)
```

### `files/ghostty/*`

Extracted verbatim from `home/ghostty.nix`:
- `files/ghostty/config` — the `.config/ghostty/config` body.
- `files/ghostty/themes/dark-ergo` — the dark theme palette block.
- `files/ghostty/themes/light-ergo` — the light theme palette block.

These are symlinked regardless of whether Ghostty is installed (Ghostty cask is dropped); config is inert without the app and costs nothing.

## Idempotency

Every target is safe to re-run:
- `brew-install.sh` — no-ops if `brew` is present.
- `brew-bundle` — `brew bundle` already handles existing installs correctly.
- `symlinks.sh` — creating an existing symlink to the same target is a no-op; a differing regular file gets backed up exactly once (timestamp suffix avoids overwriting a prior backup).
- `macos-defaults.sh` — `defaults write` is naturally idempotent.
- `macos-defaults-sudo.sh` — same.
- Plug bootstrap curls overwrite the existing `plug.vim`; `PlugInstall` is a no-op if already installed.

## Rollback

Not a first-class feature. Backups at `<target>.pre-dotfiles.bak[.TIMESTAMP]` are retained by `symlinks.sh`. macOS defaults are not backed up (would require `defaults read` of every key before writing, which clutters the script). User can re-run `nix` path from `main` if they need to undo on a branch that still has it — but this branch doesn't, so rollback is manual.

## Testing plan

1. `make check` on a clean checkout with no conflicting dotfiles → all lines `+ create`, exit `1`.
2. `make install` on a clean checkout → every symlink created, Brewfile packages installed, defaults applied.
3. `make check` after `make install` → all lines `= ok`, exit `0`.
4. Manually edit `~/.zshrc` → `make check` shows `~ differ` with a unified diff for that file, exit `1`.
5. Replace `~/.gitconfig` with an unrelated file → `make install` backs it up to `~/.gitconfig.pre-dotfiles.bak`, creates the symlink, exit `0`.

## Open items deferred to implementation

- Verify whether `container` needs a tap; add if so.
- Verify whether `libdvdcss` needs the `videolan` tap; add if so.
- Confirm `github.user` value for the work account (currently carried forward as `douglasalbert`).
