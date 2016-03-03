"""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins using Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""
" please see https://github.com/VundleVim/Vundle.vim
" for more information

" set the runtime path to include Vundle and initialize
set rtp+=$VIMDIR/plugins/Vundle.vim
call vundle#begin($VIMDIR . "/plugins")

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" General
Plugin 'airblade/vim-gitgutter'
Plugin 'benmills/vimux'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'edkolev/tmuxline.vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'gorodinskiy/vim-coloresque'
Plugin 'gregsexton/gitv'
Plugin 'junegunn/vim-easy-align'
Plugin 'mattn/emmet-vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'Shougo/neocomplete.vim' " requries Lua (vim-nox on ubuntu)
Plugin 'sjl/gundo.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'thinca/vim-quickrun'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-surround'
Plugin 'wincent/command-t'
Plugin 'YankRing.vim'
Plugin 'Yggdroot/indentLine'

" Syntax
Plugin 'groenewege/vim-less'
Plugin 'hdima/python-syntax'
Plugin 'isRuslan/vim-es6'
Plugin 'kchmck/vim-coffee-script'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'mxw/vim-jsx'
Plugin 'othree/html5.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'rodjek/vim-puppet'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-rake'
Plugin 'vim-ruby/vim-ruby'

" NERDTree extras
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'jistr/vim-nerdtree-tabs'

" Syntastic extras
Plugin 'myint/syntastic-extras'

" Neocomplete extras
Plugin 'Shougo/neosnippet'
Plugin 'Shougo/neosnippet-snippets'

" Status line
Plugin 'itchyny/lightline.vim'
"Plugin 'maciakl/vim-neatstatus.git' " good alternative

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ

" == Plugins Config ============================================================
