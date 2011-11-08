" This Vim file is organized into
" ### VIM Settings
" ### General
" ### Tabs
" ### Scrollbars/Status
" ### Windows
" ### Cursor Highlights
" ### Searching
" ### Colors
" ### Line Wrapping
" ### File Stuff
" ### Redraw
" ### Aliases and custom key functions
" ### Custom text inserts
" ### Plugins
"
" ### VIM Settings ###################################################
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

" ### General ###################################################
" save last 50 search history items, last 50 edit marks, don't remember search
" highlight
set viminfo=/50,'50,h

" where to put backup files
" set backupdir=~/.vim/backup
" directory to place swap files in
" set directory=~/.vim/tmp

" trying no backup
set nobackup
set noswapfile

" Custom status line

" Helper functions {{{2
" GetFileName() {{{3
function! GetFileName()
    if &buftype == 'help'
        return expand('%:p:t')
    elseif &buftype == 'quickfix'
        return '[Quickfix List]'
    elseif bufname('%') == ''
        return '[No Name]'
    else
        return expand('%:p:~:.')
    endif
endfunction

" GetState() {{{3
function! GetState()
    if &buftype == 'help'
        return 'H'
    elseif &readonly || &buftype == 'nowrite' || &modifiable == 0
        return '-'
    elseif &modified != 0
        return '*'
    else
        return ''
    endif
endfunction

" GetFileformat() {{{3
function! GetFileFormat()
    if &fileformat == '' || &fileformat == 'unix'
        return ''
    else
        return &fileformat
    endif
endfunction

" GetFileencoding() {{{3
function! GetFileEncoding()
    if empty(&fileencoding) || &fileencoding == 'utf-8'
        return ''
    else
        return &fileencoding
    endif
endfunction

" Default statusline
let g:default_stl  = ""

let g:default_stl .= "<CUR>#[Mode] "
let g:default_stl .= "%{&paste ? 'PASTE [>] ' : ''}"
let g:default_stl .= "%{substitute(mode(), '', '^V', 'g')}"
let g:default_stl .= " #[ModeS][>>]</CUR>"

" File name
let g:default_stl .= "#[FileName] %{GetFileName()} "

let g:default_stl .= "#[ModFlag]%(%{GetState()} %)#[BufFlag]%w"
let g:default_stl .= "#[FileNameS][>>]" " Separator

" File type
let g:default_stl .= "<CUR>%(#[FileType] %{!empty(&ft) ? &ft : '--'}#[BranchS]%)</CUR>"

" Spellcheck language
let g:default_stl .= "<CUR>%(#[FileType]%{&spell ? ':' . &spelllang : ''}#[BranchS]%)</CUR>"

" Git branch
let g:default_stl .= "#[Branch]%("
let g:default_stl .= "%{substitute(fugitive#statusline(), '\\[GIT(\\([a-z0-9\\-_\\./:]\\+\\))\\]', '<CUR>:</CUR>\\1', 'gi')}"
let g:default_stl .= "%) "

" Padding/HL group
let g:default_stl .= "#[FunctionName] "

" Truncate here
let g:default_stl .= "%<"

" Current directory
let g:default_stl .= "%{fnamemodify(getcwd(), ':~')}"

" Right align rest
let g:default_stl .= "%= "

" File format
let g:default_stl .= '<CUR>%(#[FileFormat]%{GetFileFormat()} %)</CUR>'

" File encoding
let g:default_stl .= '<CUR>%(#[FileFormat]%{GetFileEncoding()} %)</CUR>'

" Tabstop/indent settings
let g:default_stl .= "#[ExpandTab] %{&expandtab ? 'S' : 'T'}"
let g:default_stl .= "#[LineColumn]:%{&tabstop}:%{&softtabstop}:%{&shiftwidth}"

" Unicode codepoint
let g:default_stl .= '<CUR>#[LineNumber] U+%04B</CUR>'

" Line/column/virtual column, Line percentage
let g:default_stl .= "#[LineNumber] %04(%l%)#[LineColumn]:%03(%c%V%) "

