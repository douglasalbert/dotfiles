# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for macOS (Apple Silicon) installed via **Homebrew** +
**Makefile** + symlinks. This is the `non-nix-install` branch — the nix-darwin +
home-manager version lives on `main`.

## Commands

- `make check` — dry-run; print per-file status and diff without writing anything
- `make install` — full install: Homebrew + Brewfile + symlinks + vim + macOS defaults
- `make symlinks` — just the symlink pass
- `make vim` — symlink vimrc, bootstrap vim-plug, run :PlugInstall for vim + nvim
- `make macos-defaults` — user-scoped `defaults write` only
- `make macos-defaults-sudo` — system-scoped defaults (needs sudo)

## Architecture

```
Makefile                     # entry point — wraps the scripts/
Brewfile                     # brew bundle input (taps, brews, casks)
scripts/
├── manifest.sh              # shared: REPO_ROOT + SYMLINKS array + link_entry()
├── check.sh                 # dry-run; diffs existing files vs. repo sources
├── symlinks.sh              # create every symlink via link_entry()
├── vim-setup.sh             # symlink vimrc, bootstrap vim-plug, :PlugInstall
├── brew-install.sh          # install Homebrew if missing
├── macos-defaults.sh        # defaults write + PlistBuddy + chflags (user-scoped)
└── macos-defaults-sudo.sh   # system-scoped defaults (opt-in)
files/                       # source of truth for every dotfile (symlinked into $HOME)
├── profile.common           # shared env/PATH/aliases/function (sourced by bash + zsh)
├── zshrc                    # zsh-only: history, options, completion, integrations
├── bashrc                   # bash-only: shopt, integrations, completions
├── bash_profile             # sources bashrc for login shells
├── gitconfig                # global git config (work email)
├── gitignore_global         # core.excludesfile contents
├── tmux.conf
├── vimrc                    # shared by vim and nvim; plug block inline
├── ssh_config               # ~/.ssh/config
├── aerospace.toml
├── colima.yaml
└── ghostty/
    ├── config
    └── themes/{dark-ergo,light-ergo}
docs/superpowers/specs/2026-04-24-non-nix-install-design.md   # design doc
```

## Conventions

- `scripts/manifest.sh` is the single source of truth for what gets symlinked
  where — `check.sh` and `symlinks.sh` both source it.
- `files/profile.common` is installed at `~/.config/dotfiles/profile.common`;
  `files/zshrc` and `files/bashrc` source it from that path. The repo can live
  anywhere on disk.
- Conflicting regular files get backed up to `<target>.pre-dotfiles.bak` (or
  `.pre-dotfiles.bak.YYYYMMDDhhmmss` if a prior backup exists) — never
  silently overwritten.
- Target path already a directory → `symlinks.sh` aborts; resolve manually.
- Zsh uses vi keybindings (`bindkey -v`) with `^a`/`^e` overrides.
- Default editor is vim (set in `gitconfig`); neovim is installed for actual use.
- Machine-specific secrets go in `~/.bash_profile.local` (bash) or
  `~/.profile.local` (zsh), never in this repo.
- Architecture: `aarch64-darwin` (Apple Silicon).
