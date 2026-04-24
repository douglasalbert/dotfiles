#!/usr/bin/env bash
# System-scoped macOS defaults — require sudo.
# Split from macos-defaults.sh so `make install` stays non-interactive.

set -u

echo "Applying system-scoped macOS defaults (sudo required)…"

sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false
sudo defaults write com.apple.screensaver askForPassword -int 1
sudo defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "Done."
