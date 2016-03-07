"general settings
set nocompatible
set foldmethod=manual
set showcmd
filetype plugin indent on

"Plugins
call plug#begin('~/.vim/plugged')
"Make sure you use single quotes
Plug 'ajh17/VimCompletesMe'
Plug 'gregsexton/MatchTag'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/vim-sneak'
Plug 'kchmck/vim-coffee-script'
Plug 'kien/ctrlp.vim'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'mbbill/undotree'
Plug 'pangloss/vim-javascript'
Plug 'scrooloose/nerdcommenter'
Plug 'stephpy/vim-yaml'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
" Add plugins to &runtimepath
call plug#end()


if has('syntax') && !exists('g:syntax_on')
  " enable syntax highlighting
  syntax enable
  set foldmethod=syntax
endif

"show the mode i am in
set showmode 

set tabstop=2 softtabstop=0 expandtab shiftwidth=2

" show a visual line under the cursor's current line 
set cursorline

" show the matching part of the pair for [] {} and ()
set showmatch

"colorscheme
set background=dark
if has("gui_running")
  colorscheme hybrid_material
else
  colorscheme peachpuff
endif

"list of good colorschemes by dominant color in the palette
"BLUE
"base16-harmonic16
"base16-flat
"base16-ocean
"
"BROWN
"base16-eighties
"base16-mocha

"configuring normal os key combinations for cut, copy, paste
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+

"Start undotree automatically on startup
autocmd vimenter * UndotreeToggle

"hybrid line numbering mode
set number
set relativenumber

" search as characters are entered
set incsearch 
" highlight matches
set hlsearch          
" searches are case insensitive...
set ignorecase    
" ... unless they contain at least one capital letter
set smartcase     

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

"turn off search highlight with double space
nnoremap <leader><space> :nohlsearch<CR>

set backspace=indent,eol,start

" Write swap and backup files in the event of a crash or accident
set undodir=~/.vim/.undo//
set undofile
set undolevels=1000
set undoreload=10000
set backupdir=~/.vim/.backup//
set directory=~/.vim/.swp//

" mouse works in most terminal software we use...
set mouse=a

" fold settings
set foldlevelstart=1
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1

" Remove menu options for GVim
if has("gui_running")
  set guioptions -=m
  set guioptions -=T
  set guioptions -=r
  set guifont=Source\ Code\ Pro\ Medium\ 10
endif

" Command Sw will 'sudo write' the file
" Useful when you forget to open the file as root
command! Sw silent w !sudo tee %

" indent all parts of html
let g:html_indent_inctags = "html,body,head,tbody" 

" use sneak as a alternative to EasyMotion
let g:sneak#streak = 1
