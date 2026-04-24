#!/usr/bin/env bash
# Install Homebrew if missing. No-op if already installed.

set -eu

if command -v brew >/dev/null 2>&1; then
  echo "Homebrew already installed at $(command -v brew)"
  exit 0
fi

echo "Installing Homebrew…"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Homebrew installed. Open a new shell or run:"
echo "  eval \"\$(/opt/homebrew/bin/brew shellenv)\""
