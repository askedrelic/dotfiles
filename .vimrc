" -----------------------------------------------------------------------------
" | VIM Settings                                                              |
" -----------------------------------------------------------------------------
set nocompatible

" first clear any existing autocommands:
autocmd!

behave xterm
if &term == "xterm"
    let &term = "xtermc"

    " Restore the screen when we're exiting
    set rs
    set t_ti= 7 [r [?47h 
    set t_te= [?47l 8
endif

" General *********************************************************************
" remember all of these between sessions, but only 10 search terms; also
" remember info for 10 files, but never any on removable disks, don't remember
" marks in files, don't rehighlight old search patterns, and only save up to
" 100 lines of registers; including @10 in there should restrict input buffer
" but it causes an error for me:
set viminfo=/50,'50,f0,h,\"100

set backspace=indent,eol,start
set number " Show line numbers
set showmatch              " Show matching brackets.
" have % bounce between angled brackets, as well as t'other kinds:
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

" when using list, keep tabs at their full width and display `arrows':
execute 'set listchars+=tab:' . nr2char(187) . nr2char(183)
" (Character 187 is a right double-chevron, and 183 a mid-dot.)

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

" use indents of 2 spaces, and have them copied down lines:
set shiftwidth=4
set softtabstop=4
set tabstop=4
set shiftround
set expandtab
set autoindent
" Indenting *******************************************************************
set ai " Automatically set the indent of a new line (local to buffer)
set si " smartindent  (local to buffer)

" Scrollbars/Status ***********************************************************
set sidescrolloff=2
set scrolloff=2 " top bottom scroll off
set numberwidth=4
set title  " show in title bar
set ruler  " show the cursor position all the time
" display the current mode and partially-typed commands in the status line:
set showmode
set showcmd
set wildmode=longest,list  " Bash tab style completion is awesome

" wildchar  the char used for "expansion" on the command line default value is
" "<C-E>" but I prefer the tab key:
set wildchar=<TAB>
set wildignore=*~,#*#,*.sw?,*.o,*.class,*.java.html,*.cgi.html,*.html.html,.viminfo,*.pdf
" shortmess: shorten messages where possible, especially to stop annoying
" 'already open' messages!  
" set shortmess=atIAr
set shortmess=flnrxoOItTA

" Windows *********************************************************************
set equalalways " Multiple windows, when created, are equal in size
set splitbelow splitright
set noequalalways       " noea:  don't always keep windows at equal size
 
"Vertical split then hop to new buffer
":noremap ,v :vsp^M^W^W<cr>
":noremap ,h :split^M^W^W<cr>

" Cursor highlights ***********************************************************
set cursorline
"set cursorcolumn

" Searching *******************************************************************
" highlight search
set hlsearch 
" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase
" show the `best match so far' as search strings are typed:
set incsearch
" assume the /g flag on :s substitutions to replace all matches in a line:
set gdefault
set mousehide " hide mouse?

" Colors **********************************************************************
set background=dark
syntax on " syntax highlighting
colorscheme ir_black

" Line Wrapping ***************************************************************
" don't make it look like there are line breaks where there aren't:
set nowrap
set linebreak " Wrap at word
"set textwidth=0 " Don't wrap words by default


" normally don't automatically format `text' as it is typed, IE only do this
" with comments, at 79 characters:
set formatoptions-=t
set textwidth=79

" treat lines starting with a quote mark as comments (for `Vim' files, such as
" this very one!), and colons as well so that reformatting usenet messages from
" `Tin' users works OK:
set comments+=b:\"
set comments+=n::


" File Stuff ******************************************************************
" To show current filetype use: set filetype
filetype plugin indent on

" set frmatoptions=tcqron code formating options?
"autocmd FileType text
"            \ setlocal autoindent |
"            \ setlocal textwidth=80 |
"            \ setlocal formatoptions+=roan

" we couldn't care less about html
au BufNewFile,BufRead *.html        setf xhtml 
"Laszlo
au BufNewFile,BufRead *.lzx         setf lzx
"Drupal
au BufNewFile,BufRead *.module      setf php
au BufNewFile,BufRead *.inc         setf php
au BufNewFile,BufRead *.pl,*.pm,*.t     setf perl


" For C-like programming, have automatic indentation:
autocmd FileType c,cpp,slang        set cindent

" for actual C (not C++) programming where comments have explicit end
" characters, if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
autocmd FileType c set formatoptions+=ro

" for Perl programming, have things in braces indenting themselves:
autocmd FileType perl set smartindent

" for CSS, also have things in braces indented:
autocmd FileType css set smartindent

" for HTML, generally format text, but if a long line has been created leave it
" alone when editing:
autocmd FileType html set formatoptions+=tl

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.svn,.git,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Return to the last position when previously editing this file
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" Key stuff *******************************************************************
" have the h and l cursor keys wrap between lines (like <Space> and <BkSpc> do
" by default), and ~ covert case over line breaks; also have the cursor keys
" wrap in insert mode:
set whichwrap=h,l,~,[,]

" page down with <Space> (like in `Lynx', `Mutt', `Pine', `Netscape Navigator',
" `SLRN', `Less', and `More'); page up with - (like in `Lynx', `Mutt', `Pine'),
" or <BkSpc> (like in `Netscape Navigator'):
noremap <Space> <PageDown>
noremap - <PageUp>
" [<Space> by default is like l, <BkSpc> like h, and - like k.]


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
map <S-CR> O<ESC> " awesome, inserts new line without going into insert mode
map <CR> o<ESC>
set formatoptions-=or " do not insert a comment leader after an enter, (not working, fix!!)
" have <F1> prompt for a help topic, rather than displaying the introduction
" page, and have it do this from any mode:
nnoremap <F1> :help<Space>
vmap <F1> <C-C><F1>
omap <F1> <C-C><F1>
map! <F1> <C-C><F1>

"trick to fix shift-tab http://vim.wikia.com/wiki/Make_Shift-Tab_work
map <Esc>[Z <s-tab>
ounmap <Esc>[Z

" use <Ctrl>+N/<Ctrl>+P to cycle through files:
nnoremap <C-N> :next<CR>
nnoremap <C-P> :prev<CR>
" [<Ctrl>+N by default is like j, and <Ctrl>+P like k.]

" have the usual indentation keystrokes still work in visual mode:
vnoremap <C-T> >
vnoremap <C-D> <LT>
vmap <Tab> <C-T>
vmap <S-Tab> <C-D>

" have <Tab> (and <Shift>+<Tab> where it works) change the level of
" indentation:
inoremap <Tab> <C-T>
inoremap <S-Tab> <C-D>
" [<Ctrl>+V <Tab> still inserts an actual tab character.]

nmap , <C-w><C-w>

" have Q reformat the current paragraph (or selected text if there is any):
nnoremap Q gqap
vnoremap Q gq

" have Y behave analogously to D and C rather than to dd and cc (which is
" already done by yy):
noremap Y y$

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

" have \tp ("toggle paste") toggle paste on/off and report the change, and
" where possible also have <F4> do this both in normal and insert mode:
nnoremap \tp :set invpaste paste?<CR>
nmap <F5> \tp
imap <F5> <C-O>\tp
set pastetoggle=<F5>

" have \tl ("toggle list") toggle list on/off and report the change:
nnoremap \tl :set invlist list?<CR>
nmap <F3> \tl

" have \th ("toggle highlight") toggle highlighting of search matches, and
" report the change:
nnoremap \th :set invhls hls?<CR>
nmap <f2> :set hls!<Bar>set hls?<CR>

"have \tn toggle numbers
nnoremap \tn :set number!<Bar> set number?<CR>

" Revert file
map <silent> <F4> :e!<CR>
"set wrap
nnoremap \tw :set wrap!<Bar> set wrap?<CR>
nmap <F6> \tw

" -----------------------------------------------------------------------------
" | Pluggins                                                                  |
" -----------------------------------------------------------------------------
"Taglist
map \a :TlistToggle<CR>

"NERDTree
map \e :NERDTreeToggle<CR>
let NERDTreeWinPos='right'

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
