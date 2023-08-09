set foldmethod=manual

"Plugins
"Make sure you use single quotes
call plug#begin('~/.config/nvim/plugged')
Plug 'tpope/vim-sensible' "a universal set of defaults that everyone can agree on
Plug 'Vimjas/vim-python-pep8-indent' "modifies Vim’s indentation behavior to comply with PEP8
"Plug 'easymotion/vim-easymotion'
"Plug 'junegunn/vim-easy-align'  "
Plug 'ctrlpvim/ctrlp.vim' "Ctrl-p shortcut to find files
Plug 'kristijanhusak/vim-hybrid-material' "theme
"Plug 'NLKNguyen/papercolor-theme' "theme
"Plug 'junegunn/rainbow_parentheses.vim'  "Different colors for different bracket pairs
Plug 'luochen1990/rainbow' "Rainbow parentheses
Plug 'machakann/vim-highlightedyank' "highlight the yanked region
Plug 'mbbill/undotree'
Plug 'nelstrom/vim-visual-star-search' "This allows you to select some text using Vim's visual mode and then hit * and # to search for it elsewhere in the file.  For example, hit V, select a strange sequence of characters and hit star.  You'll find all other runs in the file.
Plug 'neoclide/coc.nvim', {'branch': 'release'} "Autocomplete plugin
"Plug 'scrooloose/nerdcommenter'
"Plug 'scrooloose/nerdtree' "Filetree
Plug 'sheerun/vim-polyglot' "Add syntax highlighting for almost any language
Plug 'stephpy/vim-yaml'
Plug 'tpope/vim-markdown'
"Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating' "for incrementing dates
Plug 'tpope/vim-surround' "cs<doublequote><singlequote> to change a pair of double quotes to single quotes
Plug 'unblevable/quick-scope' "Highlights some characters to help with f/F/t/T motions
"Plug 'zefei/vim-colortuner' "Adjust colors using sliders, :Colortuner
Plug 'airblade/vim-rooter' "Automatically change directory based on file directory
Plug 'axvr/org.vim'  "Org-mode syntax highlighting
"Plug 'kristijanhusak/orgmode.nvim'
Plug 'wellle/context.vim'  "Show the context (e.g. function's first line)
"Plug 'terryma/vim-expand-region' "expand visual selection incrementally (use the + key)
Plug 'gennaro-tedesco/nvim-peekup' "Open the peekup window with the default keymapping <double quote><double quote>. Scroll and browse the list of registers ordered by type and select the register you want by simply pressing the corresponding character (letter or number, no need to prepend <duoble quote>): you receive visual confirmation for your choice and the text is copied into the default register. The peekup window automatically closes and you can now easily put (p) your yanked text anywhere you want.
call plug#end()

if has('syntax') && !exists('g:syntax_on')
  " enable syntax highlighting
  syntax enable
  set foldmethod=syntax
endif

"show the mode i am in
set showmode 

" Use a visual bell instead of beeping
set visualbell

" tab and space settings
set tabstop=2 softtabstop=0 expandtab shiftwidth=2
" python special settings
au FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4

" Enable rainbow parentheses
let g:rainbow_active = 1

" By default python-mode uses python 2 syntax checking. To enable python 3 syntax checking
let g:pymode_python = 'python3'
" don't use rope completion for python
let g:pymode_rope_complete_on_dot = 0
" disable colorcolumn display at maxlength
let g:pymode_options_colorcolumn = 0

" show a visual line under the cursor's current line 
set cursorline

" show the matching part of the pair for [] {} and ()
set showmatch

colorscheme hybrid_material

" Make comments appear in italics
" from https://rsapkf.netlify.com/blog/enabling-italics-vim-tmux
highlight Comment cterm=italic

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
" searches are case insensitive...
set ignorecase    
" ... unless they contain at least one capital letter
set smartcase     

"indents
set autoindent

" folding enable
if has("folding")
  set foldenable
endif

"bind space to leader
let mapleader = "\<Space>"

"switch : and ;
nnoremap ; :
nnoremap : ;

" change the direction of new splits
" https://vimtricks.com/p/open-splits-more-naturally/
set splitbelow
set splitright

"turn off search highlight with double space
nnoremap <leader><space> :nohlsearch<CR>

" Make the backspace behave as most applications. 
" Vim's default behaviour when pressing the backspacing is somewhat peculiar, it
" won’t allow you to backspace to the previous line, automatically inserted
" indentation, or previously inserted text.
set backspace=indent,eol,start

" netrw settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END

" Store temporary files in ~/.vim/tmp  By default Vim will store various
" files in the current directory. These files are useful, but storing them in
" the current directory next to the original file usually isn’t.
"
" With this enabled Vim will store all these files in the user’s home directory.
set viminfo+=n~/.config/nvim/tmp/viminfo
set backupdir=$HOME/.config/nvim/tmp/backup
set dir=$HOME/.config/nvim/tmp/swap
set viewdir=$HOME/.config/nvim/tmp/view
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
  set undofile " Maintain undo history between sessions
  set undodir=$HOME/.config/nvim/tmp/undo
  if !isdirectory(&undodir) | call mkdir(&undodir, 'p', 0700) | endif
  set undolevels=1000
  set undoreload=10000
endif

" mouse works in most terminal software we use...
set mouse+=a

" fold settings
" set foldlevelstart=1
" set foldnestmax=10      "deepest fold is 10 levels
" set nofoldenable        "dont fold by default
" set foldlevel=1

" Font
" set guifont=Source\ Code\ Pro\ Medium:h12
" set guifont=Fira\ Code\ Medium:h13

" indent all parts of html
" let g:html_indent_inctags = "html,body,head,tbody" 

" Press C-r in visual mode to replace the text highlighted
" vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" Activate deoplete
" let g:deoplete#enable_at_startup = 1

" Activate rainbow parentheses
let g:rainbow_active = 1

" To use fzf in vim
"set rtp+=/usr/local/opt/fzf

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
set wildmenu

set wildmode=list:longest  " List all matches and complete to the longest match.

" 'wildignore' is useful setting to ignore binary files such as compiler
" output, images, etc.
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

" Ignore some files for ctrlp completion
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" Ignore files in .gitignore for ctrlp completion
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

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

"NERDTree on startup
"autocmd VimEnter * NERDTree | wincmd p

"Shortcut to toggle NERDTree
"nnoremap <C-n> :NERDTreeToggle<CR>

" Re-select previously yanked text
nnoremap gb `[v`]

" https://old.reddit.com/r/vim/comments/c9s2ax/shared_clipboard_is_great/
set clipboard^=unnamedplus

" wellle/context.vim is disabled by default
" :ContextToggle to toggle it on demand
let g:context_enabled = 0

" coc.nvim configuration ------------------

let g:coc_global_extensions = [
  \ 'coc-pairs',
  \ 'coc-highlight',
  \ 'coc-prettier',
  \ 'coc-json',
  \ 'coc-yaml',
  \ 'coc-markdownlint',
  \ 'coc-python'
  \ ]


" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