" Line/column/virtual column, Line percentage
let g:default_stl .= "#[LinePercent] %p%%"

" Current syntax group
let g:default_stl .= "%{exists('g:synid') && g:synid ? '[<] '.synIDattr(synID(line('.'), col('.'), 1), 'name').' ' : ''}"

" s:StatusLine()
function! s:StatusLine(new_stl, type, current)
    let current = (a:current ? "" : "NC")
    let type    = a:type
    let new_stl = a:new_stl

    " Prepare current buffer specific text
    " Syntax: <CUR> ... </CUR>
    let new_stl = substitute(new_stl, '<CUR>\(.\{-,}\)</CUR>', (a:current ? '\1' : ''), 'g')

    " Prepare statusline colors
    " Syntax: #[ ... ]
    let new_stl = substitute(new_stl, '#\[\(\w\+\)\]',
                           \ '%#StatusLine' . type . '\1' . current . '#', 'g')

    " Prepare statusline arrows
    " Syntax: [>] [>>] [<] [<<]
    let new_stl = substitute(new_stl, '\[>\]',  '|', 'g')
    let new_stl = substitute(new_stl, '\[>>\]', '',  'g')
    let new_stl = substitute(new_stl, '\[<\]',  '|', 'g')
    let new_stl = substitute(new_stl, '\[<<\]', '',  'g')

    if &l:statusline ==# new_stl
        " Statusline already set, nothing to do
        return
    endif

    if empty(&l:statusline)
        " No statusline is set, use new_stl
        let &l:statusline = new_stl
    else
        " Check if a custom statusline is set
        let plain_stl = substitute(&l:statusline, '%#StatusLine\w\+#', '', 'g')

        if &l:statusline ==# plain_stl
            " A custom statusline is set, don't modify
            return
        endif

        " No custom statusline is set, use new_stl
        let &l:statusline = new_stl
    endif
endfunction

au BufEnter,BufWinEnter,WinEnter,CmdwinEnter,CursorHold,BufWritePost,InsertLeave * call <SID>StatusLine((exists('b:stl') ? b:stl : g:default_stl), 'Normal', 1)
au BufLeave,BufWinLeave,WinLeave,CmdwinLeave * call <SID>StatusLine((exists('b:stl') ? b:stl : g:default_stl), 'Normal', 0)
au InsertEnter,CursorHoldI * call <SID>StatusLine((exists('b:stl') ? b:stl : g:default_stl), 'Insert', 1)

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
" keep 1000 lines of command line history
set history=1000
" keep 1000 undo levels
set undolevels=1000
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

" ### Tabs ###################################################

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
    set copyindent
    set shiftwidth=4
    set tabstop=4
    set softtabstop=4
endfunction

" when at 3 spaces, and I hit > ... go to 4, not 5
set shiftround

call Tabstyle_spaces()

" ### Scrollbars/Status ###################################################
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
" Ignore these filenames during enhanced command line completion.
set wildignore+=*.aux,*.out,*.toc " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif " binary images
set wildignore+=*.luac " Lua byte code
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.pyc " Python byte code
set wildignore+=*.spl " compiled spelling word lists
set wildignore+=*.sw? " Vim swap files
set wildignore+=*.DS_Store? " OSX bullshit

" shortmess: shorten messages where possible, especially to stop annoying
" 'already open' messages!
" set shortmess=atIAr
set shortmess=flnrxoOItTA

" ### Windows ###################################################
set splitbelow splitright
"
" don't always keep windows at equal size (for minibufexplorer)
set noequalalways

" ### Cursor Highlights ###################################################
set cursorline
"set cursorcolumn

"Highlight cursorline ONLY in the active window:
au WinEnter * setlocal cursorline
au WinLeave * setlocal nocursorline

" ### Searching ###################################################
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

" ### Colors ###################################################
syntax on
set background=dark
" One unified gui/terminal colorscheme
colo Tomorrow-Night-Eighties

if has("gui_running")
    set guifont=Monaco:h12
    " set lines=73 columns=271
    set guioptions+=c " use console dialogs
    "set guioptions-=e " don't use gui tabs
    set guioptions-=T " don't show toolbar
    set guioptions-=r " No scrollbars

    set guioptions-=m
    set guioptions-=l
    set guioptions-=R
    set guioptions-=L
