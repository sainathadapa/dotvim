"general settings
set nocompatible
execute pathogen#infect()

set foldmethod=indent

if has('syntax') && !exists('g:syntax_on')
  " enable syntax highlighting
  syntax enable
  set foldmethod=syntax
endif

filetype plugin indent on

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

"NERDTree on startup
autocmd VimEnter * NERDTree | wincmd p
set showcmd

"quit vim if the NERDTree is the only window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

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
set swapfile
set directory=$TMPDIR,~/tmp,~/.vim/tmp,/tmp,/var/tmp
set backup
set backupdir=$TMPDIR,~/tmp,~/.vim/tmp,/tmp,/var/tmp

" Extend our undoable steps and preserve over restart (if available)
if has('persistent_undo')
  set undodir=$TMPDIR,~/tmp,~/.vim/tmp,/tmp,/var/tmp
  set undofile
  set undoreload=10000
end
set undolevels=10000

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
endif

" Command Sw will 'sudo write' the file
" Useful when you forget to open the file as root
command! Sw silent w !sudo tee %

""""""language specific settings""""""

"indent all parts of html
let g:html_indent_inctags = "html,body,head,tbody" 

