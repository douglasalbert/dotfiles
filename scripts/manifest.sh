#!/usr/bin/env bash
# Shared symlink manifest — source from other scripts.
# Each entry is "<source-in-repo>:<target-in-$HOME>".

# shellcheck disable=SC2034
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck disable=SC2034
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
