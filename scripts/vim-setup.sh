#!/usr/bin/env bash
# Vim/Neovim setup: symlink vimrc, bootstrap vim-plug, install plugins.
# Safe to run standalone or after scripts/symlinks.sh.

set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./manifest.sh
source "$SCRIPT_DIR/manifest.sh"

# Clean up the legacy init.vim → files/vimrc symlink (pre-nvim.lua split).
legacy_init_vim="$HOME/.config/nvim/init.vim"
if [ -L "$legacy_init_vim" ]; then
  case "$(readlink "$legacy_init_vim")" in
    "$REPO_ROOT"/*)
      rm -f "$legacy_init_vim"
      echo "Removed legacy $legacy_init_vim"
      ;;
  esac
fi

# Link only vim-related entries from the manifest.
for entry in "${SYMLINKS[@]}"; do
  tgt="${entry#*:}"
  case "$tgt" in
    "$HOME/.vimrc"|"$HOME/.config/nvim/init.lua")
      link_entry "$entry"
      ;;
  esac
done

# Vim state directories
mkdir -p "$HOME/.vim/backups" "$HOME/.vim/swaps" "$HOME/.vim/colors"

# vim-plug bootstrap (idempotent)
PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/0.14.0/plug.vim"
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs "$PLUG_URL"
fi
if [ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
  curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs "$PLUG_URL"
fi

# Install/update plugins if the editors are present (best-effort)
if command -v vim >/dev/null 2>&1; then
  vim +PlugInstall +qall || true
fi
if command -v nvim >/dev/null 2>&1; then
  nvim +PlugInstall +qall || true
fi

echo "Vim setup complete."
