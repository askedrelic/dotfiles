"FILE SETTINGS --------------------------------------------
filetype plugin indent on
"Laszlo
au BufNewFile,BufRead *.lzx         setf lzx
"Drupal
au BufNewFile,BufRead *.module      setf php
au BufNewFile,BufRead *.inc      setf php
" For C-like programming, have automatic indentation:
autocmd FileType c,cpp,slang set cindent

autocmd FileType text
            \ setlocal autoindent |
            \ setlocal textwidth=80 |
            \ setlocal formatoptions+=roan

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Return to the last position when previously editing this file
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

"SETTINGS -------------------------------------------------
set autoindent
set encoding=utf-8 " This being the 21st century, I use Unicode
set formatoptions=tcqron "code formating options?
set comments=s1:/*,mb:*,ex:*/,f://,b:#,:%,:XCOMM,n:>,fb:-
set backspace=indent,eol,start  " More powerful backspacing
set textwidth=0            " Don't wrap words by default
set nobackup               " Don't keep a backup file
set nowritebackup          " No backup write?
"set nu                    " Show line numbers
set history=100            " keep 50 lines of command line history
set ruler                  " show the cursor position all the time
set showcmd                " Show (partial) command in status line.
set showmatch              " Show matching brackets.
set ignorecase             " Do case insensitive matching
set smartcase              " Unless I really mean case sensitive
set autowrite              " Automatically save before commands like :next and :make
set nowrap                 " We don't wrap lines, they become a LONG horizontal one (useful)  
set background=dark        " Set background to dark to have nicer syntax highlighting.
set scrolloff=2            " We keep 2 lines when scrolling
set title                  " show in title bad
set splitbelow             " new split windows are below
set splitright             " new split windows are right
set report=0               " report: show a report when N lines were changed. 0 means 'all' 
set runtimepath+=~/.vim    " runtimepath: list of dirs to search for runtime files
set showmode               " showmode: show the current mode. Definitely. 
set previewheight=8        " Like File Explorer, preview window height is 8
set wildmode=longest,list  " Bash style completion is awesome

"       wildchar  the char used for "expansion" on the command line
"                 default value is "<C-E>" but I prefer the tab key:
set wildchar=<TAB> 
" shortmess: shorten messages where possible, especially to stop annoying
" 'already open' messages! 
set shortmess=atIA 

" lazyredraw: do not update screen while executing macros
"set lazyredraw 
" ttyfast: are we using a fast terminal? Let's try it for a while. 
set ttyfast
" ttyscroll: redraw instead of scrolling
"set ttyscroll=0 

syntax on
colors ir_black

"set smarttab "uhh
"set expandtab "insert spaces
"set softtabstop=4 "backspace delete 4 spaces
"set shiftwidth=4 "indent length with < > 
"set tabstop=4 "4 space tab

set mousehide " Highlight search matches
set hlsearch
set incsearch "incremental search is better!

""" Indentation
"set smartindent

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

" virtual tabstops using spaces
let my_tab=4
execute "set shiftwidth=".my_tab
execute "set softtabstop=".my_tab
set expandtab
" allow toggling between local and default mode
function! TabToggle()
  if &expandtab
    set shiftwidth=8
    set softtabstop=0
    set noexpandtab
  else
    execute "set shiftwidth=".g:my_tab
    execute "set softtabstop=".g:my_tab
    set expandtab
  endif
endfunction
nmap <F7> mz:execute TabToggle()<CR>'z


"ALIASES/MAPPINGS -----------------------------------------
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
map <silent> <F3> :set invlist<CR>
" Revert file
map <silent> <F4> :e!<CR>
" paste mode
set pastetoggle=<F5>
"set wrap
map <silent> <F6> :set wrap!<Bar>set wrap?<CR>
