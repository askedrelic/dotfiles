"Vim file is organized into
" 1. Vim Settings (many subcategories)
" 2. Aliases and key functions
" 3. Plugins
"
" -----------------------------------------------------------------------------
" | VIM Settings                                                              |
" -----------------------------------------------------------------------------
set nocompatible

" first clear any existing autocommands:
autocmd!

" Restore the screen when we're exiting and set correct terminal
behave xterm
if &term == "xterm"
    let &term = "xtermc"

    set rs
    set t_ti= 7 [r [?47h
    set t_te= [?47l 8
endif


" General *********************************************************************
" save last 50 search history items, last 50 edit marks, don't remember search
" highlight
set viminfo=/50,'50,h

" where to put backup files
set backupdir=~/.vim/backup
" directory to place swap files in
set directory=~/.vim/tmp

" Custom status line
set statusline=                              " clear the statusline for when vimrc is reloaded
set statusline+=%f\                          " file name
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%h%m%r%w                     " flags
set statusline+=%=                           "left/right separator
" set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
set statusline+=%b,0x%-6B                    " current char
set statusline+=%c,%l/                       "cursor column/total lines
set statusline+=%L\ %P                       "total lines/percentage in file

match CursorColumn '\%120v.*' " Error format when a line is longer than 120

" allow you to have multiple files open and change between them without saving
set hidden
"make backspace work
set backspace=indent,eol,start
" Show line numbers
set number
" Show matching brackets.
set showmatch
" have % bounce between angled brackets, as well as other kinds:
set matchpairs+=<:>
set comments=s1:/*,mb:*,ex:*/,f://,b:#,:%,:XCOMM,n:>,fb:-
" This being the 21st century, I use Unicode
set encoding=utf-8
" Don't keep a backup file
set nobackup
" keep 100 lines of command line history
set history=100
" Automatically save before commands like :next and :make
set autowrite
" report: show a report when N lines were changed. 0 means 'all'
set report=0
" runtimepath: list of dirs to search for runtime files
set runtimepath=~/.vim,$VIMRUNTIME
" Like File Explorer, preview window height is 8
set previewheight=8
" always show status line
set ls=2
" Turn off bell, this could be more annoying, but I'm not sure how
set vb t_vb= 

" when using list, keep tabs at their full width and display `arrows':
" (Character 187 is a right double-chevron, and 183 a mid-dot.)
execute 'set listchars+=tab:' . nr2char(187) . nr2char(183)
"check if file is written to elsewhere and ask to reload immediately, not when
"saving
au CursorHold * checktime

" Tabs **********************************************************************

function! Tabstyle_tabs()
    " Using 4 column tabs
    set softtabstop=4
    set shiftwidth=4
    set tabstop=4
    set noexpandtab
endfunction

function! Tabstyle_spaces()
    " Use 4 spaces
    set expandtab
    set autoindent
    set shiftwidth=4
    set tabstop=4
    set softtabstop=4
endfunction

" when at 3 spaces, and I hit > ... go to 4, not 5
set shiftround 

call Tabstyle_spaces()

" Scrollbars/Status ***********************************************************
set sidescrolloff=2
" top bottom scroll off
set scrolloff=2
" set numberwidth=4
" show in title bar
set title
" show the cursor position all the time
set ruler
" display the current mode and partially-typed commands in the status line:
set showmode
set showcmd

" turn on command line completion wild style
set wildmenu 
" Bash tab style completion is awesome
set wildmode=longest,list
" wildchar-the char used for "expansion" on the command line default value is
" "<C-E>" but I prefer the tab key:
set wildchar=<TAB>
" ignore these files when completing
set wildignore=*~,#*#,*.sw?,*.o,*.obj,*.bak,*.exe,*.pyc,*.DS_Store,*.db,*.class,*.java.html,*.cgi.html,*.html.html,.viminfo,*.pdf

" shortmess: shorten messages where possible, especially to stop annoying
" 'already open' messages!
" set shortmess=atIAr
set shortmess=flnrxoOItTA

" Windows *********************************************************************
set splitbelow splitright
"
" don't always keep windows at equal size (for minibufexplorer)
set noequalalways

" Cursor highlights ***********************************************************
set cursorline
"set cursorcolumn

" Searching *******************************************************************
" highlight search
set hlsearch
" case inferred by default
set infercase 
" make searches case-insensitive
set ignorecase
"unless they contain upper-case letters:
set smartcase
" show the `best match so far' as search strings are typed:
set incsearch
" assume the /g flag on :s substitutions to replace all matches in a line:
set gdefault
" hide mouse on search
set mousehide

" Colors **********************************************************************
syntax on
set background=dark
if has("gui_running")
    "set guifont=Consolas:h12.00  " use this font
    set transparency=6    " Barely transparent
    let moria_style = 'black'
    colo moria
    set lines=73 columns=271
    " Turn off the button bar in gvim
    set guioptions-=T
    set guioptions-=m
    " No scrollbars
    set guioptions-=r
    set guioptions-=l
    set guioptions-=R
    set guioptions-=L
else
    colorscheme ir_black
endif

" Line Wrapping ***************************************************************
" don't make it look like there are line breaks where there aren't:
set nowrap
" Wrap at word
set linebreak

" have the h and l cursor keys wrap between lines (like <Space> and <BkSpc> do
" by default), and ~ covert case over line breaks; also have the cursor keys
" wrap in insert mode:
set whichwrap=h,l,~,[,]

" normally don't automatically format `text' as it is typed, IE only do this
" with comments, at 79 characters:
set formatoptions=cq
set textwidth=79

" treat lines starting with a quote mark as comments (for `Vim' files, such as
" this very one!), and colons as well so that reformatting usenet messages from
" `Tin' users works OK:
set comments+=b:\"
set comments+=n::

" File Stuff ******************************************************************
filetype plugin indent on

" When opening a file
au BufNewFile,BufRead *.lzx         setf lzx
au BufNewFile,BufRead *.module      setf php
au BufNewFile,BufRead *.inc         setf php
au BufNewFile,BufRead *.pl,*.pm,*.t setf perl

" we couldn't care less about html
au BufNewFile,BufRead *.htm,*.html  setf xml

" Omni Completion 
" set ofu=syntaxcomplete#Complete
au FileType html set omnifunc=htmlcomplete#CompleteTags
au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
au FileType css set omnifunc=csscomplete#CompleteCSS
au FileType xml set omnifunc=xmlcomplete#CompleteTags
au FileType php set omnifunc=phpcomplete#CompletePHP
au FileType c set omnifunc=ccomplete#Complete

" no line numbers when viewing help
au FileType helpfile set nonumber
au FileType helpfile nnoremap <buffer><cr> <c-]>   " Enter selects subject
au FileType helpfile nnoremap <buffer><bs> <c-T>   " Backspace to go back

" For C-like programming, have automatic indentation:
au FileType c,cpp,slang set cindent

" for actual C (not C++) programming where comments have explicit end
" characters, if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
au FileType c set formatoptions+=ro

" Ruby
au BufRead,BufNewFile *.rb,*.rhtml set shiftwidth=2 
au BufRead,BufNewFile *.rb,*.rhtml set softtabstop=2

" for Perl programming, have things in braces indenting themselves:
au FileType perl set smartindent

augroup Python
    let python_highlight_all = 1
    let python_slow_sync = 1
    " au BufNewFile,BufRead *.py       source $HOME/.vim/syntax/python.vim
    " au! Syntax python source $HOME/.vim/syntax/python.vim
    " au FileType python set formatoptions-=t
    "See $VIMRUNTIME/ftplugin/python.vim
    au!
    "smart indent really only for C like languages
    "See $VIMRUNTIME/indent/python.vim
    au FileType python set nosmartindent autoindent
    " Allow gf command to open files in $PYTHONPATH
    au FileType python let &path = &path . "," . substitute($PYTHONPATH, ';', ',', 'g')
    if v:version >= 700
        "See $VIMRUNTIME/autoload/pythoncomplete.vim
        "<C-x><C-o> to autocomplete
        au FileType python set omnifunc=pythoncomplete#Complete
        "Don't show docs in preview window
        au FileType python set completeopt-=preview
    endif
augroup END

" for CSS, also have things in braces indented:
au FileType css set smartindent

" for HTML, generally format text, but if a long line has been created leave it
" alone when editing:
au FileType xhtml set formatoptions+=l
au FileType xhtml set formatoptions-=t
au FileType djangohtml set formatoptions+=l
au FileType djangohtml set formatoptions-=t

" Keep comments indented
inoremap # #


" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.svn,.git,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

"jump to last cursor position when opening a file
"dont do it when writing a svn commit log entry
"TODO fix this for git commits?
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
  if &filetype !~ 'commit\c' && &filetype !~ 'svn\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
     exe "normal g`\""
    endif
  end
endfunction

" tell complete to look in the dictionary
set complete-=k complete+=k

" if problems, check here
" http://vim.wikia.com/wiki/Completion_using_a_syntax_file
au FileType * exec('setlocal dict+='.$VIMRUNTIME.'/syntax/'.expand('<amatch>').'.vim')

" Redraw *********************************************************************
" do not update screen while executing macros
set lazyredraw
" ttyfast: are we using a fast terminal? Let's try it for a while.
set ttyfast
" ttyscroll: redraw instead of scrolling
"set ttyscroll=0

" -----------------------------------------------------------------------------
" | Aliases and custom key functions                                          |
" -----------------------------------------------------------------------------
" Professor VIM says '87% of users prefer jj over esc', jj abrams strongly disagrees
imap jj <Esc>

" Map uppercase write and quit, I'm lazy with shift
cab W w
cab Q q
cab WQ wq
cab WQ! wq!

" page down with <Space> (like in `Lynx', `Mutt', `Pine', `Netscape Navigator',
" `SLRN', `Less', and `More'); page up with - (like in `Lynx', `Mutt', `Pine'),
" or <BkSpc> (like in `Netscape Navigator'):
noremap <Space> <PageDown>
noremap - <PageUp>

" have <F1> prompt for a help topic, rather than displaying the introduction
" page, and have it do this from any mode:
nnoremap <F1> :help<Space>
vmap <F1> <C-C><F1>
omap <F1> <C-C><F1>
map! <F1> <C-C><F1>

" use <Ctrl>+N/<Ctrl>+P to cycle through files:
" [<Ctrl>+N by default is like j, and <Ctrl>+P like k.]
" nnoremap <C-N> :bn<CR>
" nnoremap <C-P> :bp<CR>

" swap windows
nmap , <C-w><C-w>

"move around windows with ctrl key!
map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l

"tabs!
nnoremap \1 :tabn 1<CR>
nnoremap \2 :tabn 2<CR>
nnoremap \3 :tabn 3<CR>
nnoremap \4 :tabn 4<CR>
nnoremap \5 :tabn 5<CR>
nnoremap \6 :tabn 6<CR>
nnoremap \7 :tabn 7<CR>
nnoremap \8 :tabn 8<CR>
nnoremap \9 :tabn 9<CR>
nnoremap <D-1> :tabn 1<CR>
nnoremap <D-2> :tabn 2<CR>
nnoremap <D-3> :tabn 3<CR>
nnoremap <D-4> :tabn 4<CR>
nnoremap <D-5> :tabn 5<CR>
nnoremap <D-6> :tabn 6<CR>
nnoremap <D-7> :tabn 7<CR>
nnoremap <D-8> :tabn 8<CR>
nnoremap <D-9> :tabn 9<CR>
nnoremap <C-N> :tabn<CR>
nnoremap <C-P> :tabp<CR>

" discussion of different tab functions
" http://vim.wikia.com/wiki/Smart_mapping_for_tab_completion

" "trick to fix shift-tab http://vim.wikia.com/wiki/Make_Shift-Tab_work
map <Esc>[Z <s-tab>
ounmap <Esc>[Z

"---TAB BINDINGS
"Tab and Ctrl-i are bound to the same internal key with vim, therefore
"they cannot be bound to different commands in normal mode :(
"IE bind Tab to indent and Ctrl-I to 'move into movement stack'
nmap <S-Tab> :<<CR>

"Change tab of selected lines while in visual mode
vmap <Tab> >gv
vnoremap <S-Tab> <gv

" [<Ctrl>+V <Tab> still inserts an actual tab character.]
inoremap <Tab> <c-r>=InsertTabWrapper ("forward")<CR>
imap <S-Tab> <C-D>

" Remap TAB to keyword completion and indenting. The tab key is a still a work
" in progress.
function! InsertTabWrapper(direction)
  " alternate line checking
  "" let col = col('.') - 1
  " if !col || strpart(getline('.'), col-1, col) =~ '\s'
  if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
    return "\<tab>"
  elseif "forward" == a:direction
    return "\<c-n>"
  elseif "backward" == a:direction
    return "\<c-d>"
  else
    return "\<c-x>\<c-k>"
  endif
endfunction

" imap <C-Tab> <c-r>=InsertTabWrapper ("startkey")<CR>

" toggle tab completion
" function! ToggleTabCompletion()
"   if mapcheck("\<tab>", "i") != ""
"     iunmap <tab>
"     iunmap <s-tab>
"     iunmap <c-tab>
"     echo "tab completion off"
"   else
"     imap <tab> <c-n>
"     imap <s-tab> <c-p>
"     imap <c-tab> <c-x><c-l>
"     echo "tab completion on"
"   endif
" endfunction
" map <Leader>tc :call ToggleTabCompletion()<CR>

" insert new line without going into insert mode
nnoremap <Enter> o<ESC>
nnoremap <S-Enter> :put!=''<CR>
" set fo-=r " do not insert a comment leader after an enter, (no work, fix!!)

" have Q reformat the current paragraph (or selected text if there is any):
nnoremap Q gqap
vnoremap Q gq

" have Y behave analogously to D and C rather than to dd and cc (which is
" already done by yy):
noremap Y y$

" dulpicate line in visual mode
vmap D y'>p

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

"allow deleting selection without updating the clipboard (yank buffer)
vnoremap x "_x
vnoremap X "_X

"don't move the cursor after pasting
"(by jumping to back start of previously changed text)
noremap p p`[
noremap P P`[

" change first word of current line
map <silent> <C-h> ^cw

" toggle paste on/off
nnoremap \tp :set invpaste paste?<CR>

"toggle list on/off and report the change:
nnoremap \tl :set invlist list?<CR>

"toggle highlighting of search matches, and report the change:
nnoremap \th :set invhls hls?<CR>

"toggle numbers
nnoremap \tn :set number!<Bar> set number?<CR>

"toggle wrap and easy movement keys while in wrap mode
noremap <silent> <Leader>tw :call ToggleWrap()<CR>
function! ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> k
    silent! nunmap <buffer> j
    silent! nunmap <buffer> 0
    silent! nunmap <buffer> $
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo "Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> k gk
    noremap  <buffer> <silent> j gj
    noremap  <buffer> <silent> 0 g0
    noremap  <buffer> <silent> $ g$
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction

" toggle showbreak for long lines
function! TYShowBreak()
  if &showbreak == ''
    set showbreak=>
    echo "show break on"
  else
    set showbreak=
    echo "show break off"
  endif
endfunction
nmap \tb  TYShowBreak()

" Allows vim to split window to a terminal, thanks to screen.
" Requires screener.sh
" From http://www.semicomplete.com/blog/geekery/flashback-2010-2003.html
map \s :silent !screener.sh<CR>


"clear the fucking search buffer, not just remove the highlight
map \c :let @/ = ""<CR>

" Revert the current buffer
nnoremap \r :e!<CR>

"Easy edit of vimrc
nmap \v :e $MYVIMRC<CR>
nmap \V :source $MYVIMRC<CR>

" Easy unload of buffer
map \q :bd<CR>

" Easy quit of vim
map \Q :qall<CR>

" Show eeeeeeverything!
nmap \I :verbose set ai? si? cin? cink? cino? inde? indk? formatoptions? filetype? fileencoding? syntax? <CR>

"replace all tabs with 4 spaces
" map \ft :%s/	/    /g<CR>
" use :retab instead

"clear spaces at end of line
nmap \l :%s/\s\+$//<CR>

"OSX only: Open a web-browser with the URL in the current line
function! HandleURI()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
  echo s:uri
  if s:uri != ""
   exec "!open \"" . s:uri . "\""
  else
   echo "No URI found in line."
  endif
endfunction
map \o :call HandleURI()<CR>

" Custom text inserts *********************************************************
"insert THE time!
"TODO move this into some kind of autotext complete thing
nmap \tt :execute "normal i" . strftime("%Y/%m/%d %H:%M:%S")<Esc>
imap \tt <Esc>:execute "normal i" . strftime("%Y/%m/%d %H:%M:%S")<Esc>i

iab _AUTHOR Matt Behrens <askedrelic@gmail.com>


" -----------------------------------------------------------------------------
" | Pluggins                                                                  |
" -----------------------------------------------------------------------------
"Taglist
map \a :TlistToggle<CR>
" Jump to taglist window on open.
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_OnSelect=1
" if you are the last window, kill yourself
let Tlist_Exist_OnlyWindow = 1
" sort by order or name
let Tlist_Sort_Type = "order"
" do not show prototypes and not tags in the taglist window.
let Tlist_Display_Prototype = 0
" Remove extra information and blank lines from the taglist window.
let Tlist_Compart_Format = 1
" Show tag scope next to the tag name.
let Tlist_Display_Tag_Scope = 1
let Tlist_WinWidth = 40
" Show only current file
let Tlist_Show_One_File = 1

"NERDTree
map <silent> \e :NERDTreeToggle<CR>
let NERDTreeWinPos='right'
let NERDTreeChDirMode='2'
let NERDTreeIgnore=['\.vim$', '\~$', '\.pyo$', '\.pyc$', '\.svn[\//]$', '\.swp$']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']

"FuzzyFinder
"Seriously FF, setting up your options sucks
if !exists('g:FuzzyFinderOptions')
    let g:FuzzyFinderOptions = { 'Base':{}, 'Buffer':{}, 'File':{}, 'Dir':{}, 'MruFile':{}, 'MruCmd':{}, 'Bookmark':{}, 'Tag':{}, 'TaggedFile':{}}
    let g:FuzzyFinderOptions.File.excluded_path = '\v\~$|\.o$|\.exe$|\.bak$|\.swp$|((^|[/\\])\.{1,2}[/\\]$)|\.pyo$|\.pyc$|\.svn[/\\]$'
    let g:FuzzyFinderOptions.Base.key_open_vsplit = '<Space>'
endif
let g:fuzzy_matching_limit = 50
let g:fuzzy_ceiling = 10000
let g:fuzzy_ignore = "*.log;*.pyc;*.svn;"
map <silent> \f :FuzzyFinderTextMate<CR>
map <silent> \F :FuzzyFinderTextMateRefreshFiles<CR>:FuzzyFinderTextMate<CR>
map <silent> \b :FuzzyFinderBuffer!<CR>

"newrw
let g:netrw_hide              = 1
let g:netrw_list_hide         = '^\.svn.*'
let g:netrw_menu              = 0
let g:netrw_silent            = 1
let g:netrw_special_syntax    = 1
