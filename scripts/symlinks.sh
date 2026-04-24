#!/usr/bin/env bash
# Create symlinks per scripts/manifest.sh. Back up conflicting regular files.

set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./manifest.sh
source "$SCRIPT_DIR/manifest.sh"

for entry in "${SYMLINKS[@]}"; do
  src="${entry%%:*}"
  tgt="${entry#*:}"

  mkdir -p "$(dirname "$tgt")"

  # A directory at the target is never safe to replace silently.
  if [ -d "$tgt" ] && [ ! -L "$tgt" ]; then
    echo "ERROR: $tgt is a directory; resolve manually" >&2
    exit 1
  fi

  # Regular file: keep it as a backup unless content matches.
  if [ -f "$tgt" ] && [ ! -L "$tgt" ]; then
    if cmp -s "$tgt" "$src"; then
      rm -f "$tgt"
    else
      backup="$tgt.pre-dotfiles.bak"
      if [ -e "$backup" ]; then
        backup="$tgt.pre-dotfiles.bak.$(date +%Y%m%d%H%M%S)"
      fi
      mv "$tgt" "$backup"
      echo "Backed up $tgt → $backup"
    fi
  fi

  ln -sfn "$src" "$tgt"
  echo "Linked $tgt → $src"
done

# SSH permissions
if [ -d "$HOME/.ssh" ]; then
  chmod 700 "$HOME/.ssh"
fi
if [ -e "$HOME/.ssh/config" ]; then
  chmod 600 "$HOME/.ssh/config"
fi

# Vim state directories
mkdir -p "$HOME/.vim/backups" "$HOME/.vim/swaps" "$HOME/.vim/colors"

# vim-plug bootstrap (idempotent; skips if plug.vim already installed)
PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/0.14.0/plug.vim"
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs "$PLUG_URL"
fi
if [ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
  curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs "$PLUG_URL"
fi

# Install plugins if editors are present (best-effort; skipped if missing)
if command -v vim >/dev/null 2>&1; then
  vim +PlugInstall +qall || true
fi
if command -v nvim >/dev/null 2>&1; then
  nvim +PlugInstall +qall || true
fi

echo "Symlinks applied."
