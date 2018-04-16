set encoding=utf-8
set nocompatible
set foldmethod=manual
set showcmd
filetype plugin indent on

"Plugins
call plug#begin('~/.vim/plugged')
"Make sure you use single quotes
"Plug 'ajh17/VimCompletesMe'
"Plug 'gregsexton/MatchTag'
"Plug 'kchmck/vim-coffee-script'
"Plug 'pangloss/vim-javascript'
Plug 'Shougo/deoplete.nvim'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kien/ctrlp.vim'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'mbbill/undotree'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'scrooloose/nerdcommenter'
Plug 'stephpy/vim-yaml'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale' "Syntax checking
Plug 'zchee/deoplete-jedi'
Plug 'luochen1990/rainbow'
call plug#end()

if has('syntax') && !exists('g:syntax_on')
  " enable syntax highlighting
  syntax enable
  set foldmethod=syntax
endif

"show the mode i am in
set showmode 

set tabstop=2 softtabstop=0 expandtab shiftwidth=2
" python special settings
au FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4

" show a visual line under the cursor's current line 
set cursorline

" show the matching part of the pair for [] {} and ()
set showmatch

"colorscheme
if has("gui_running")
  set background=dark
  colorscheme hybrid_material
else
  colorscheme desert
endif

"configuring normal os key combinations for cut, copy, paste
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+

"Start undotree automatically on startup
"autocmd vimenter * UndotreeToggle
"let g:undotree_HighlightChangedText = 0

"hybrid line numbering mode
set number
set relativenumber

" search as characters are entered
set incsearch 
" highlight matches
set hlsearch          
" clear highlighting
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>
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

"turn off search highlight with double space
nnoremap <leader><space> :nohlsearch<CR>

" Make the backspace behave as most applications. 
" Vim's default behaviour when pressing the backspacing is somewhat peculiar, it
" won’t allow you to backspace to the previous line, automatically inserted
" indentation, or previously inserted text.
set backspace=indent,eol,start

" Store temporary files in ~/.vim/tmp  By default Vim will store various
" files in the current directory. These files are useful, but storing them in
" the current directory next to the original file usually isn’t.
"
" With this enabled Vim will store all these files in the user’s home directory.
set viminfo+=n~/.vim/tmp/viminfo
set backupdir=$HOME/.vim/tmp/backup
set dir=$HOME/.vim/tmp/swap
set viewdir=$HOME/.vim/tmp/view
if !isdirectory(&backupdir) | call mkdir(&backupdir, 'p', 0700) | endif
if !isdirectory(&dir)       | call mkdir(&dir, 'p', 0700)       | endif
if !isdirectory(&viewdir)   | call mkdir(&viewdir, 'p', 0700)   | endif

" Persist undo history between Vim sessions.  Store undo history to a file,
" so that it can be recalled in future Vim sessions.
"
" Also see "How can I use the undofile?": https://vi.stackexchange.com/q/6/51
" and "Can I be notified when I'm undoing changes from the undofile?":
" https://vi.stackexchange.com/q/2115/51.
if has('persistent_undo')
	set undodir=$HOME/.vim/tmp/undo
	if !isdirectory(&undodir) | call mkdir(&undodir, 'p', 0700) | endif
  set undolevels=1000
  set undoreload=10000
endif

" mouse works in most terminal software we use...
set mouse=a

" fold settings
" set foldlevelstart=1
" set foldnestmax=10      "deepest fold is 10 levels
" set nofoldenable        "dont fold by default
" set foldlevel=1

" Remove menu options for GVim
if has("gui_running")
  set guioptions -=m
  set guioptions -=T
  set guioptions -=r
  set guifont=Source\ Code\ Pro\ Medium\ 12
endif

" indent all parts of html
" let g:html_indent_inctags = "html,body,head,tbody" 

" Press C-r in visual mode to replace the text highlighted
" vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" Activate deoplete
let g:deoplete#enable_at_startup = 1

" Activate rainbow parentheses
let g:rainbow_active = 1

" python linter for ale
let g:ale_linters = {'python': ['flake8']}

" Show as much of the line as will fit.  By default Vim will display only
" "@" characters if the last line on the screen won't fit when 'wrap' is
" enabled.
"
" If this is enabled Vim will display as much as the last line as will fit and
" display "@@@" at the end.
"
" There is another useful option for 'display' that I rather like: "uhex". This
" will make Vim show unprintable characters as &lt;xx&gt; rather than ^L (Use
" |i_CTRL-V| in insert mode to see the difference.)
set display=lastline

" Better tab completion in the commandline.  Make commandline-completion
" (after you type :) behave more useful and roughly like most shells do.
"
" See 'wildmode' on how to configure the completion mode to your liking.
" 'wildignore' is also a useful setting to ignore binary files such as compiler
" output, images, etc.
set wildmenu

set wildmode=list:longest  " List all matches and complete to the longest match.

" Remove octal support from 'nrformats'.  This controls how Vim should
" interpret numbers when pressing |CTRL-A| or |CTRL-X| to increment to decrement
" a number. By default numbers starting with a 0 are treated as octal numbers,
" which can be rather confusing, so remove that.
set nrformats-=octal

" Minimum number of lines to keep above/below cursor.  Keep lines above and
" below the screen when scrolling up or down. This is useful so you have some
" context what you’re scrolling to.
"
" Also see 'sidescrolloff'.
set scrolloff=5

" Load matchit.vim plugin.  The matchit.vim plugin that comes bundled with
" Vim expands the |%| key to work with various programming language keywords
" (e.g. jumping between if and end in Ruby).
" Only load if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
	runtime! macros/matchit.vim
endif

