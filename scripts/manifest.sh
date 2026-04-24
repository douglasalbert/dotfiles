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
  "$REPO_ROOT/files/nvim.lua:$HOME/.config/nvim/init.lua"
  "$REPO_ROOT/files/ssh_config:$HOME/.ssh/config"
  "$REPO_ROOT/files/aerospace.toml:$HOME/.config/aerospace/aerospace.toml"
  "$REPO_ROOT/files/colima.yaml:$HOME/.colima/default/colima.yaml"
  "$REPO_ROOT/files/ghostty/config:$HOME/.config/ghostty/config"
  "$REPO_ROOT/files/ghostty/themes/dark-ergo:$HOME/.config/ghostty/themes/dark-ergo"
  "$REPO_ROOT/files/ghostty/themes/light-ergo:$HOME/.config/ghostty/themes/light-ergo"
)

# link_entry "<source>:<target>"
# Create one symlink, backing up conflicting regular files. Aborts if target
# is a directory. Idempotent. Returns non-zero on error.
link_entry() {
  local entry="$1"
  local src="${entry%%:*}"
  local tgt="${entry#*:}"

  mkdir -p "$(dirname "$tgt")"

  if [ -d "$tgt" ] && [ ! -L "$tgt" ]; then
    echo "ERROR: $tgt is a directory; resolve manually" >&2
    return 1
  fi

  if [ -f "$tgt" ] && [ ! -L "$tgt" ]; then
    if cmp -s "$tgt" "$src"; then
      rm -f "$tgt"
    else
      local backup="$tgt.pre-dotfiles.bak"
      if [ -e "$backup" ]; then
        backup="$tgt.pre-dotfiles.bak.$(date +%Y%m%d%H%M%S)"
      fi
      mv "$tgt" "$backup"
      echo "Backed up $tgt → $backup"
    fi
  fi

  ln -sfn "$src" "$tgt"
  echo "Linked $tgt → $src"
}
