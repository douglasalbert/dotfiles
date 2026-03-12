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
    actionlint
    ast-grep
    colima
    docker-compose
    fd
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
    nodejs_22
    pnpm
    ripgrep
    shellcheck
    shfmt
    signal-cli
    tree
    uv
    wget
    zizmor
    zsh-completions
  ];

  # Keep prompt files as raw files (complex prompt logic)
  home.file.".bash_prompt".source = ../files/bash_prompt;
  home.file.".zsh_prompt".source = ../files/zsh_prompt;
  home.file.".config/aerospace/aerospace.toml".source = ../files/aerospace.toml;
}
