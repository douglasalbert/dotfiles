{ pkgs, lib, ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./tmux.nix
    ./vim.nix
    ./nvim.nix
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
    nil
    nodejs_22
    pnpm
    ripgrep
    shellcheck
    shfmt
    signal-cli
    television
    tree
    uv
    wget
    zizmor
    zsh-completions
  ];

  home.file.".config/aerospace/aerospace.toml".source = ../files/aerospace.toml;

  home.activation.piTools = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/.pi/agent/bin
    ln -sf "$(readlink -f /etc/profiles/per-user/da/bin/fd)" $HOME/.pi/agent/bin/fd
    ln -sf "$(readlink -f /etc/profiles/per-user/da/bin/rg)" $HOME/.pi/agent/bin/rg
  '';
}
