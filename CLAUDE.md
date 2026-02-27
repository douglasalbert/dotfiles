# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for macOS (Apple Silicon), managed declaratively with **nix-darwin** (system-level macOS config) + **home-manager** (user-level dotfiles/packages). Supports both bash and zsh shells.

## Commands

- `darwin-rebuild switch --flake .` — Apply system + home-manager config
- `nix flake check` — Validate flake syntax
- `nix flake update` — Update flake inputs (nixpkgs, nix-darwin, home-manager)

## Architecture

```
flake.nix                  # Flake entry point (aarch64-darwin, host=daMacStudio)
hosts/default.nix          # nix-darwin system config (macOS defaults from bin/.macos)
home/
├── default.nix            # home-manager entry (imports, packages, file mappings)
├── shell.nix              # bash + zsh config (aliases, exports, functions, path)
├── git.nix                # programs.git config (aliases, extraConfig, ignores)
├── tmux.nix               # programs.tmux config
└── vim.nix                # vim/neovim config (vimrc, vim-plug, shared nvim setup)
files/
├── bash_prompt            # Raw bash prompt file (sourced via initExtra)
├── zsh_prompt             # Raw zsh prompt file (sourced via initExtra)
└── vimrc                  # Raw vimrc (vim-plug plugins, settings, mappings)
bin/.macos                 # Legacy macOS defaults script (kept as reference)
```

### Shell startup

**Bash**: home-manager sets shellOptions, shellAliases, sessionVariables, sessionPath, then `initExtra` sources `~/.bash_prompt`, functions, and `~/.bash_profile.local`.

**Zsh**: home-manager sets history, completions, shellAliases, sessionVariables, sessionPath, then `initExtra` sets zsh options, vi keybindings, sources `~/.zsh_prompt`, `~/.fzf.zsh`, functions, and `~/.profile.local`.

## Key Files

| Nix File | Purpose |
|---|---|
| `home/shell.nix` | Shell aliases, exports, PATH, functions, bash/zsh options |
| `home/git.nix` | Git aliases, core config, URL rewrites, global ignores |
| `home/tmux.nix` | tmux keybindings, mouse, status bar styling |
| `home/vim.nix` | vim/neovim shared config, vim-plug bootstrap, directory setup |
| `hosts/default.nix` | macOS system defaults (Dock, Finder, trackpad, screenshots, app prefs) |

## Conventions

- Zsh uses vi keybindings (`bindkey -v`) with `^a`/`^e` overrides for line navigation
- Git is configured for SSH push via `git@github.com:` URL rewriting
- Vim and neovim share the same vimrc; plugins are managed by vim-plug (run `:PlugInstall` after changes to plugin list)
- Default editor is nvim
- Machine-specific secrets belong in `.bash_profile.local` (bash) or `.profile.local` (zsh), not in this repo
- Architecture: `aarch64-darwin` (Apple Silicon)
- Hostname: `daMacStudio`
