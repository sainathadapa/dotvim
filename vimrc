"general settings
set nocompatible
execute pathogen#infect()
syntax on
filetype plugin indent on
set showmode "show the mode i am in
set tabstop=2 softtabstop=0 noexpandtab shiftwidth=2 "tab size is 2 space
set t_Co=256
set term=xterm

"using dark solarized scheme
set background=dark
colorscheme solarized

"configuring better key combinations for cut, copy, paste in gvim
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+

"NERDTree on startup
autocmd VimEnter * NERDTree | wincmd p
set showcmd

"quit vim if the NERDTree is the only window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"hybrid line numbering mode
set number
set relativenumber

"search settings
set hlsearch
set incsearch

"indents
set autoindent
set smartindent

" folding enable
if has("folding")
	set foldenable
endif

"bind space to leader
let mapleader = "\<Space>"

""""""language specific settings""""""

"indent all parts of html
let g:html_indent_inctags = "html,body,head,tbody" 

"js code checker config for syntastic
let g:syntastic_javascript_checkers = ['eslint']
