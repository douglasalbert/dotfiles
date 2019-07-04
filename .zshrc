#!/usr/bin/env zsh

export DOTFILES=$HOME/.dotfiles
# export INCLUDES=$HOME/.local/share/dotfiles

for file in $DOTFILES/.{aliases,functions,path,bash_profile.local,exports}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		# shellcheck source=/dev/null
		source "$file"
	fi
done
unset file
# eval `dircolors $DOTFILES/dircolors`
# 
# source $INCLUDES/zsh-completions/zsh-completions.plugin.zsh
# source $INCLUDES/zsh-history-substring-search/zsh-history-substring-search.zsh
# source $INCLUDES/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

autoload -U compinit && compinit
zmodload -i zsh/complist

unsetopt menu_complete
unsetopt flowcontrol

setopt prompt_subst
setopt always_to_end
setopt append_history
setopt auto_menu
setopt complete_in_word
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt interactivecomments
setopt share_history

bindkey -v

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

source $HOME/.zsh_prompt
# source $HOME/.fzf.zsh
