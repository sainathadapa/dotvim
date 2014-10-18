execute pathogen#infect()
:set nocompatible
syntax on
filetype plugin indent on
set tabstop=2 softtabstop=0 noexpandtab shiftwidth=2
set background=dark
colorscheme solarized
set t_Co=256
set term=xterm
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+
