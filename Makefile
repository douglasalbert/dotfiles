.PHONY: help install check brew-install brew-bundle symlinks vim macos-defaults macos-defaults-sudo

help:
	@echo "Targets:"
	@echo "  check                 Dry-run: show per-file diff without modifying anything"
	@echo "  install               Full install (brew + bundle + symlinks + vim + macos-defaults)"
	@echo "  brew-install          Install Homebrew if missing"
	@echo "  brew-bundle           brew bundle --file=./Brewfile"
	@echo "  symlinks              Create symlinks per scripts/manifest.sh"
	@echo "  vim                   Symlink vimrc, bootstrap vim-plug, run :PlugInstall"
	@echo "  macos-defaults        Apply user-scoped macOS defaults"
	@echo "  macos-defaults-sudo   Apply system-scoped macOS defaults (prompts for sudo)"

install: brew-install brew-bundle symlinks vim macos-defaults

check:
	@./scripts/check.sh

brew-install:
	@./scripts/brew-install.sh

brew-bundle:
	@brew bundle --file=./Brewfile

symlinks:
	@./scripts/symlinks.sh

vim:
	@./scripts/vim-setup.sh

macos-defaults:
	@./scripts/macos-defaults.sh

macos-defaults-sudo:
	@./scripts/macos-defaults-sudo.sh
