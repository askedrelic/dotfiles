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

" First, use modern vim and clear any existing autocommands
set nocompatible
autocmd!

function! General_Settings()
    " Restore the screen when we're exiting and set correct terminal
    behave xterm
    if &term == "xterm"
        let &term = "xtermc"
        set rs
        set t_ti= 7 [r [?47h
        set t_te= [?47l 8
    endif

    " save last 50 search history items, last 50 edit marks, don't remember search
    " highlight
    set viminfo=/50,'50,h

    " where to put backup files
    " set backupdir=~/.vim/backup
    " directory to place swap files in
    " set directory=~/.vim/tmp

    " Resize splits when the window is resized
    au VimResized * exe "normal! \<c-w>="

    " allow you to have multiple files open and change between them without saving
    set hidden
    "make backspace work
    set backspace=indent,eol,start
    " Show matching brackets
    set showmatch
    " have % bounce between angled brackets, as well as other kinds:
    " set matchpairs+=<:>
    " set comments=s1:/*,mb:*,ex:*/,f://,b:#,:%,:XCOMM,n:>,fb:-
    " This being the 21st century, I use Unicode
    set encoding=utf-8
    " Don't keep a backup or swap file
    set nobackup
    set noswapfile
    " keep 1000 lines of command line history
    set history=1000
    " keep 1000 undo levels
    set undolevels=1000
    " report: show a report when N lines were changed. 0 means 'all'
    set report=0
    " runtimepath: list of dirs to search for runtime files
    set runtimepath=~/.vim,$VIMRUNTIME
    " Like File Explorer, preview window height is 8
    "set previewheight=8
    " always show status line
    set ls=2
    " Turn off bell, this could be more annoying, but I'm not sure how
    set vb t_vb=
    " shorten all vim messages
    set shortmess=flnrxoOItTA
    " We have a modern terminal
    set ttyfast

    " Use OSX Textmate style tabs and eol
    " tab:▸
    " eol:¬
    execute 'set listchars+=tab:' . nr2char(9656) . nr2char(183)
    execute 'set listchars+=eol:' . nr2char(172)

    "check if file is written to elsewhere and ask to reload immediately, not when saving
    "au CursorHold * checktime
    " automatically reload a file when it has changed externally
    set autoread
    " automatically write the file a bunch of commands
    set autowrite

    " turn on wild command line completion (for :e)
    set wildmenu
    " Bash tab style completion is awesome
    set wildmode=longest,list
    " Tab completion key: default value is <C-E> but who doesn't complete with tab?
    set wildchar=<tab>
    " Ignore these filenames during enhanced command line completion.
    set wildignore+=*.DS_Store                       " OSX bullshit
    set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
    set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
    set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
    set wildignore+=*.pyc                            " Python byte code
    set wildignore+=*.spl                            " compiled spelling word lists
    set wildignore+=*.sw?                            " Vim swap files
    " set wildignore+=*/.git/*,*/.hg/*,*/.svn/*        " Source control
    set wildignore+=*/eggs/*,*/develop-eggs/*        " Python buildout
endfunction
call General_Settings()

function! Status_Bar()
    " Helper functions
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

    function! GetFileFormat()
        if &fileformat == '' || &fileformat == 'unix'
            return ''
        else
            return &fileformat
        endif
    endfunction

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
endfunction
call Status_Bar()

function! Tabs()
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
    call Tabstyle_spaces()

    " when at 3 spaces, and I hit > ... go to 4, not 5
    set shiftround
endfunction
call Tabs()

" ### Scrollbars/Status ###################################################
function! Scrollbars()
    " show the cursor position all the time
    set ruler
    " always show line numbers
    set number
    " show in terminal title bar
    set title
    " display the current mode
    set showmode
    " display partially-typed commands
    set showcmd

    " ### Windows #############################################################
    set splitbelow splitright
    "
    " don't always keep windows at equal size (for minibufexplorer)
    set noequalalways

    " ### Cursor Highlights ###################################################
    " highlight current line is good enough
    set cursorline
    "set cursorcolumn

    set scrolloff=3
    set sidescroll=1
    set sidescrolloff=10

    "Highlight cursorline ONLY in the active window:
    au WinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline

    " Highlight long lines
    highlight clear ColorColumn
    highlight ColorColumn cterm=underline gui=underline
    "set colorcolumn=+1
    nnoremap <silent> <leader>hl
        \ :if exists('w:long_line_match') <Bar>
        \   silent! call matchdelete(w:long_line_match) <Bar>
        \   unlet w:long_line_match <Bar>
        \ elseif &textwidth > 0 <Bar>
        \   let w:long_line_match = matchadd('ColorColumn', '\%>'.&tw.'v.\+', -1) <Bar>
        \ else <Bar>
        \   let w:long_line_match = matchadd('ColorColumn', '\%>80v.\+', -1) <Bar>
        \ endif<CR>
endfunction
call Scrollbars()

function! Searching()
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
endfunction
call Searching()

function! Colors()
    syntax on
    set background=dark
    " One unified gui/terminal colorscheme
    colo Tomorrow-Night-Eighties

    if has("gui_running")
        set guifont=Monaco:h12

        " Orange :()
        highlight SpellBad term=underline gui=undercurl guisp=Orange

        " set lines=73 columns=271
        set guioptions+=c " use console dialogs
        set guioptions-=e " don't use gui tabs
        set guioptions-=T " don't show toolbar
        set guioptions-=m " don't show menu bar
        set guioptions-=l " don't show left-hand scrollbar
        set guioptions-=L " don't show left-hand scrollbar
        set guioptions-=r " don't show right-hand scrollbar
        set guioptions-=R " don't show right-hand scrollbar

        " Use a line-drawing char for pretty vertical splits.
        set fillchars+=vert:│
    endif
endfunction
call Colors()

function! Line_Wrapping()
    " don't make it look like there are line breaks where there aren't:
    set nowrap
    " Wrap at word
    set linebreak

    " have the h and l cursor keys wrap between lines (like <Space> and <BkSpc> do
    " by default), and ~ covert case over line breaks; also have the cursor keys
    " wrap in insert mode:
    set whichwrap=h,l,~,[,]

    " only format comments at 80 chars by default, while typing
    set formatoptions=cq
    set textwidth=80
endfunction
call Line_Wrapping()

function! File_Types()
    filetype plugin indent on

    " Omni Completion
    " mine set completeopt=menu,menuone,longest
    set completeopt=longest,menuone,preview

    " complete using built in syntax? http://vim.wikia.com/wiki/Completion_using_a_syntax_file
    au FileType * exec('setlocal dict+='.$VIMRUNTIME.'/syntax/'.expand('<amatch>').'.vim')

    " CSS and LessCSS
    augroup ft_css
        au!

        au BufNewFile,BufRead *.less setlocal filetype=less

        "au Filetype less,css setlocal foldmethod=marker
        "au Filetype less,css setlocal foldmarker={,}
        au Filetype less,css setlocal omnifunc=csscomplete#CompleteCSS
        au Filetype less,css setlocal iskeyword+=-

        " Use <leader>S to sort properties.  Turns this:
        "
        "     p {
        "         width: 200px;
        "         height: 100px;
        "         background: red;
        "
        "         ...
        "     }
        "
        " into this:

        "     p {
        "         background: red;
        "         height: 100px;
        "         width: 200px;
        "
        "         ...
        "     }
        au BufNewFile,BufRead *.less,*.css nnoremap <buffer> <localleader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>

        " Make {<cr> insert a pair of brackets in such a way that the cursor is correctly
        " positioned inside of them AND the following code doesn't get unfolded.
        au BufNewFile,BufRead *.less,*.css inoremap <buffer> {<cr> {}<left><cr><space><space><space><space>.<cr><esc>kA<bs>
    augroup END

    " Django
    augroup ft_django
        au!

        au BufNewFile,BufRead urls.py           setlocal nowrap
        au BufNewFile,BufRead urls.py           normal! zR
        au BufNewFile,BufRead dashboard.py      normal! zR
        au BufNewFile,BufRead local_settings.py normal! zR

        au BufNewFile,BufRead admin.py            setlocal filetype=python.django
        au BufNewFile,BufRead urls.py             setlocal filetype=python.django
        au BufNewFile,BufRead models.py           setlocal filetype=python.django
        au BufNewFile,BufRead views.py            setlocal filetype=python.django
        au BufNewFile,BufRead settings.py         setlocal filetype=python.django
        au BufNewFile,BufRead forms.py            setlocal filetype=python.django
        au BufNewFile,BufRead common_settings.py  setlocal filetype=python.django
    augroup END

    " HTML and HTMLDjango
    augroup ft_html
        au!

        au BufNewFile,BufRead *.html setlocal filetype=htmldjango

        au FileType html setlocal omnifunc=htmlcomplete#CompleteTags
        " Use Shift-Return to turn this:
        "     <tag>|</tag>
        "
        " into this:
        "     <tag>
        "         |
        "     </tag>
        au FileType html,jinja,htmldjango nnoremap <buffer> <s-cr> vit<esc>a<cr><esc>vito<esc>i<cr><esc>

        " Django tags
        au FileType jinja,htmldjango inoremap <buffer> <c-t> {%<space><space>%}<left><left><left>

        " Django variables
        au FileType jinja,htmldjango inoremap <buffer> <c-f> {{<space><space>}}<left><left><left>
    augroup END

    " Java
    augroup ft_java
        au!

        au FileType java setlocal foldmethod=marker
        au FileType java setlocal foldmarker={,}
    augroup END

    " Javascript
    augroup ft_javascript
        au!

        au FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        "au FileType javascript setlocal foldmethod=marker
        "au FileType javascript setlocal foldmarker={,}
    augroup END

    augroup ft_markdown
        au!

        au BufNewFile,BufRead *.m*down setlocal filetype=markdown

        " Use <localleader>1/2/3 to add headings.
        au Filetype markdown nnoremap <buffer> <localleader>1 yypVr=
        au Filetype markdown nnoremap <buffer> <localleader>2 yypVr-
        au Filetype markdown nnoremap <buffer> <localleader>3 I### <ESC>
    augroup END

    augroup ft_nginx
        au!

        au BufRead,BufNewFile /etc/nginx/conf/*                      set ft=nginx
        au BufRead,BufNewFile /etc/nginx/sites-available/*           set ft=nginx
        au BufRead,BufNewFile /usr/local/etc/nginx/sites-available/* set ft=nginx
        au BufRead,BufNewFile vhost.nginx                            set ft=nginx

    augroup END

    " Python
    augroup ft_python
        au!
        let python_highlight_all = 1
        au FileType python setlocal omnifunc=pythoncomplete#Complete
        "au FileType python compiler nose
        au FileType man nnoremap <buffer> <cr> :q<cr>

        " format comments correctly
        au FileType python setlocal textwidth=80
        au FileType python setlocal formatoptions=croqn

        " @NOTE Fuck smartindent, it forces inserting tabs. Use cindent instead
        au FileType python setlocal cindent cinwords=if,elif,else,for,while,with,try,except,finally,def,class
        au FileType python setlocal cinkeys-=0#
        au FileType python setlocal indentkeys-=0#

        " @NOTE This blows up omnifunc complete
        " `gf` jumps to the filename under the cursor.  Point at an import statement
        " and jump to it!
        " python << EOF
        " import os
        " import sys
        " import vim
        " for p in sys.path:
        "     if os.path.isdir(p):
        "         vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
        " EOF
    augroup END

    " Restructured text
    augroup ft_rest
        au!

        au Filetype rst nnoremap <buffer> <localleader>1 yypVr=
        au Filetype rst nnoremap <buffer> <localleader>2 yypVr-
        au Filetype rst nnoremap <buffer> <localleader>3 yypVr~
        au Filetype rst nnoremap <buffer> <localleader>4 yypVr`
    augroup END

    " Ruby
    augroup ft_ruby
        au!

        au Filetype ruby setlocal shiftwidth=2
        au Filetype ruby setlocal softtabstop=2
    augroup END

    augroup ft_vagrant
        au!
        au BufRead,BufNewFile Vagrantfile set ft=ruby
    augroup END

    " Vim
    augroup ft_vim
        au!

        au FileType help setlocal textwidth=78 nonumber
        au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif

        " treat lines starting with a quote mark as comments (for `Vim' files, such as
        " this very one!)
        au FileType vim setlocal comments+=b:\"
    augroup END

    "jump to last cursor position when opening a file
    "except when writing a svn/git commit log entry
    autocmd BufReadPost * call SetCursorPosition()
    function! SetCursorPosition()
        if &filetype !~ 'commit\c' && &filetype !~ 'svn\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal g`\""
        endif
        end
    endfunction
endfunction
call File_Types()

function! Normal_Mappings()
    " Map uppercase write and quit, I'm lazy lazy lazy with shift
    cab W w
    cab Q q
    cab WQ wq
    cab WQ! wq!

    " save even more keystrokes!
    nnoremap ; :

    " page down with <Space> (like in `Lynx', `Mutt', `Pine', `Netscape Navigator',
    " `SLRN', `Less', and `More'); page up with - (like in `Lynx', `Mutt', `Pine'),
    " or <BkSpc> (like in `Netscape Navigator'):
    noremap <Space> <PageDown>
    noremap - <PageUp>

    " swap windows
    nnoremap , <C-w><C-w>

    "move around windows with ctrl key!
    noremap <C-H> <C-W>h
    noremap <C-J> <C-W>j
    noremap <C-K> <C-W>k
    noremap <C-L> <C-W>l
    noremap <leader>v <C-W>v

    " Fix vertsplit window sizing
    nnoremap <C-Left> <C-W>><C-W>>
    nnoremap <C-Right> <C-W><<C-W><
    nnoremap <C-Up> <C-W>+
    nnoremap <C-Down> <C-W>-

    " quickselect tabs with Apple + # (gvim only)
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

    " insert new line without going into insert mode
    nnoremap <Enter> o<ESC>
    nnoremap <S-Enter> :put!=''<CR>

    " Force gm to go the middle of the ACTUAL line, not the screen line
    nnoremap <silent> gm :exe 'normal '.(virtcol('$')/2).'\|'<CR>

    " have Q reformat the current paragraph (or selected text if there is any):
    nnoremap Q gqip
    vnoremap Q gq

    " have Y behave analogously to D and C rather than to dd and cc (which is
    " already done by yy):
    nnoremap Y yt$
    vnoremap Y yt$

    " clear the fucking search buffer, not just remove the highlight
    noremap <leader><space> :noh<cr>:call clearmatches()<cr>

    " search literally, without vim magic
    nnoremap / /\V
    nnoremap ? ?\V
    nnoremap <leader>/ /\v
    nnoremap <leader>? ?\v

    "Easy edit of vimrc
    nnoremap \ev :e $MYVIMRC<CR>
    nnoremap \sv :source $MYVIMRC<CR>

    " Quit Vim
    nnoremap \q :qall!<CR>

    " Revert the current buffer
    nnoremap \r :e!<CR>

    " Kill buffer
    nnoremap \x :bd<CR>

    " Show eeeeeeverything! http://www.youtube.com/watch?v=MrTsuvykUZk
    nnoremap \I :verbose set ai? si? cin? cink? cino? cinw? inde? indk? formatoptions? filetype? fileencoding? syntax? <CR>

    " toggle paste on/off
    nnoremap <leader>tp :set invpaste paste?<CR>

    " toggle list on/off and report the change:
    nnoremap <leader>tl :set invlist list?<CR>

    " toggle highlighting of search matches, and report the change:
    nnoremap <leader>th :set invhls hls?<CR>

    " toggle numbers
    nnoremap <leader>tn :set number!<Bar> set number?<CR>

    " toggle spelling
    nnoremap <leader>sp :set spell! spelllang=en_us spell?<CR>

    " simple substitute
    nnoremap <leader>s :%s//<left>


    " Quick alignment of text
    map \al :left<CR>
    map \ar :right<CR>
    map \ac :center<CR>
endfunction
call Normal_Mappings()

function! Visual_Mappings()
    " duplicate line in visual mode
    vmap D y'>p

    " Make p in Visual mode replace the selected text with the "" register.
    " vmap p <Erc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

    " Replace current visually selected word
    vmap \r "sy:%s/<C-R>=substitute(@s,"\n",'\\n','g')<CR>/

    " Show number of occurrences of currently visually selected word
    "vmap \s "sy:%s/<C-R>=substitute(@s,"\n",'\\n','g')<CR>//n<CR>
endfunction
call Visual_Mappings()

function! Insert_Mappings()
    " Professor VIM says '87% of users prefer jj over esc', jj abrams strongly disagrees
    imap jj <Esc>

    " easier Line and File completemode
    inoremap <c-l> <c-x><c-l>
    inoremap <c-f> <c-x><c-f>
endfunction
call Insert_Mappings()

function! Tab_Mapping()
    " Tab is a VIP key that I am still working on
    "
    " discussion of different tab functions
    " http://vim.wikia.com/wiki/Smart_mapping_for_tab_completion

    "trick to fix shift-tab http://vim.wikia.com/wiki/Make_Shift-Tab_work
    map <Esc>[Z <s-tab>
    ounmap <Esc>[Z

    "Tab and Ctrl-i are bound to the same internal key with vim, therefore
    "they cannot be bound to different commands in normal mode :(
    "IE bind Tab to indent and Ctrl-I to 'move into movement stack'
    "nmap <S-Tab> :<<CR>

    " quick change indent of visual selected text blocks
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
    "
    " tab complete?
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
    \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
    inoremap <expr> <C-Space> pumvisible() ? '<C-n>' :
    \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
    imap <C-@> <C-Space>
endfunction
call Tab_Mapping()

function! Mini_Scripts()
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
    nmap <leader>w :call <SID>StripTrailingWhitespaces()<cr>

    " OSX only: Open a web-browser with the URL in the current line
    function! HandleURI()
    let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
    echo s:uri
    if s:uri != ""
    exec "silent !open \"" . s:uri . "\""
    else
    echo "No URI found in line."
    endif
    endfunction
    map \o :call HandleURI()<CR>

    " Visual indent guide!
    " Stolen from https://bitbucket.org/sjl/dotfiles/src/tip/vim/.vimrc#cl-835
    hi IndentGuides ctermbg=darkgrey guibg=#373737
    let g:indentguides_state = 0
    function! IndentGuides()
        if g:indentguides_state
            let g:indentguides_state = 0
            2match None
        else
            let g:indentguides_state = 1
            execute '2match IndentGuides /\%(\_^\s*\)\@<=\%(\%'.(0*&sw+1).'v\|\%'.(1*&sw+1).'v\|\%'.(2*&sw+1).'v\|\%'.(3*&sw+1).'v\|\%'.(4*&sw+1).'v\|\%'.(5*&sw+1).'v\|\%'.(6*&sw+1).'v\|\%'.(7*&sw+1).'v\)\s/'
        endif
    endfunction
    nnoremap <leader>ti :call IndentGuides()<cr>
endfunction
call Mini_Scripts()

" ### Custom text inserts ###################################################
"insert THE time!
"TODO move this into some kind of autotext complete thing
nmap <leader>tt :execute "normal i" . strftime("%Y/%m/%d %H:%M:%S")<Esc>

iab _AUTHOR Matt Behrens <askedrelic@gmail.com>
iab lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras sollicitudin quam eget libero pulvinar id condimentum velit sollicitudin. Proin cursus scelerisque dui ac condimentum. Nullam quis tellus leo. Morbi consectetur, lectus a blandit tincidunt, tortor augue tincidunt nisi, sit amet rhoncus tortor velit eu felis.

" ### Plugins ###################################################
" First, load pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

"Tabularize align options
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a* :Tabularize /=.*<CR>
vmap <Leader>a* :Tabularize /=.*<CR>
nmap <Leader>a> :Tabularize /=><CR>
vmap <Leader>a> :Tabularize /=><CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>
nmap <Leader>a  :Tabularize /
vmap <Leader>a  :Tabularize /

" Tagbar
let g:tagbar_left      = 1 " Open tagbar on the left
let g:tagbar_sort      = 0 " Sort tags by file order by default
let g:tagbar_compact   = 1 " Remove empty lines by default
let g:tagbar_foldlevel = 0 " Close folds default
map <leader>t :TagbarOpenAutoClose<CR>

" NERDTree
map <silent> \n :NERDTreeTabsToggle<CR>
map <silent> \m :NERDTreeFind<CR>
let NERDTreeWinPos              = 'right'
let NERDTreeChDirMode           = '0'
let NERDTreeIgnore              = ['\.vim$', '\~$', '\.pyo$', '\.pyc$', '\.svn[\//]$', '\.swp$']
let NERDTreeSortOrder           = ['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']
let NERDTreeHighlightCursorline = 1
let NERDTreeShowFiles           = 1 " Show hidden files, too
let NERDTreeShowHidden          = 1
let NERDTreeMinimalUI           = 1 " Hide 'up a dir' and help message

let g:nerdtree_tabs_open_on_console_startup = 1 "always show nerdtree
let g:nerdtree_tabs_focus_on_files = 1

" FuzzyFinder
" map <silent> \h :FufHelpWithCursorWord<CR>
" map <silent> \H :FufHelp<CR>
" map <silent> \f :FufCoverageFile<CR>
" map <silent> \F :FufRenewCache<CR>:FufCoverageFile<CR>

" ctrlp.vim
let g:ctrlp_map = '<c-f>'
" let g:ctrlp_extensions = ['tag', 'buffertag']
let g:ctrlp_jump_to_buffer = 0 " disable this

" Netrw
let g:netrw_hide              = 1
let g:netrw_list_hide         = '^\.svn.*'
let g:netrw_menu              = 0
let g:netrw_silent            = 1
let g:netrw_special_syntax    = 1

" MBE
let g:miniBufExplSplitBelow   = 0

" Commentary
nmap <leader>c <Plug>CommentaryLine
xmap <leader>c <Plug>Commentary
au FileType htmldjango setlocal commentstring={#\ %s\ #}
au FileType python.django setlocal commentstring=#\%s
au FileType python setlocal commentstring=#\%s

" LustyJuggler
let g:LustyJugglerSuppressRubyWarning = 1

" Fugutive
map <silent> \gb :Gblame<CR>
map <silent> \gc :Gcommit -v<CR>
map <silent> \ge :Gedit<CR>
map <silent> \gl :Glog<CR>
map <silent> \gr :Gread<CR>
map <silent> \gs :Gstatus<CR>
map \gg :Ggrep 
