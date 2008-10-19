set nocompatible                " Ditch strict vi compatibility
set backspace=indent,eol,start  " More powerful backspacing
set textwidth=0         " Don't wrap words by default
set nobackup            " Don't keep a backup file
set nowritebackup       " No backup write?
"set nu                 " Show line numbers
set history=100         " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set showcmd         " Show (partial) command in status line.
set showmatch       " Show matching brackets.
set ignorecase      " Do case insensitive matching
set autowrite       " Automatically save before commands like :next and :make
set nowrap          " We don't wrap lines, they become a LONG horizontal one (useful)  
set background=dark " Set background to dark to have nicer syntax highlighting.
set scrolloff=2     " We keep 3 lines when scrolling
set title           "show in title bad
"       wildchar  the char used for "expansion" on the command line
"                 default value is "<C-E>" but I prefer the tab key:
set wildchar=<TAB> "Allow jump commands for left/right motion to wrap to previous/next
set splitbelow "new split windows are below
set splitright "new split windows are right
" report: show a report when N lines were changed. 0 means 'all' 
set report=0
" runtimepath: list of dirs to search for runtime files
set runtimepath+=~/.vim  
" shortmess: shorten messages where possible, especially to stop annoying
" "already open" messages! 
set shortmess=atIA 
" showmode: show the current mode. Definitely. 
set showmode 

" lazyredraw: do not update screen while executing macros
"set lazyredraw 
" ttyfast: are we using a fast terminal? Let's try it for a while. 
set ttyfast
" ttyscroll: redraw instead of scrolling
set ttyscroll=0 


filetype plugin on
" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
" Bash style completion is awesome
set wildmode=longest,list

syntax on
colors torte

"make tabs be spaces instead
"set smarttab 
set expandtab
set softtabstop=4 "backspace delete 4 spaces
set tabstop=4 "4 space tab
set shiftwidth=4 "indent length with < > 

set mousehide " Highlight search matches
set hlsearch
set incsearch "incremental search is better!

""" Indentation
set smartindent
" For C-like programming, have automatic indentation:
autocmd FileType c,cpp,slang set cindent

" Return to the last position when previously editing this file
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

"BufExplorer
map \b :SBufExplorer<CR>
let g:bufExplorerSplitBelow=1  "Below current
let g:bufExplorerUseCurrentWindow=1  " Don't open in new window.

"newrw
let g:netrw_hide              = 1
let g:netrw_list_hide         = '.swp'
let g:netrw_menu              = 0

"aliases 
map , <C-w><C-w> 
map \e :Explore<CR> 
" Toggle search highlighting
map <silent> <F2> :set invhlsearch<CR>
" Toggle invisible characters
map <silent> <F3> :set invlist<CR>
" Revert file
map <silent> <F4> :e!<CR>
" paste mode
set pastetoggle=<F5>

"Laszlo
au BufNewFile,BufRead *.lzx         setf lzx
"Wikipedia
au BufNewFile,BufRead *.wiki        setf Wikipedia
"AS3
au BufNewFile,BufRead *.as          setf actionscript
"Drupal
au BufNewFile,BufRead *.module      setf php
au BufNewFile,BufRead *.inc      setf php

#test