endif

" ### Line Wrapping ###################################################
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

" ### File Stuff ###################################################
filetype plugin indent on

" we couldn't care less about html
au BufNewFile,BufRead *.htm,*.html  setf xml

" Omni Completion
" set ofu=syntaxcomplete#Complete
set completeopt=menu,menuone,longest
au FileType html set omnifunc=htmlcomplete#CompleteTags
au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
au FileType css set omnifunc=csscomplete#CompleteCSS
au FileType xml set omnifunc=xmlcomplete#CompleteTags
au FileType php set omnifunc=phpcomplete#CompletePHP
au FileType python set omnifunc=pythoncomplete#Complete
au FileType c set omnifunc=ccomplete#Complete

" no line numbers when viewing help
au FileType helpfile set nonumber

" For C-like programming, have automatic indentation:
au FileType c,cpp,slang set cindent

" for actual C (not C++) programming where comments have explicit end
" characters, if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
au FileType c set formatoptions+=ro

au BufNewFile,BufRead *.markdown,*.md set filetype=markdown

" Ruby
au BufRead,BufNewFile *.rb,*.rhtml set shiftwidth=2
au BufRead,BufNewFile *.rb,*.rhtml set softtabstop=2

" for Perl programming, have things in braces indenting themselves:
au FileType perl set smartindent

" for CSS, also have things in braces indented:
au FileType css set smartindent

" for HTML, generally format text, but if a long line has been created leave it
" alone when editing:
au FileType xhtml set formatoptions+=l
au FileType xhtml set formatoptions-=t
au FileType djangohtml set formatoptions+=l
au FileType djangohtml set formatoptions-=t

" Keep comments indented
" inoremap # #

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
" set complete-=k complete+=k

" if problems, check here
" http://vim.wikia.com/wiki/Completion_using_a_syntax_file
au FileType * exec('setlocal dict+='.$VIMRUNTIME.'/syntax/'.expand('<amatch>').'.vim')

" ### Redraw ###################################################
" do not update screen while executing macros
" 2011/07/04 this causes the screen to not refresh on open. what?
" set lazyredraw
" ttyfast: are we using a fast terminal? Let's try it for a while.
set ttyfast

" ### Aliases and custom key functions ######################################
" Professor VIM says '87% of users prefer jj over esc', jj abrams strongly disagrees
imap jj <Esc>

" save even more keystrokes!
nnoremap ; :

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


" swap windows
nmap , <C-w><C-w>

"move around windows with ctrl key!
map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l

" Fix vertsplit window sizing
nmap <C-Left> <C-W>><C-W>>
nmap <C-Right> <C-W><<C-W><
nmap <C-Up> <C-W>+
nmap <C-Down> <C-W>-

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

" use Ctrl-N/Ctrl-P to shift tabs
nnoremap <C-N> :tabn<CR>
nnoremap <C-P> :tabp<CR>

" use Shift-N/Shift-P to switch buffers
nnoremap <S-N> :bn<CR>
nnoremap <S-P> :bp<CR>

" discussion of different tab functions
" http://vim.wikia.com/wiki/Smart_mapping_for_tab_completion

" "trick to fix shift-tab http://vim.wikia.com/wiki/Make_Shift-Tab_work
"map <Esc>[Z <s-tab>
"ounmap <Esc>[Z

"---TAB BINDINGS
"Tab and Ctrl-i are bound to the same internal key with vim, therefore
"they cannot be bound to different commands in normal mode :(
"IE bind Tab to indent and Ctrl-I to 'move into movement stack'
                        "nmap <S-Tab> :<<CR>

"Change tab of selected lines while in visual mode
vmap <Tab> >gv
vmap <S-Tab> <gv

" [<Ctrl>+V <Tab> still inserts an actual tab character.]
"inoremap <Tab> <c-r>=InsertTabWrapper ("forward")<CR>
"imap <S-Tab> <C-D>

