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
    HISTSIZE = "50000000";
    HISTFILESIZE = "50000000";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "less -X";
    DOCKER_HOST = "unix://$HOME/.colima/default/docker.sock";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "/Applications/Obsidian.app/Contents/MacOS"
  ];

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
      identityFile = "~/.ssh/id_ed25519";
    };
  };

  programs.fzf = {
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
      size = 50000000;
      save = 50000000;
      extended = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    syntaxHighlighting.enable = true;
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
      setopt interactivecomments

      # Vi keybindings with emacs overrides for line navigation
      bindkey -v
      bindkey '^a' beginning-of-line
      bindkey '^e' end-of-line

      ${shellFunctions}

      # Source local machine-specific config
      if [[ -r "$HOME/.profile.local" ]] && [[ -f "$HOME/.profile.local" ]]; then
        source "$HOME/.profile.local"
      fi
    '';
  };
}
