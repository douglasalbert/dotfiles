"
" plugins
"
call g:plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline-themes'
Plug 'sheerun/vim-polyglot'

call g:plug#end()

" airline config
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" solarized settings
syntax enable
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized


"
" Global settings
"
set nocompatible
filetype off
filetype plugin indent on
set noerrorbells
set novisualbell
set number
set nobackup
set nowritebackup
set autowrite
set autoread
set showcmd
set laststatus=2
set hidden

set ruler
set nostartofline

set nocursorcolumn
set nocursorline

set encoding=utf-8
set fileformats=unix,dos,mac

set wildmode=longest,list,full
set wildmenu
set hlsearch
set incsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set confirm
set t_vb=

if has('mouse')
    set mouse=a
endif

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

"
" Formatting options
"
set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=79
set relativenumber

" Highlight unwanted whitespace
set listchars=tab:>.,trail:.,extends:\#,nbsp:.

set autoindent
set complete-=i
set showmatch
set smarttab

set shiftwidth=4
set softtabstop=4
set expandtab

set switchbuf=usetab,newtab

" Autocompletion helpers
set completeopt=longest,menuone
set tags=./tags,tags;


"
" autocmd
"
if has ("autocmd")

  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=72

    " last known good cursor location
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") |
          \	exe "normal! g`\"" |
          \ endif

    autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

  augroup END
else
endif " has("autocmd")

"
" Mappings
"

let mapleader = ","
let g:mapleader = ","

" strip trailing whitespace
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" Arrow key navigation
nnoremap <Right> <C-w>l
nnoremap <Left> <C-w>h
nnoremap <Up> <C-w>k
nnoremap <Down> <C-w>j

" Navigate tabs using hjkl
nnoremap th  :tabprev<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tabnext<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabnext<Space>
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>