" Remap TAB to keyword completion and indenting. The tab key is a still a work
" in progress.
"function! InsertTabWrapper(direction)
  "" alternate line checking
  """ let col = col('.') - 1
  "" if !col || strpart(getline('.'), col-1, col) =~ '\s'
  "if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
    "return "\<tab>"
  "elseif "forward" == a:direction
    "return "\<c-n>"
  "elseif "backward" == a:direction
    "return "\<c-d>"
  "else
    "return "\<c-x>\<c-k>"
  "endif
"endfunction

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
nnoremap Y y$
vnoremap Y y$

" dulpicate line in visual mode
vmap D y'>p

highlight OverTheLine cterm=underline gui=underline
nnoremap <silent> <Leader>hl
      \ :if exists('w:long_line_match') <Bar>
      \   silent! call matchdelete(w:long_line_match) <Bar>
      \   unlet w:long_line_match <Bar>
      \ elseif &textwidth > 0 <Bar>
      \   let w:long_line_match = matchadd('OverTheLine', '\%>'.&tw.'v.\+', -1) <Bar>
      \ else <Bar>
      \   let w:long_line_match = matchadd('OverTheLine', '\%>80v.\+', -1) <Bar>
      \ endif<CR>

" Make p in Visual mode replace the selected text with the "" register.
" vnoremap p <Erc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

" change first word of current line
" map <silent> <C-h> ^cw

" toggle paste on/off
nnoremap \tp :set invpaste paste?<CR>

"toggle list on/off and report the change:
nnoremap \tl :set invlist list?<CR>

"toggle highlighting of search matches, and report the change:
nnoremap \th :set invhls hls?<CR>

"toggle numbers
nnoremap \tn :set number!<Bar> set number?<CR>

" toggle spelling
nnoremap <leader>sp :set spell! spelllang=en_us spell?<CR>

"toggle wrap and easy movement keys while in wrap mode
"nnoremap <silent> <leader>w :set invwrap wrap?<CR>
noremap <silent> <Leader>tw :call ToggleWrap()<CR>
function! ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    setlocal virtualedit=
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
    setlocal virtualedit=all
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

" tab complete?
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <C-Space> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
imap <C-@> <C-Space>

" Force gm to go the middle of the ACTUAL line, not the screen line
nmap <silent> gm :exe 'normal '.(virtcol('$')/2).'\|'<CR>

" Allows vim to split window to a terminal, thanks to screen.
" Requires screener.sh
" From http://www.semicomplete.com/blog/geekery/flashback-2010-2003.html
" map \s :silent !screener.sh<CR>

"clear the fucking search buffer, not just remove the highlight
map \c  :let @/ = ""<CR>
map \tc :let @/ = ""<CR>

" remove highlighted search
nmap <silent> ,/ :nohlsearch<CR>

" search literally, without vim magic
nnoremap / /\V
nnoremap ? ?\V
nnoremap <leader>/ /\v
nnoremap <leader>? ?\v

" Revert the current buffer
nnoremap \r :e!<CR>

"Easy edit of vimrc
nmap \ev :e $MYVIMRC<CR>
nmap \sv :source $MYVIMRC<CR>

" Quit Vim
map \q :qall!<CR>

" Kill buffer
map \x :bd<CR>

" Show eeeeeeverything!
nmap \I :verbose set ai? si? cin? cink? cino? cinw? inde? indk? formatoptions? filetype? fileencoding? syntax? <CR>

"replace all tabs with 4 spaces
 map \ft :%s/	/    /g<CR>
" use :retab instead

" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
nmap <leader>s :call <SID>StripTrailingWhitespaces()<cr>

" Quick alignment of text
" map \al :left<CR>
" map \ar :right<CR>
" map \ac :center<CR>

" Replace current visually selected word
vmap \r "sy:%s/<C-R>=substitute(@s,"\n",'\\n','g')<CR>/

" Show number of occurrences of currently visually selected word
"vmap \s "sy:%s/<C-R>=substitute(@s,"\n",'\\n','g')<CR>//n<CR>

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

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
     \ synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
endfunc
nmap <leader>ss :call SynStack()<CR>

" ### Custom text inserts ###################################################
"insert THE time!
"TODO move this into some kind of autotext complete thing
nmap \tt :execute "normal i" . strftime("%Y/%m/%d %H:%M:%S")<Esc>

iab _AUTHOR Matt Behrens <askedrelic@gmail.com>
iab lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras sollicitudin quam eget libero pulvinar id condimentum velit sollicitudin. Proin cursus scelerisque dui ac condimentum. Nullam quis tellus leo. Morbi consectetur, lectus a blandit tincidunt, tortor augue tincidunt nisi, sit amet rhoncus tortor velit eu felis.

" ### Plugins ###################################################
" First, load pathogen
" filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

"Tabularize align options
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a> :Tabularize /=><CR>
vmap <Leader>a> :Tabularize /=><CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>
nmap <Leader>a  :Tabularize /
vmap <Leader>a  :Tabularize /

" Tagbar
let g:tagbar_left    = 1 " Open tagbar on the left
let g:tagbar_sort    = 0 " Sort tags by file order by default
let g:tagbar_compact = 1 " Remove empty lines by default
map \t :TagbarOpenAutoClose<CR>

"NERDTree
map <silent> \e :NERDTree<CR>
map <silent> \E :NERDTreeToggle<CR>
map <silent> \m :NERDTreeFind<CR>
let NERDTreeWinPos              = 'right'
let NERDTreeChDirMode           = '0'
let NERDTreeIgnore              = ['\.vim$', '\~$', '\.pyo$', '\.pyc$', '\.svn[\//]$', '\.swp$']
let NERDTreeSortOrder           = ['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']
let NERDTreeHighlightCursorline = 1
let NERDTreeShowFiles           = 1 " Show hidden files, too
let NERDTreeShowHidden          = 1
let NERDTreeMinimalUI           = 1 " Hide 'up a dir' and help message

" FuzzyFinder
"Seriously FF, setting up your options sucks
"if !exists('g:FuzzyFinderOptions')
    "let g:FuzzyFinderOptions = { 'Base':{}, 'Buffer':{}, 'File':{}, 'Dir':{}, 'MruFile':{}, 'MruCmd':{}, 'Bookmark':{}, 'Tag':{}, 'TaggedFile':{}}
    "let g:FuzzyFinderOptions.File.excluded_path = '\v\~$|\.o$|\.exe$|\.bak$|\.swp$|((^|[/\\])\.{1,2}[/\\]$)|\.pyo$|\.pyc$|\.svn[/\\]$'
    "let g:FuzzyFinderOptions.Base.key_open_vsplit = '<Space>'
"endif
"let g:fuzzy_matching_limit = 10
"let g:fuzzy_ceiling        = 20000
"let g:fuzzy_ignore         = "*.log;*.pyc;*.pyo;*.svn;*.gif;*.png;*.jpg;*.jpeg;*.git;*.egg\/*"
"let g:fuzzy_ignore         = "\v\~$|\.(o|exe|dll|bak|orig|sw[po]|pyc|pyo|log)$|(^|[/\\])\.(hg|git|bzr|*)($|[/\\])"
"latest fufzzyfinder
let g:fuf_file_exclude = "\v\~$|\.(o|exe|dll|bak|orig|sw[po]|pyc|pyo|log)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])"
"let g:fuf_coveragefile_exclude = "\v\~$|\.(o|exe|dll|bak|orig|sw[po]|pyc|pyo|log)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])"
"map <silent> \f :FuzzyFinderTextMate<CR>
"map <silent> \F :FuzzyFinderTextMateRefreshFiles<CR>:FuzzyFinderTextMate<CR>
"map <silent> \b :FuzzyFinderBuffer!<CR>

" Netrw
let g:netrw_hide              = 1
let g:netrw_list_hide         = '^\.svn.*'
let g:netrw_menu              = 0
let g:netrw_silent            = 1
let g:netrw_special_syntax    = 1

"TaskList
map \l <Plug>TaskList

" MBE
let g:miniBufExplSplitBelow=0
