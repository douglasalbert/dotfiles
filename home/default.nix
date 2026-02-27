{ pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./tmux.nix
    ./vim.nix
    ./ghostty.nix
  ];

  home.username = "da";
  home.homeDirectory = "/Users/da";
  home.stateVersion = "24.05";
  home.enableNixpkgsReleaseCheck = false;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    colima
    docker-compose
    fzf
    gh
    go
    gst_all_1.gstreamer
    jq
    just
    libdvdcss
    markdownlint-cli2
    mediainfo
    mosh
    neovim
    ripgrep
    shellcheck
    signal-cli
    tree
    wget
    zsh-completions
  ];

  # Keep prompt files as raw files (complex prompt logic)
  home.file.".bash_prompt".source = ../files/bash_prompt;
  home.file.".zsh_prompt".source = ../files/zsh_prompt;
  home.file.".config/aerospace/aerospace.toml".source = ../files/aerospace.toml;
}
