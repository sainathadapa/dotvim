"general settings
set nocompatible
execute pathogen#infect()
syntax on
filetype plugin indent on
set showmode "show the mode i am in
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 "tab size is 2 space

"colorscheme
set background=dark
if has("gui_running")
	colorscheme base16-mocha
else
	colorscheme peachpuff
endif

"list of good colorschemes by shade
"BLUE
"base16-harmonic16
"base16-flat
"base16-ocean
"
"BROWN
"base16-eighties
"base16-mocha

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

"switch : and ;
nnoremap ; :
nnoremap : ;

"enable neocomplete
if has("gui_running")
	let g:neocomplete#enable_at_startup = 1
endif

""""""language specific settings""""""

"indent all parts of html
let g:html_indent_inctags = "html,body,head,tbody" 

"js code checker config for syntastic
"let g:syntastic_javascript_checkers = ['eslint']

