execute pathogen#infect()
:set nocompatible
syntax on
filetype plugin indent on
set tabstop=2 softtabstop=0 noexpandtab shiftwidth=2
set background=dark
colorscheme solarized
set t_Co=256
set term=xterm

"configuring better key combinations for cut, copy, paste in gvim
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+

"js code checker config for syntastic
let g:syntastic_javascript_checkers = ['eslint']

"auto folding of js files
au FileType javascript call JavaScriptFold()

"NERDTree on startup
autocmd VimEnter * NERDTree | wincmd p
