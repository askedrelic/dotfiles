" -----------------------------------------------------------------------------
" | VIM Settings                                                              |
" -----------------------------------------------------------------------------

set nocompatible

" Tabs **********************************************************************
function! Tabstyle_tabs()
  " Using 4 column tabs
  set softtabstop=4
  set shiftwidth=4
  set tabstop=4
  set noexpandtab
endfunction
 
function! Tabstyle_spaces()
  " Use 2 spaces
  set softtabstop=2
  set shiftwidth=2
  set tabstop=2
  set expandtab
endfunction

"set smarttab "uhh
"set expandtab "insert spaces
"set softtabstop=4 "backspace delete 4 spaces
"set shiftwidth=4 "indent length with < > 
"set tabstop=4 "4 space tab

" Indenting *******************************************************************
set ai " Automatically set the indent of a new line (local to buffer)
set si " smartindent  (local to buffer)

" Scrollbars/Status ***********************************************************
set sidescrolloff=2
set scrolloff=2 " top bottom scroll off
set numberwidth=4
set title  " show in title bar
set ruler  " show the cursor position all the time
set showcmd
set wildmode=longest,list  " Bash tab style completion is awesome
"       wildchar  the char used for "expansion" on the command line
"                 default value is "<C-E>" but I prefer the tab key:
set wildchar=<TAB>
" shortmess: shorten messages where possible, especially to stop annoying
" 'already open' messages! 
set shortmess=atIA 


" Windows *********************************************************************
set equalalways " Multiple windows, when created, are equal in size
set splitbelow splitright
 
"Vertical split then hop to new buffer
":noremap ,v :vsp^M^W^W<cr>
":noremap ,h :split^M^W^W<cr>

" Cursor highlights ***********************************************************
set cursorline
"set cursorcolumn

" Searching *******************************************************************
set hlsearch " highlight search
set incsearch " incremental search, search as you type
set ignorecase " Ignore case when searching
set smartcase " Ignore case when searching lowercase
set mousehide " hide mouse?

" Colors **********************************************************************
set background=dark
syntax on " syntax highlighting
colorscheme ir_black

" Line Wrapping ***************************************************************
set nowrap
set linebreak " Wrap at word
"set textwidth=0 " Don't wrap words by default

" File Stuff ******************************************************************
filetype plugin indent on
" To show current filetype use: set filetype

autocmd FileType html :set filetype=xhtml " we couldn't care less about html

"Laszlo
au BufNewFile,BufRead *.lzx         setf lzx
"Drupal
au BufNewFile,BufRead *.module      setf php
au BufNewFile,BufRead *.inc         setf php
" For C-like programming, have automatic indentation:
autocmd FileType c,cpp,slang        set cindent

"autocmd FileType text
"            \ setlocal autoindent |
"            \ setlocal textwidth=80 |
"            \ setlocal formatoptions+=roan

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Return to the last position when previously editing this file
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

set formatoptions=tcqron "code formating options?

" Insert New Line *************************************************************
map <S-Enter> O<ESC> " awesome, inserts new line without going into insert mode
map <Enter> o<ESC>
set fo-=r " do not insert a comment leader after an enter, (no work, fix!!)

" Sessions ********************************************************************
" Sets what is saved when you save a session
" TODO TEST THIS?
set sessionoptions=blank,buffers,curdir,folds,help,resize,tabpages,winsize

" Misc ************************************************************************
set backspace=indent,eol,start
set number " Show line numbers
set showmatch              " Show matching brackets.
set matchpairs+=<:>
set comments=s1:/*,mb:*,ex:*/,f://,b:#,:%,:XCOMM,n:>,fb:-
set encoding=utf-8         " This being the 21st century, I use Unicode
set nobackup               " Don't keep a backup file
set nowritebackup          " No backup write?
set history=100            " keep 50 lines of command line history
set autowrite              " Automatically save before commands like :next and :make
set report=0               " report: show a report when N lines were changed. 0 means 'all' 
set runtimepath+=~/.vim    " runtimepath: list of dirs to search for runtime files
set previewheight=8        " Like File Explorer, preview window height is 8

" Redraw *********************************************************************
" lazyredraw: do not update screen while executing macros
"set lazyredraw 
" ttyfast: are we using a fast terminal? Let's try it for a while. 
set ttyfast
" ttyscroll: redraw instead of scrolling
"set ttyscroll=0

" Omni Completion *************************************************************
autocmd FileType html :set omnifunc=htmlcomplete#CompleteTags
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

" Aliases        *************************************************************
"trick to fix shift-tab http://vim.wikia.com/wiki/Make_Shift-Tab_work
map <Esc>[Z <s-tab>
ounmap <Esc>[Z

"Switch between open buffers easily!
nmap <tab> :bn<cr>
nmap <s-tab> :bp<cr>

map , <C-w><C-w> 
map \e :Explore<CR> 


" Toggle search highlighting
" map <silent> <F2> :set invhlsearch<CR>
map <silent> <f2> :set hls!<Bar>set hls?<CR>
" Toggle invisible characters
set listchars=trail:.,tab:>-,eol:$
map <silent> <F3> :set invlist<CR>
" Revert file
map <silent> <F4> :e!<CR>
" paste mode
set pastetoggle=<F5>
"set wrap
map <silent> <F6> :set wrap!<Bar>set wrap?<CR>

" -----------------------------------------------------------------------------
" | Pluggins                                                                  |
" -----------------------------------------------------------------------------

"BufExplorer
map \b :SBufExplorer<CR>
let g:bufExplorerSplitBelow=1  "Below current
let g:bufExplorerUseCurrentWindow=1  " Don't open in new window.

"newrw
let g:netrw_hide              = 1
let g:netrw_list_hide         = '^\.svn.*'
let g:netrw_menu              = 0
let g:netrw_silent            = 1
let g:netrw_special_syntax    = 1
