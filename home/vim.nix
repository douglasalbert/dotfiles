{ pkgs, ... }:

let
  vimPlug = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/junegunn/vim-plug/0.14.0/plug.vim";
    hash = "sha256-ILTIlfmNE4SCBGmAaMTdAxcw1OfJxLYw1ic7m5r83Ns=";
  };

  vimPlugHeader = ''
    call plug#begin()
    Plug 'tpope/vim-fugitive'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'sheerun/vim-polyglot'
    Plug 'nanotee/zoxide.vim'
    call plug#end()

  '';
in
{
  home.file.".vimrc".text = vimPlugHeader + builtins.readFile ../files/vimrc;
  home.file.".vim/autoload/plug.vim".source = vimPlug;
  home.file.".vim/backups/.keep".text = "";
  home.file.".vim/swaps/.keep".text = "";
  home.file.".vim/colors/.keep".text = "";
}
