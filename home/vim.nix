{ config, pkgs, lib, ... }:

let
  vimPlug = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/junegunn/vim-plug/0.14.0/plug.vim";
    hash = "sha256-ILTIlfmNE4SCBGmAaMTdAxcw1OfJxLYw1ic7m5r83Ns=";
  };
in
{
  # Place vimrc
  home.file.".vimrc".source = ../files/vimrc;

  # vim-plug autoload
  home.file.".vim/autoload/plug.vim".source = vimPlug;

  # Directories for backups, swaps, colors
  home.file.".vim/backups/.keep".text = "";
  home.file.".vim/swaps/.keep".text = "";
  home.file.".vim/colors/.keep".text = "";

  # Neovim shares the same config
  xdg.configFile."nvim/init.vim".source = ../files/vimrc;
  xdg.configFile."nvim/autoload/plug.vim".source = vimPlug;
}
