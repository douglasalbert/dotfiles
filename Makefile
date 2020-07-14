.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: install
install: ## Installs the dotfiles.
	# add aliases for dotfiles
	ln -fn $(CURDIR)/.aliases $(HOME)/.aliases
	ln -fn $(CURDIR)/.exports $(HOME)/.exports
	ln -fn $(CURDIR)/.functions $(HOME)/.functions
	ln -fn $(CURDIR)/.gitconfig $(HOME)/.gitconfig
	ln -fn $(CURDIR)/.gitignore_global $(HOME)/.gitignore_global
	ln -fn $(CURDIR)/.bash_prompt $(HOME)/.bash_prompt
	ln -fn $(CURDIR)/.bashrc $(HOME)/.bashrc
	ln -fn $(CURDIR)/.zshrc $(HOME)/.zshrc
	ln -fn $(CURDIR)/.zsh_prompt $(HOME)/.zsh_prompt
	ln -fn $(CURDIR)/.tmux.conf $(HOME)/.tmux.conf
	mkdir -p $(HOME)/.config;
	mkdir -p $(HOME)/.local/share;
	ln -snf $(CURDIR)/.fonts $(HOME)/.local/share/fonts;
	ln -snf $(CURDIR)/.bash_profile $(HOME)/.profile;
