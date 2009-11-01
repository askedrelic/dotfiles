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
" save last 50 search history items, last 50 edit marks, don't remember search
" highlight
set viminfo=/50,'50,h

set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=      "left/right separator
" set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
set statusline+=%b,0x%-8B\      " current char
set statusline+=%c,%l/ "cursor column/total lines
set statusline+=%L\ %P "total lines/percentage in file

" this allows you to have multiple files open at once and change between them
" without saving
set hidden
"make backspace work
set backspace=indent,eol,start
" Show line numbers
set number 
" Show matching brackets.
set showmatch              
" have % bounce between angled brackets, as well as t'other kinds:
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
set runtimepath+=~/.vim    
" Like File Explorer, preview window height is 8
set previewheight=8        
" always show status line
set ls=2            
"
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
  " Use 2 spaces
  set softtabstop=2
  set shiftwidth=2
  set tabstop=2
  set expandtab
endfunction

" Tabs should be converted to a group of 4 spaces.
" indent length with < > 
set shiftwidth=4
set tabstop=4
"Insert spaces for tabs
set smarttab
set expandtab
set shiftround

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

" Bash tab style completion is awesome
set wildmode=longest,list  
" wildchar  the char used for "expansion" on the command line default value is
" "<C-E>" but I prefer the tab key:
set wildchar=<TAB>

set wildignore=*~,#*#,*.sw?,*.o,*.obj,*.bak,*.exe,*.pyc,*.DS_Store,*.db,*.class,*.java.html,*.cgi.html,*.html.html,.viminfo,*.pdf
" shortmess: shorten messages where possible, especially to stop annoying
" 'already open' messages!  
" set shortmess=atIAr
set shortmess=flnrxoOItTA

" Windows *********************************************************************
set splitbelow splitright
" don't always keep windows at equal size (for minibufexplorer)
set noequalalways       
 
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
    set lines=73 columns=260
else
    colorscheme ir_black
endif

" Omni Completion *************************************************************
" set ofu=syntaxcomplete#Complete 
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

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
" To show current filetype use: set filetype
filetype plugin indent on

" Filetypes (au = autocmd)
au FileType helpfile set nonumber      " no line numbers when viewing help
au FileType helpfile nnoremap <buffer><cr> <c-]>   " Enter selects subject
au FileType helpfile nnoremap <buffer><bs> <c-T>   " Backspace to go back

" we couldn't care less about html
au BufNewFile,BufRead *.html        setf xhtml 
"Laszlo
au BufNewFile,BufRead *.lzx         setf lzx
au BufNewFile,BufRead *.module      setf php
au BufNewFile,BufRead *.inc         setf php
au BufNewFile,BufRead *.pl,*.pm,*.t setf perl

" For C-like programming, have automatic indentation:
autocmd FileType c,cpp,slang        set cindent

" for actual C (not C++) programming where comments have explicit end
" characters, if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
autocmd FileType c set formatoptions+=ro

" for Perl programming, have things in braces indenting themselves:
autocmd FileType perl set smartindent

autocmd FileType python set formatoptions-=t

" for CSS, also have things in braces indented:
autocmd FileType css set smartindent

" for HTML, generally format text, but if a long line has been created leave it
" alone when editing:
autocmd FileType xhtml set formatoptions+=l
autocmd FileType xhtml set formatoptions-=t
autocmd FileType djangohtml set formatoptions+=l
autocmd FileType djangohtml set formatoptions-=t

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.svn,.git,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
  if &filetype !~ 'commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
     exe "normal g`\""
    endif
  end
endfunction


" Redraw *********************************************************************
" lazyredraw: do not update screen while executing macros
"set lazyredraw 
" ttyfast: are we using a fast terminal? Let's try it for a while. 
set ttyfast
" ttyscroll: redraw instead of scrolling
"set ttyscroll=0

" Aliases        *************************************************************
" Professor VIM says '87% of users prefer jj over esc', jj abrams strongly disagrees
imap jj <Esc>

" page down with <Space> (like in `Lynx', `Mutt', `Pine', `Netscape Navigator',
" `SLRN', `Less', and `More'); page up with - (like in `Lynx', `Mutt', `Pine'),
" or <BkSpc> (like in `Netscape Navigator'):
noremap <Space> <PageDown>
" noremap - <PageUp>

" [<Space> by default is like l, <BkSpc> like h, and - like k.]
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
" [<Ctrl>+N by default is like j, and <Ctrl>+P like k.]
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>

" swap windows
nmap , <C-w><C-w>

"move around windows with ctrl key!
map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l

" this might replace all of this http://www.vim.org/scripts/script.php?script_id=1643
" Remap TAB to keyword completion
function! InsertTabWrapper(direction)
  let col = col('.') - 1
  if !col || strpart(getline('.'), col-1, col) =~ '\s'     
    return "\<tab>"
  elseif "forward" == a:direction
    return "\<c-n>"
  elseif "backward" == a:direction
    return "\<c-d>"
  else
    return "\<c-x>\<c-k>"
  endif
endfunction

inoremap <Tab> <c-r>=InsertTabWrapper ("forward")<CR>
inoremap <S-Tab> <c-r>=InsertTabWrapper ("backward")<CR>
inoremap <C-Tab> <c-r>=InsertTabWrapper ("startkey")<CR>

" toggle tab completion
function! ToggleTabCompletion()
  if mapcheck("\<tab>", "i") != ""
    iunmap <tab>
    iunmap <s-tab>
    iunmap <c-tab>
    echo "tab completion off"
  else
    imap <tab> <c-n>
    imap <s-tab> <c-p>
    imap <c-tab> <c-x><c-l>
    echo "tab completion on"
  endif
endfunction
map <Leader>tc :call ToggleTabCompletion()<CR>

" tell complete to look in the dictionary
set complete-=k complete+=k

" load the dictionary according to syntax
" au BufReadPost * if exists("b:current_syntax")
" au BufReadPost * let &dictionary = substitute("C:\\vim\\vimfiles\\dict\\FT.dict", "FT", b:current_syntax, "")
" au BufReadPost * endif

" inoremap <Tab> <C-T>
" inoremap <S-Tab> <C-D>
" [<Ctrl>+V <Tab> still inserts an actual tab character.]

vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" insert new line without going into insert mode
nnoremap - :put=''<CR>
nnoremap + :put!=''<CR> 

" have Q reformat the current paragraph (or selected text if there is any):
nnoremap Q gqap
vnoremap Q gq

" have Y behave analogously to D and C rather than to dd and cc (which is
" already done by yy):
noremap Y y$

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

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
nmap  <expr> \tb  TYShowBreak()

"clear the fucking search buffer, not just remove the highlight
map \c :let @/ = ""<CR>

" Revert the current buffer
nnoremap \r :e!<CR>

"Easy edit of vimrc
nmap \s :source $MYVIMRC<CR>
nmap \v :e $MYVIMRC<CR>

"show indent stuff
nmap \I :verbose set ai? cin? cink? cino? si? inde? indk? formatoptions?<CR>

"replace all tabs with 4 spaces
map \ft :%s/	/    /g<CR> 

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
map <Leader>o :call HandleURI()<CR>
" Custom text inserts *********************************************************
"insert THE time!
nmap <Leader>tt :execute "normal i" . strftime("%x %X (%Z) ")<Esc>
imap <Leader>tt <Esc>:execute "normal i" . strftime("%x %X (%Z) ")<Esc>i

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
let g:fuzzy_matching_limit = 60
let g:fuzzy_ceiling = 50000
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
