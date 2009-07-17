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
" remember all of these between sessions, but only 50 search terms; also
" remember info for 50 files, but never any on removable disks, don't remember
" marks in files, don't rehighlight old search patterns, and only save up to
" 100 lines of registers; including @10 in there should restrict input buffer
" but it causes an error for me:
set viminfo=/50,'50,f0,h

set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=      "left/right separator
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
set statusline+=%b,0x%-8B\                   " current char
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

" this allows you to have multiple files open
" at once and change between them without
" saving
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
set expandtab
set smarttab
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
    set transparency=5    " Barely transparent
    let moria_style = 'black'
    colo moria
else
    colorscheme ir_black
endif

" Line Wrapping ***************************************************************
" don't make it look like there are line breaks where there aren't:
set nowrap
" Wrap at word
set linebreak 
" Don't wrap words by default
"set textwidth=0 


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

" for CSS, also have things in braces indented:
autocmd FileType css set smartindent

" for HTML, generally format text, but if a long line has been created leave it
" alone when editing:
autocmd FileType html set formatoptions+=tl

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.svn,.git,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Return to the last position when previously editing this file
" When editing a file, always jump to the last cursor position
autocmd BufReadPost *
\ if ! exists("g:leave_my_cursor_position_alone") |
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\ exe "normal g'\"" |
\ endif |
\ endif

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
" set ofu=syntaxcomplete#Complete 
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

" Aliases        *************************************************************
"inserts new line without going into insert mode
map <S-CR> O<ESC> 
map <CR> o<ESC>
" do not insert a comment leader after an enter, (not working, fix!!)
set formatoptions-=or 
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
nmap , <C-w><C-w>

" have the usual indentation keystrokes still work in visual mode:
" vnoremap <C-T> >
" vnoremap <C-D> <LT>
" vmap <Tab> <C-T>
" vmap <S-Tab> <C-D>
" 
" " have <Tab> (and <Shift>+<Tab> where it works) change the level of
" " indentation:
" inoremap <Tab> <C-T>
" inoremap <S-Tab> <C-D>
" " [<Ctrl>+V <Tab> still inserts an actual tab character.]

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

"clear the fucking search buffer
map \c :let @/ = ""<CR>

"have \tn toggle numbers
nnoremap \tn :set number!<Bar> set number?<CR>

" Revert file
nnoremap \r :e!<CR>

"set wrap
nnoremap \tw :set wrap!<Bar> set wrap?<CR>
nmap <F6> \tw

"Easy edit of vimrc
nmap \s :source $MYVIMRC<CR>
nmap \v :e $MYVIMRC<CR>

"show indent stuff
nmap \i :verbose set ai? cin? cink? cino? si? inde? indk?<CR>

"replace all tabs with 4 spaces
map \ft :%s/	/    /g<CR> 

"insert time!
nmap <Leader>tt :execute "normal i" . strftime("%x %X (%Z) ")<Esc>
imap <Leader>tt <Esc>:execute "normal i" . strftime("%x %X (%Z) ")<Esc>i

"move around windows with ctrl key!
map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l

" -----------------------------------------------------------------------------
" | Pluggins                                                                  |
" -----------------------------------------------------------------------------
"Taglist
map \a :TlistToggle<CR>
let Tlist_Show_One_File='1'
" if you are the last window, kill yourself
let Tlist_Exist_OnlyWindow = 1 
" sort by order or name
let Tlist_Sort_Type = "order" 
" do not show prototypes and not tags in the taglist window.
let Tlist_Display_Prototype = 0 
" Remove extra information and blank lines from the taglist window.
let Tlist_Compart_Format = 1 
" Jump to taglist window on open.
let Tlist_GainFocus_On_ToggleOpen = 1 
" Show tag scope next to the tag name.
let Tlist_Display_Tag_Scope = 1 
let Tlist_WinWidth = 40

"NERDTree
map \e :NERDTreeToggle<CR>
let NERDTreeWinPos='right'
let NERDTreeChDirMode='2'
let NERDTreeIgnore=['\.vim$', '\~$', '\.pyc$', '\.swp$']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']

"BufExplorer
let g:bufExplorerSplitBelow=1  "Below current
let g:bufExplorerUseCurrentWindow=1  " Don't open in new window.

map \b :TMiniBufExplorer<CR>
let g:miniBufExplModSelTarget = 1
let g:miniBufExplSplitBelow = 0

"newrw
let g:netrw_hide              = 1
let g:netrw_list_hide         = '^\.svn.*'
let g:netrw_menu              = 0
let g:netrw_silent            = 1
let g:netrw_special_syntax    = 1
