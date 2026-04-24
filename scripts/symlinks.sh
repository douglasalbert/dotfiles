#!/usr/bin/env bash
# Create every symlink in scripts/manifest.sh.

set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./manifest.sh
source "$SCRIPT_DIR/manifest.sh"

for entry in "${SYMLINKS[@]}"; do
  link_entry "$entry"
done

# SSH permissions (safe to run whenever the symlink exists)
if [ -d "$HOME/.ssh" ]; then
  chmod 700 "$HOME/.ssh"
fi
if [ -e "$HOME/.ssh/config" ]; then
  chmod 600 "$HOME/.ssh/config"
fi

echo "Symlinks applied."
