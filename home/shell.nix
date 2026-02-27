{ pkgs, ... }:

let
  shellAliases = {
    # Docker
    dk = "docker";
    dkps = "docker ps";
    dki = "docker inspect";
    dkr = "docker restart";
    dkl = "docker logs --tail=20 -f";
    dkc = "docker-compose";

    # Filesystem
    l = "ls -hFG";
    ls = "ls -hFG";
    ll = "ls -lhFG";
    la = "ls -Al";
    lk = "ls -lSr";
    lc = "ls -ltcr";
    lu = "ls -ltur";
    lt = "ls -ltr";
    lm = "ls -al |more";
    lr = "ls -lR";
    tree = "tree -Csu";
    ".." = "cd ..";
  };

  shellFunctions = ''
    dotcleanunmount() {
      dot_clean -m "$1"
      if [ -d "$1/.Spotlight-V100" ]; then
        rm -rf "$1/.Spotlight-V100"
      fi
      if [ -d "$1/Trashes" ]; then
        rm -rf "$1/Trashes"
      fi
      if [ -d "$1/.fseventsd" ]; then
        rm -rf "$1/.fseventsd"
      fi
      diskutil unmount "$1"
    }
  '';
in
{
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "urxvt";
    HISTSIZE = "50000000";
    HISTFILESIZE = "50000000";
    HISTCONTROL = "ignoredups";
    HISTIGNORE = " *:ls:cd:cd -:pwd:exit:date:* --help:* -h:pony:pony add *:pony update *:pony save *:pony ls:pony ls *";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    MANPAGER = "less -X";
    SSH_AUTH_SOCK = "/usr/local/var/run/yubikey-agent.sock";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "/usr/local/bin"
  ];

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.bash = {
    enable = true;
    inherit shellAliases;

    shellOptions = [
      "checkwinsize"
      "nocaseglob"
      "histappend"
      "cdspell"
      "autocd"
      "globstar"
    ];

    initExtra = ''
      ${shellFunctions}

      # Source local machine-specific config
      if [[ -r "$HOME/.bash_profile.local" ]] && [[ -f "$HOME/.bash_profile.local" ]]; then
        source "$HOME/.bash_profile.local"
      fi

      # SSH hostname completion
      [[ -e "$HOME/.ssh/config" ]] && complete -o "default" \
        -o "nospace" \
        -W "$(grep "^Host" ~/.ssh/config | \
        grep -v "[?*]" | cut -d " " -f2 | \
        tr ' ' '\n')" scp sftp ssh

      # kubectl completion
      if hash kubectl 2>/dev/null; then
        source <(kubectl completion bash)
      fi
    '';
  };

  programs.zsh = {
    enable = true;
    inherit shellAliases;

    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zsh_history";
      extended = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    enableCompletion = true;
    completionInit = ''
      zstyle ':completion:*' menu select
      zstyle ':completion:*' completer _complete
      zstyle ':completion:*' matcher-list "" "m:{[:lower:][:upper:]}={[:upper:][:lower:]}" "+l:|=* r:|=*"
      autoload -U compinit && compinit
      zmodload -i zsh/complist
    '';

    initContent = ''
      # Options
      unsetopt menu_complete
      unsetopt flowcontrol
      setopt prompt_subst
      setopt always_to_end
      setopt auto_menu
      setopt complete_in_word
      setopt hist_verify
      setopt inc_append_history
      setopt interactivecomments

      # Vi keybindings with emacs overrides for line navigation
      bindkey -v
      bindkey '^a' beginning-of-line
      bindkey '^e' end-of-line

      ${shellFunctions}

      # Source fzf config
      if [[ -f "$HOME/.fzf.zsh" ]]; then
        source "$HOME/.fzf.zsh"
      fi

      # Source local machine-specific config
      if [[ -r "$HOME/.profile.local" ]] && [[ -f "$HOME/.profile.local" ]]; then
        source "$HOME/.profile.local"
      fi
    '';
  };
}
