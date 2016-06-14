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

" Use modern vim
set nocompatible

" Fix unicode things
set encoding=utf-8
scriptencoding utf-8

" Setup vim-plug
" Docs here: https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'

" Plug 'junegunn/vim-peekaboo'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'junegunn/gv.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'Lokaltog/vim-easymotion'
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
Plug 'ctrlpvim/ctrlp.vim'


" Alignment
" https://github.com/tommcdo/vim-lion
Plug 'tommcdo/vim-lion'

Plug 'dhruvasagar/vim-vinegar'
" Trying filebeagle; faster and simpler than vinegar/nerdtree
" Plug 'jeetsukumaran/vim-filebeagle'

" Airline status bar and themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" A better JSON for Vim
Plug 'elzr/vim-json'

" Normal Mode
" - gagiw to search the word
" - gagi' to search the words inside single quotes.
" Visual Mode
" - gag to search the selected text
" Plug 'Chun-Yang/vim-action-ag'

Plug 'ervandew/supertab' ", {'commit': 'feb2a5f8'}
Plug 'gabesoft/vim-ags'
" Plug 'rking/ag.vim'
Plug 'garbas/vim-snipmate' ", {'commit': '2d3e8ddc'}
Plug 'godlygeek/tabular'
Plug 'gregsexton/MatchTag'
Plug 'honza/vim-snippets'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'junegunn/vim-easy-align'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'msanders/cocoa.vim'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'rhysd/clever-f.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'FelikZ/ctrlp-py-matcher'


" Better yaml syntax highlighting
Plug 'stephpy/vim-yaml'

" indenting
" https://github.com/jeetsukumaran/vim-indentwise
Plug 'jeetsukumaran/vim-indentwise'

" Yaml indent support
Plug 'martin-svk/vim-yaml'

Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

" Eunuch - vim sugar for the UNIX shell commands
" :Remove: Delete a buffer and the file on disk simultaneously.
" :Unlink: Like :Remove, but keeps the now empty buffer.
" :Move: Rename a buffer and the file on disk simultaneously.
" :Rename: Like :Move, but relative to the current file's containing directory.
" :Chmod: Change the permissions of the current file.
" :Mkdir: Create a directory, defaulting to the parent of the current file.
" :Find: Run find and load the results into the quickfix list.
" :Locate: Run locate and load the results into the quickfix list.
" :Wall: Write every open window. Handy for kicking off tools like guard.
" :SudoWrite: Write a privileged file with sudo.
" :SudoEdit: Edit a privileged file with sudo.
" File type detection for sudo -e is based on original file name.
" New files created with a shebang line are automatically made executable.
" New init scripts are automatically prepopulated with /etc/init.d/skeleton.
Plug 'tpope/vim-eunuch'


Plug 'vim-scripts/matchit.zip'
Plug 'vim-scripts/python_match.vim'
Plug 'vim-scripts/visualrepeat'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'https://gitlab.com/mcepl/vim-diff_navigator.git'
call plug#end()

" Create vimrc group
augroup vimrc
  autocmd!
augroup END

function! General_Settings()
    " Restore the screen when we're exiting and set correct terminal
    behave xterm
    if &term == "xterm"
        let &term = "xtermc"
        set rs
        set t_ti= 7 [r [?47h
        set t_te= [?47l 8
    endif

    " Fix term under cli vim
    if exists('$TMUX') && !has("gui_running")
        set term=screen-256color
    endif

    " save last 50 search history items, last 50 edit marks, don't remember search
    " highlight
    set viminfo=/50,'50,h

    set backup      " enable backup files
    set writebackup " enable backup files
    set swapfile    " enable swap files (useful when loading huge files)

    let s:vimdir=$HOME . "/.vim"
    let &backupdir=s:vimdir . "/backup"  " backups location
    let &directory=s:vimdir . "/tmp"     " swap location

    if exists("*mkdir")
        if !isdirectory(s:vimdir)
            call mkdir(s:vimdir, "p")
        endif
        if !isdirectory(&backupdir)
            call mkdir(&backupdir, "p")
        endif
        if !isdirectory(&directory)
            call mkdir(&directory, "p")
        endif
    endif

    set backupskip+=*.tmp " skip backup for *.tmp

    let &viminfo=&viminfo . ",n" . s:vimdir . "/.viminfo" " viminfo location

    " if you want to yank and paste with the system clipboard
    " set clipboard=unnamed

    " keep 1000 lines of command line history
    set history=1000
    " keep 1000 undo levels
    set undolevels=1000
    " Resize splits when the window is resized
    autocmd VimResized * exe "normal! \<c-w>="
    " allow you to have multiple files open and change between them without saving
    set hidden
    "make backspace work
    set backspace=indent,eol,start
    " Show matching brackets
    set showmatch
    " have % bounce between angled brackets, as well as other kinds:
    " set matchpairs+=<:>
    " set comments=s1:/*,mb:*,ex:*/,f://,b:#,:%,:XCOMM,n:>,fb:-
    " report: show a report when N lines were changed. 0 means 'all'
    set report=0
    " runtimepath: list of dirs to search for runtime files
    " set runtimepath=~/.vim,$VIMRUNTIME
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
    set fileformats=unix,dos,mac
    " Don't try to highlight lines longer than 800 characters.
    set synmaxcol=800
    " Add vertical spaces to keep right and left aligned
    set diffopt=filler
    " Ignore whitespace changes (focus on code changes)
    set diffopt+=iwhite

    " Allow cursor keys in insert mode.
    set esckeys
    " Only insert single space after a '.', '?' and '!' with a join command.
    set nojoinspaces
    " Don't reset cursor to start of line when moving around.
    set nostartofline
    " Use /bin/sh for executing shell commands
    set shell=/bin/sh

    " Use OSX Textmate style tabs and eol
    " tab:▸
    " eol:¬
    " execute 'set listchars+=tab:' . nr2char(9656) . nr2char(183)
    " execute 'set listchars+=eol:' . nr2char(172)
    " set listchars=eol:¬,tab:→→,extends:>,precedes:<
    set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
    set showbreak=↪

    "check if file is written to elsewhere and ask to reload immediately, not when saving
    "autocmd CursorHold * checktime
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
    set wildignore+=.tox                             " Python tox directory
    set wildignore+=*.spl                            " compiled spelling word lists
    set wildignore+=*.sw?                            " Vim swap files
    " set wildignore+=*/.git/*,*/.hg/*,*/.svn/*        " Source control
    " set wildignore+=*/eggs/*,*/develop-eggs/*        " Python buildout

    " redraw only when we need to.
    set lazyredraw

    " Time out on key codes but not mappings.
    " Basically this makes terminal Vim work sanely.
    " set timeout
    set ttimeoutlen=50

    " set ttimeout
    " set ttimeoutlen=100

    " make matchparen timeout quickly; don't take forever on long lines
    let g:matchparen_insert_timeout=5

    " let mapleader = ','
    let g:mapleader = ','

    " Search for ctags file up to /
    set tags=tags;./;/
endfunction
call General_Settings()

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
    " function! Tabstyle_3spaces()
    "     " Use 3 spaces
    "     set expandtab
    "     set autoindent
    "     set copyindent
    "     set shiftwidth=3
    "     set tabstop=3
    "     set softtabstop=3
    " endfunction
    function! Tabstyle_2spaces()
        " Use 2 spaces
        setlocal expandtab
        setlocal autoindent
        setlocal copyindent
        setlocal shiftwidth=2
        setlocal tabstop=2
        setlocal softtabstop=2
    endfunction

    call Tabstyle_spaces()

    command! -nargs=* Stab call Stab()
    function! Stab()
        let l:tabstop = 1 * input('set shiftwidth=')

        if l:tabstop > 0
            " do we want expandtab as well?
            " let l:expandtab = confirm('set expandtab?', "&Yes\n&No\n&Cancel")
            " if l:expandtab == 3
            "     " abort?
            "     return
            " endif

            let &l:sts = l:tabstop
            let &l:ts = l:tabstop
            let &l:sw = l:tabstop

            setlocal expandtab
        endif
        setlocal expandtab

        " show the selected options
        try
            echohl ModeMsg
            echon 'set tabstop='
            echohl Question
            echon &l:ts
            echohl ModeMsg
            echon ' shiftwidth='
            echohl Question
            echon &l:sw
            echohl ModeMsg
            echon ' sts='
            echohl Question
            echon &l:sts . ' ' . (&l:et ? '  ' : 'no')
            echohl ModeMsg
            echon 'expandtab'
        finally
            echohl None
        endtry
    endfunction

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

    " don't always keep windows at equal size (for minibufexplorer)
    " set noequalalways

    " ### Cursor Highlights ###################################################
    " highlight current line is good enough
    set cursorline
    "set cursorcolumn

    set scrolloff=3
    set sidescroll=1
    set sidescrolloff=10

    "Highlight cursorline ONLY in the active window:
    autocmd WinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline

    " Highlight long lines
    highlight clear ColorColumn
    highlight ColorColumn cterm=underline gui=underline
    "set colorcolumn=+1
    " Highlight Long lines
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
    " Enable extended regexes.
    set magic
    " Searches wrap around end of file
    set wrapscan
endfunction
call Searching()

function! Colors()
    set background=dark
    set t_Co=256
    " One unified gui/terminal colorscheme
    " colo Tomorrow-Night-Eighties
    color badwolf

    if has("gui_running")
        " set guifont=Monaco:h12
        set guifont=Hack:h12

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

    " better diff pastel green/yellow/red diff colors
    hi DiffAdd      ctermfg=0 ctermbg=2 guibg=#cfffac guifg=#000000
    hi DiffDelete   ctermfg=0 ctermbg=1 guibg=#ffb6b0 guifg=#000000
    hi DiffChange   ctermfg=0 ctermbg=3 guibg=#ffffcc guifg=#000000
    hi SignColumn   guibg=#1C1B1A ctermbg=0

    " Show the stack of syntax hilighting classes affecting whatever is under the
    " cursor.
    function! SynStack() "{{{
        echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), " > ")
    endfunc "}}}

    " Highlight Tag? syntax?
    nnoremap <leader>ht :call SynStack()<CR>
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
    set textwidth=80

    set formatoptions=
    set formatoptions+=c " Format comments
    set formatoptions+=r " Continue comments by default
    " set formatoptions+=o " Make comment when using o or O from comment line
    set formatoptions+=q " Format comments with gq
    set formatoptions+=n " Recognize numbered lists
    set formatoptions+=2 " Use indent from 2nd line of a paragraph
    set formatoptions+=l " Don't break lines that are already long
    set formatoptions+=1 " Break before 1-letter words
endfunction
call Line_Wrapping()

function! File_Types()
    " Omni Completion
    " mine set completeopt=menu,menuone,longest
    set completeopt=longest,menuone,preview

    " complete using built in syntax? http://vim.wikia.com/wiki/Completion_using_a_syntax_file
    " autocmd FileType * exec('setlocal dict+='.$VIMRUNTIME.'/syntax/'.expand('<amatch>').'.vim')

    " CSS and LessCSS
    augroup ft_css
        autocmd!

        autocmd BufNewFile,BufRead *.less setlocal filetype=less

        "autocmd Filetype less,css setlocal foldmethod=marker
        "autocmd Filetype less,css setlocal foldmarker={,}
        autocmd Filetype less,css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd Filetype less,css setlocal iskeyword+=-

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
        autocmd BufNewFile,BufRead *.less,*.css nnoremap <buffer> <localLeader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>

        " Make {<cr> insert a pair of brackets in such a way that the cursor is correctly
        " positioned inside of them AND the following code doesn't get unfolded.
        autocmd BufNewFile,BufRead *.less,*.css inoremap <buffer> {<cr> {}<left><cr><space><space><space><space>.<cr><esc>kA<bs>
    augroup END

    " Django
    augroup ft_django
        autocmd!

        autocmd BufNewFile,BufRead urls.py             setlocal nowrap
        autocmd BufNewFile,BufRead urls.py             normal! zR
        autocmd BufNewFile,BufRead dashboard.py        normal! zR
        autocmd BufNewFile,BufRead local_settings.py   normal! zR

        autocmd BufNewFile,BufRead admin.py            setlocal filetype=python.django
        autocmd BufNewFile,BufRead urls.py             setlocal filetype=python.django
        autocmd BufNewFile,BufRead models.py           setlocal filetype=python.django
        autocmd BufNewFile,BufRead views.py            setlocal filetype=python.django
        autocmd BufNewFile,BufRead settings.py         setlocal filetype=python.django
        autocmd BufNewFile,BufRead forms.py            setlocal filetype=python.django
        autocmd BufNewFile,BufRead common_settings.py  setlocal filetype=python.django
    augroup END

    " HTML and HTMLDjango
    augroup ft_html
        autocmd!

        autocmd BufNewFile,BufRead *.html setlocal filetype=htmldjango
        " call Tabstyle_2spaces()

        "hitting % on <ul> jumps to <li> instead of </ul>
        autocmd FileType html let b:match_words='<:>,<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'

        autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
        " Use Shift-Return to turn this:
        "     <tag>|</tag>
        "
        " into this:
        "     <tag>
        "         |
        "     </tag>
        autocmd FileType html,jinja,htmldjango nnoremap <buffer> <s-cr> vit<esc>a<cr><esc>vito<esc>i<cr><esc>

        " Django tags
        autocmd FileType jinja,htmldjango inoremap <buffer> <c-t> {%<space><space>%}<left><left><left>

        " Django variables
        autocmd FileType jinja,htmldjango inoremap <buffer> <c-f> {{<space><space>}}<left><left><left>
    augroup END

    " Java
    augroup ft_java
        autocmd!

    augroup END

    " Javascript
    augroup ft_javascript
        autocmd!
        " call Tabstyle_2spaces()

        " easy comment insert
        autocmd FileType javascript inoremap <buffer> <c-c> console.log();<left><left>
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        " autocmd FileType javascript setlocal foldmethod=marker
        " autocmd FileType javascript setlocal foldmarker={,}
    augroup END

    augroup ft_markdown
        autocmd!

        autocmd BufNewFile,BufRead *.m*down setlocal filetype=markdown

        " Use <localLeader>1/2/3 to add headings.
        autocmd Filetype markdown nnoremap <buffer> <localLeader>1 yypVr=
        autocmd Filetype markdown nnoremap <buffer> <localLeader>2 yypVr-
        autocmd Filetype markdown nnoremap <buffer> <localLeader>3 I### <ESC>
    augroup END

    augroup ft_nginx
        autocmd!

        autocmd BufRead,BufNewFile /etc/nginx/conf/*                      set ft=nginx
        autocmd BufRead,BufNewFile /etc/nginx/sites-available/*           set ft=nginx
        autocmd BufRead,BufNewFile /usr/local/etc/nginx/sites-available/* set ft=nginx
        autocmd BufRead,BufNewFile vhost.nginx                            set ft=nginx

    augroup END

    " Python
    augroup ft_python
        autocmd!
        let g:python_highlight_all = 1
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        "autocmd FileType python compiler nose
        autocmd FileType man nnoremap <buffer> <cr> :q<cr>

        " format comments correctly
        autocmd FileType python setlocal textwidth=80
        autocmd FileType python setlocal formatoptions=croqn

        " @NOTE Fuck smartindent, it forces inserting tabs. Use cindent instead
        autocmd FileType python setlocal cindent cinwords=if,elif,else,for,while,with,try,except,finally,def,class
        autocmd FileType python setlocal cinkeys-=0#
        autocmd FileType python setlocal indentkeys-=0#

        " autocmd FileType python inoremap <buffer> <c-f> import IPython; IPython.embed()

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
        autocmd!

        autocmd Filetype rst nnoremap <buffer> <localLeader>1 yypVr=
        autocmd Filetype rst nnoremap <buffer> <localLeader>2 yypVr-
        autocmd Filetype rst nnoremap <buffer> <localLeader>3 yypVr~
        autocmd Filetype rst nnoremap <buffer> <localLeader>4 yypVr`
    augroup END

    " Ruby
    augroup ft_ruby
        autocmd!

        autocmd Filetype ruby setlocal shiftwidth=2
        autocmd Filetype ruby setlocal softtabstop=2
    augroup END

    augroup ft_vagrant
        autocmd!
        autocmd BufRead,BufNewFile Vagrantfile set ft=ruby
    augroup END

    " Vim
    augroup ft_vim
        autocmd!

        autocmd FileType help setlocal textwidth=78 nonumber
        autocmd BufWinEnter *.txt if &ft == 'help' | wincmd L | endif

        " treat lines starting with a quote mark as comments (for `Vim' files, such as
        " this very one!)
        autocmd FileType vim setlocal comments+=b:\"
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

    " Fuck you, help key.
    noremap  <F1> <nop>
    inoremap <F1> <nop>

    " page down with <Space> (like in `Lynx', `Mutt', `Pine', `Netscape Navigator',
    " `SLRN', `Less', and `More'); page up with - (like in `Lynx', `Mutt', `Pine'),
    " or <BkSpc> (like in `Netscape Navigator'):
    " noremap <Space> <PageDown>
    " noremap - <PageUp>
    " noremap <Space> <C-D>zz
    " nnoremap - <C-U>zz

    " Speed up viewport scrolling
    nnoremap <C-e> 5<C-e>
    nnoremap <C-y> 5<C-y>

    " Faster split resizing (+,-)
    " if bufwinnr(1)
    "   map + <C-W>+
    "   map - <C-W>-
    " endif

    " swap windows
    " nnoremap , <C-w><C-w>

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

    " easy tab movement
    nnoremap { :tabp<CR>
    nnoremap } :tabn<CR>

    " insert new line without going into insert mode
    nnoremap <Enter> o<ESC>
    nnoremap <S-Enter> :put!=''<CR>

    " Force gm to go the middle of the ACTUAL line, not the screen line
    nnoremap <silent> gm :exe 'normal '.(virtcol('$')/2).'\|'<CR>

    " have Q reformat the current paragraph (or selected text if there is any):
    nnoremap Q gqip
    vnoremap Q gq

    " visual select last pasted text
    noremap gV `[v`]

    " have Y behave analogously to D and C rather than to dd and cc (which is
    " already done by yy):
    nnoremap Y yt$
    vnoremap Y yt$

    " delete without yanking
    " nnoremap <leader>d "_d
    " vnoremap <leader>d "_d

    vnoremap <silent> y y`]
    vnoremap <silent> p p`]
    nnoremap <silent> p p`]

    " replace currently selected text with default register
    " without yanking it
    " nnoremap p "_dP
    " vnoremap p "_dP

    " clear the fucking search buffer, not just remove the highlight
    nnoremap <leader>l :noh<CR>:call clearmatches()<CR>
    " nnoremap <leader>/ /\v
    " nnoremap <leader>? ?\v

    "Easy edit of vimrc
    nnoremap <leader>ev :vsplit $MYVIMRC<CR>
    map <silent> <leader>sv :source $MYVIMRC<CR>:redraw<CR>:echo $MYVIMRC 'reloaded'<CR>

    " Quit Vim
    nnoremap <leader>Q :qall!<CR>

    " Kill current viewport
    nnoremap <leader>q :quit<CR>

    " Revert the current buffer
    nnoremap <leader>r :e!<CR>

    " Show eeeeeeverything! http://www.youtube.com/watch?v=MrTsuvykUZk
    nnoremap <leader>I :verbose set ai? si? cin? cink? cino? cinw? inde? indk? formatoptions? filetype? fileencoding? syntax? <CR>

    " Toggle paste on/off
    " nnoremap <leader>tp :set invpaste paste?<CR>
    nnoremap <leader>p :set invpaste paste?<CR>

    " toggle list on/off and report the change:
    nnoremap <leader>tl :set invlist list?<CR>

    " toggle highlighting of search matches, and report the change:
    nnoremap <leader>th :set invhls hls?<CR>

    " toggle numbers
    nnoremap <leader>tn :set number!<Bar> set number?<CR>

    " toggle spelling
    nnoremap <leader>sp :set spell! spelllang=en_us spell?<CR>

    " simple substitute
    " 2015/02/06 dont think I need this
    " nnoremap <leader>s :%s//<left>

    " ehh whatelse to bind
    nnoremap <leader>m :w<CR>:make<CR>

    " [J]oin lines and preserve cursor position
    nnoremap J :call Preserve("normal! J")<CR>

    " split line (sister to [J]oin lines) and preserve cursor position
    nnoremap S :call Preserve("normal! i\r")<CR>

    " Fix page up and down
    " map <PageUp> <C-U>
    " map <PageDown> <C-D>
    " imap <PageUp> <C-O><C-U>
    " imap <PageDown> <C-O><C-D>

    " Quick alignment of text
    map <leader>al :left<CR>
    map <leader>ar :right<CR>
    map <leader>ac :center<CR>

    " Indent/unident block (,]) (,[)
    " TODO: find a better mapping for this :(
    nnoremap <leader>] >i{<CR>
    nnoremap <leader>[ <i{<CR>

    " Easy filetype switching
    nnoremap _md :set ft=markdown<CR>
    nnoremap _hd :set ft=htmldjango<CR>
    nnoremap _jt :set ft=htmljinja<CR>
    nnoremap _js :set ft=javascript<CR>
    nnoremap _pd :set ft=python.django<CR>
    nnoremap _d  :set ft=diff<CR>
endfunction
call Normal_Mappings()

function! Visual_Mappings()
    " duplicate line in visual mode
    vmap D y'>p

    " Make p in Visual mode replace the selected text with the "" register.
    " vmap p <Erc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

    " Replace current visually selected word
    " vmap <leader>r "sy:%s/<C-R>=substitute(@s,"\n",'\\n','g')<CR>/

    " Show number of occurrences of currently visually selected word
    "vmap <leader>s "sy:%s/<C-R>=substitute(@s,"\n",'\\n','g')<CR>//n<CR>

    " from https://raw.github.com/amix/vimrc/master/vimrcs/basic.vim
    " try here for other ideas https://github.com/nelstrom/vim-visual-star-search
    function! CmdLine(str)
        exe "menu Foo.Bar :" . a:str
        emenu Foo.Bar
        unmenu Foo
    endfunction

    function! VisualSelection(direction, extra_filter) range
        let l:saved_reg = @"
        execute "normal! vgvy"

        let l:pattern = escape(@", '\\/.*$^~[]')
        let l:pattern = substitute(l:pattern, "\n$", "", "")

        if a:direction == 'b'
            execute "normal ?" . l:pattern . "^M"
        elseif a:direction == 'gv'
            call CmdLine("Ags \"" . l:pattern . "\"<CR>" )
        elseif a:direction == 'replace'
            call CmdLine("%s" . '/'. l:pattern . '/' . l:pattern . '/')
        elseif a:direction == 'f'
            execute "normal /" . l:pattern . "^M"
        endif

        let @/ = l:pattern
        let @" = l:saved_reg
    endfunction

    " Visual mode pressing * or # searches for the current selection
    " Super useful! From an idea by Michael Naumann
    vnoremap <silent> * :call VisualSelection('f', '')<CR>
    vnoremap <silent> # :call VisualSelection('b', '')<CR>
    " When you press gv you vimgrep after the selected text
    vnoremap <silent> gv :call VisualSelection('gv', '')<CR>
    " When you press <leader>r you can search and replace the selected text
    vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>


    function! GetVisualSelection()
    let [l:l1, l:c1] = getpos("'<")[1:2]
    let [l:l2, l:c2] = getpos("'>")[1:2]
    let l:selection = getline(l:l1, l:l2)
    let l:selection[-1] = l:selection[-1][: l:c2 - 1]
    let l:selection[0] = l:selection[0][l:c1 - 1:]
    return join(l:selection, "\n")
    endfunction

    " search for visually selected areas
    " xnoremap * <ESC>/<C-r>=substitute(escape(GetVisualSelection(), '\/.*$^~[]'), "\n", '\\n', "g")<CR><CR>
    " xnoremap # <ESC>?<C-r>=substitute(escape(GetVisualSelection(), '\/.*$^~[]'), "\n", '\\n', "g")<CR><CR>

    " prepare search based on visually selected area
    xnoremap / <ESC>/<C-r>=substitute(escape(GetVisualSelection(), '\/.*$^~[]'), "\n", '\\n', "g")<CR>

    " prepare substitution based on visually selected area
    xnoremap & <ESC>:%s/<C-r>=substitute(escape(GetVisualSelection(), '\/.*$^~[]'), "\n", '\\n', "g")<CR>/

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
    " map <leader>tc :call ToggleTabCompletion()<CR>
    "
    " tab complete?
    " inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    " inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
    " \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
    " inoremap <expr> <C-Space> pumvisible() ? '<C-n>' :
    " \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
    " imap <C-@> <C-Space>

    " In normal mode...
    " nnoremap <Tab> <C-W>w
    " nnoremap <S-Tab> <C-W>W
endfunction
call Tab_Mapping()

function! Mini_Scripts()
    "toggle wrap and easy movement keys while in wrap mode
    "nnoremap <silent> <leader>w :set invwrap wrap?<CR>
    noremap <silent> <leader>tw :call ToggleWrap()<CR>
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

    function! Preserve(command)
        let l:search=@/
        let l:line = line(".")
        let l:col = col(".")
        execute a:command
        let @/=l:search
        call cursor(l:line, l:col)
    endfunction

    " <leader>rt retabs the file, preserve cursor position
    nnoremap <silent> <leader>rt :call Preserve(":retab")<CR>

    " <leader>s removes trailing spaces
    noremap <silent> <leader>s :call Preserve("%s/\\s\\+$//e")<CR>

    " <leader>$ fixes mixed EOLs (^M)
    noremap <silent> <leader>$ :call Preserve("%s/<C-V><CR>//e")<CR>


    " Strip trailing whitespace
    " function! <SID>StripTrailingWhitespaces()
    " " Preparation: save last search, and cursor position.
    " let _s=@/
    " let l = line(".")
    " let c = col(".")
    " " Do the business:
    " %s/\s\+$//e
    " " Clean up: restore previous search history, and cursor position
    " let @/=_s
    " call cursor(l, c)
    " endfunction
    " nmap <leader>w :call <SID>StripTrailingWhitespaces()<cr>

    " OSX only: Open a web-browser with the URL in the current line
    " Funny thing: 'gx' actually does this better, using netrw
    function! HandleURI()
        let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;)]*')
        echo s:uri
        if s:uri != ""
            exec "silent !open \"" . s:uri . "\""
            exec "redraw"
        else
            echo "No URI found in line."
        endif
    endfunction
    map <leader>o :call HandleURI()<CR>

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

    " Highlight Word
    " This mini-plugin provides a few mappings for highlighting words temporarily.
    "
    " Sometimes you're looking at a hairy piece of code and would like a certain
    " word or two to stand out temporarily.  You can search for it, but that only
    " gives you one color of highlighting.  Now you can use <leader>N where N is
    " a number from 1-6 to highlight the current word in a specific color.
    " stolen from SJL https://github.com/sjl/dotfiles/blob/master/vim/vimrc#L1814-1863
    function! HiInterestingWord(n)
        " Save our location.
        normal! mz

        " Yank the current word into the z register.
        normal! "zyiw

        " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
        let mid = 86750 + a:n

        " Clear existing matches, but don't worry if they don't exist.
        silent! call matchdelete(mid)

        " Construct a literal pattern that has to match at boundaries.
        let pat = '\V\<' . escape(@z, '\') . '\>'

        " Actually match the words.
        call matchadd("InterestingWord" . a:n, pat, 1, mid)

        " Move back to our original location.
        normal! `z
    endfunction
    " Mappings
    nnoremap <silent> <leader>h1 :call HiInterestingWord(1)<cr>
    nnoremap <silent> <leader>h2 :call HiInterestingWord(2)<cr>
    nnoremap <silent> <leader>h3 :call HiInterestingWord(3)<cr>
    nnoremap <silent> <leader>h4 :call HiInterestingWord(4)<cr>
    nnoremap <silent> <leader>h5 :call HiInterestingWord(5)<cr>
    nnoremap <silent> <leader>h6 :call HiInterestingWord(6)<cr>
    " Default Highlights
    hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
    hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
    hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
    hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
    hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
    hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

    " a function to execute formd and return the cursor back
    " to it's original position within the buffer.
    " http://drbunsen.github.io/formd/
    function! Formd(option)
        :let l:save_view = winsaveview()
        :let l:flag = a:option
        :if flag == "-r"
            :%! formd -r
        :elseif flag == "-i"
            :%! formd -i
        :else
            :%! formd -f
        :endif
        :call winrestview(save_view)
    endfunction

    " formd mappings
    " nmap <leader>fr :call Formd("-r")<CR>
    " nmap <leader>fi :call Formd("-i")<CR>
    " Format ...
    " nmap <leader>f :call Formd("-f")<CR>

    " location/quickfix list toggle script
    function! GetBufferList()
      redir =>buflist
      silent! ls
      redir END
      return buflist
    endfunction
    function! ToggleList(bufname, pfx)
      let l:buflist = GetBufferList()
      for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
        if bufwinnr(bufnum) != -1
          exec(a:pfx.'close')
          return
        endif
      endfor
      if a:pfx == 'l' && len(getloclist(0)) == 0
          echohl ErrorMsg
          echo "Location List is Empty."
          return
      endif
      let l:winnr = winnr()
      exec('bot '.a:pfx.'open')
      if winnr() != winnr
        wincmd p
      endif
    endfunction
    " nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
    nmap <silent> <leader>` :call ToggleList("Quickfix List", 'c')<CR>

    " Split the current line at all commas
    " Sometimes you have a list that has grown very past 80 or 100 chars on one
    " line. You could <leader>S to split the list onto single lines.
    function! SplitLine()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " Do the business:
        :s/,/,\r/
        " Clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    nnoremap <silent> <leader>S :call SplitLine()<CR>

    " vp doesn't replace paste buffer
    function! RestoreRegister()
        let @" = s:restore_reg
        return ''
    endfunction
    function! s:Repl()
        let s:restore_reg = @"
        return "p@=RestoreRegister()\<cr>"
    endfunction
    vmap <silent> <expr> p <sid>Repl()

    " use <leader>d to delete a line without adding it to the yanked stack
    nnoremap <silent> <leader>d "_d
    vnoremap <silent> <leader>d "_d

    " yank/paste to/from the OS clipboard
    noremap <silent> <leader>y "+y
    noremap <silent> <leader>Y "+Y
    noremap <silent> <leader>p "+p
    noremap <silent> <leader>P "+P

    " paste without yanking replaced text in visual mode
    vnoremap <silent> p "_dP
    vnoremap <silent> P "_dp

endfunction
call Mini_Scripts()

" ### Custom text inserts ###################################################
"insert THE time!
"TODO move this into some kind of autotext complete thing
nmap <leader>tt :execute "normal i" . strftime("%Y/%m/%d %H:%M:%S")<Esc>

iab _AUTHOR Matt Behrens <askedrelic@gmail.com>

" insert author
nmap <leader>ia :execute "normal aMatt Behrens <askedrelic@gmail.com>"<Esc>
" insert signature
nmap <leader>is :execute "normal aMJB " . strftime("%Y/%m/%d")<Esc>
" insert timestamp
nmap <leader>it :execute "normal a" . strftime("%Y/%m/%d %H:%M:%S")<Esc>
" insert date
nmap <leader>id :execute "normal a" . strftime("%Y/%m/%d")<Esc>

" ### Plugins ###################################################



"Tabularize align options
nmap <leader>a= :Tabularize /=<CR>
vmap <leader>a= :Tabularize /=<CR>
nmap <leader>a* :Tabularize /=.*<CR>
vmap <leader>a* :Tabularize /=.*<CR>
nmap <leader>a> :Tabularize /=><CR>
vmap <leader>a> :Tabularize /=><CR>
nmap <leader>a: :Tabularize /:\zs/l0l1<CR>
vmap <leader>a: :Tabularize /:\zs/l0l1<CR>
nmap <leader>a, :Tabularize /,\zs/l0l1<CR>
vmap <leader>a, :Tabularize /,\zs/l0l1<CR>
nmap <leader>a  :Tabularize /
vmap <leader>a  :Tabularize /


" Tagbar
let g:tagbar_left      = 1 " Open tagbar on the left
let g:tagbar_sort      = 0 " Sort tags by file order by default
let g:tagbar_compact   = 1 " Remove empty lines by default
" let g:tagbar_foldlevel = 0 " Close folds default
map <leader>b :TagbarOpenAutoClose<CR>
let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:Heading_L1',
        \ 'i:Heading_L2',
        \ 'k:Heading_L3'
    \ ]
\ }


" NERDTree
map <silent> <leader>n :NERDTreeMirrorToggle<CR>
map <silent> <leader>N :NERDTreeFind<CR>
let NERDTreeWinPos              = 'left'
let NERDTreeChDirMode           = 0
let NERDTreeIgnore              = ['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__', '\.DS_Store$']
let NERDTreeSortOrder           = ['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']
let NERDTreeHighlightCursorline = 1
let NERDTreeShowFiles           = 1 " Show hidden files, too
let NERDTreeShowHidden          = 1
let NERDTreeMinimalUI           = 1 " Hide 'up a dir' and help message
" don't show nerdtree by default
let g:nerdtree_tabs_focus_on_files          = 0
let g:nerdtree_tabs_meaningful_tab_names    = 1
let g:nerdtree_tabs_open_on_console_startup = 0
let g:nerdtree_tabs_open_on_gui_startup     = 0
let g:nerdtree_tabs_open_on_new_tab         = 0
let g:nerdtree_tabs_smart_startup_focus     = 1
let g:nerdtree_tabs_synchronize_view        = 1


" ctrlp.vim
" Remember to use <C-\> to insert current word or visual selection when
" searching...
" Go Jump to file
let g:ctrlp_map = 'gj'
" Go to Buffer
nmap gb :CtrlPBuffer<CR>
" Go to Recent
nmap gr :CtrlPMRU<CR>
" Go Undo
nmap gu :CtrlPUndo<CR>
" Go recent Changes
" Overwrite vim-commentary gc, gcc mappings
nnoremap gc :CtrlPChangeAll<CR>
" Order files top to bottom
let g:ctrlp_match_window = 'bottom,order:ttb'
" Always open results in a new buffer
let g:ctrlp_switch_buffer = 0
" Open multiple files in new tabs
let g:ctrlp_open_multiple_files = 't'

" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
" let g:ctrlp_user_command = 'ag %s -l --nocolor --smart-case -g ""'
" let g:ctrlp_user_command = 'ag %s --files-with-matches -g "" --smart-case --ignore "\.git$\|\.hg$\|\.svn$"'

" Newest form of ctrlp_user_command: if git exists, use git ls files. Otherwise
" use ag for file search
let g:ctrlp_user_command = [
 \ '.git',
 \ 'cd %s && git ls-files . -co --exclude-standard',
 \ 'ag %s -l --ignore-case --nocolor --nogroup --ignore .git --ignore .tox --ignore .svn --ignore .hg --ignore .DS_Store -g ""']
" ag is fast enough that CtrlP doesn't need to cache
let g:ctrlp_use_caching = 0
" Only show relative CWD MRU files
let g:ctrlp_mruf_relative = 0

let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_lazy_update = 200


" Netrw
let g:netrw_hide              = 1
let g:netrw_list_hide         = '^\.svn.*'
let g:netrw_menu              = 0
let g:netrw_silent            = 1
let g:netrw_special_syntax    = 1

" MBE
let g:miniBufExplSplitBelow   = 0

" Commentary
" comment single line
nmap <C-c> <Plug>CommentaryLine
" xmap to comment multi line visual selection
xmap <C-c> <Plug>Commentary
autocmd vimrc FileType htmldjango setlocal commentstring={#\ %s\ #}
autocmd vimrc FileType python.django setlocal commentstring=#\ \%s
autocmd vimrc FileType python setlocal commentstring=#\ %s
autocmd vimrc FileType go setlocal commentstring=//\ %s

" LustyJuggler
let g:LustyJugglerSuppressRubyWarning = 1

" Fugutive
" ignore whitespace by default
map <silent> <leader>gb :Gblame -w<CR>
map <silent> <leader>gc :Gcommit -v<CR>
map <silent> <leader>gp :!git push<CR>
map <silent> <leader>ge :Gedit<CR>
map <silent> <leader>gl :Glog<CR>
map <silent> <leader>gr :Gread<CR>
map <silent> <leader>gs :Gstatus<CR>
map <silent> <leader>gd :Gdiff<CR>
map <silent> <leader>gx :!gitx<CR>
map <silent> <leader>ga :Git add --patch -- %<CR>

" SuperTab
let g:SuperTabLongestEnhanced = 1

" PyFlakes
let g:pyflakes_use_quickfix = 0

" rainbow parens
" from https://github.com/junegunn/rainbow_parentheses.vim
" better fork from https://github.com/kien/rainbow_parentheses.vim
nnoremap <leader>tr :RainbowParentheses!!<CR>

" syntastic
let g:syntastic_mode_map = { 'mode': 'passive',
                              \ 'active_filetypes': [],
                              \ 'passive_filetypes': [] }

" The Silver Searcher / ag.vim / ack.vim
" Use ag over grep
let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
set grepprg=ag\ --nogroup\ --nocolor\ --smart-case
let g:ag_apply_qmappings = 1
let g:ag_apply_lmappings = 1
" bind \ (backward slash) to grep shortcut
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap <C-g> :Ags -S<space>

" gitgutter
nmap gh <Plug>GitGutterNextHunk
nmap gH <Plug>GitGutterPrevHunk
" let g:gitgutter_realtime = 0

" linediff
" vnoremap <leader>l :Linediff<cr>
" nnoremap <leader>L :LinediffReset<cr>

" vim-autoformat
" Need to override this to work on OSX
let g:formatprg_args_expr_python = '"- ".(&textwidth ? "--max-line-length=".&textwidth : "")'

if !exists("g:formatprg_scss") | let g:formatprg_scss = "sass-convert" | endif
let g:formatprg_args_scss = "-s --indent 4 -F scss -T scss"
" if !exists("g:formatprg_args_expr_scss")  && !exists("g:formatprg_args_scss")
"     let g:formatprg_args_expr_css = '"--indent 4 "'
" endif

" Easymotion.vim
" let g:EasyMotion_leader_key = ','
" let g:EasyMotion_mapping_f = '<C-n>'

" ========== Airline.vim
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#branch#displayed_head_limit = 10


" disable git gutter hunks
" let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#enabled = 0

" let g:bufferline_echo = 0
let g:airline_powerline_fonts = 0
" truncate file info first once window size shrinks
let g:airline#extensions#default#section_truncate_width = {
      \ 'b': 20,
      \ 'c': 40,
      \ 'x': 150,
      \ 'y': 150,
      \ 'z': 40,
\ }
let g:airline_theme='powerlineish'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_inactive_collapse=1

" Unite.vim
" let g:unite_enable_start_insert = 1
" call unite#filters#matcher_default#use(['matcher_fuzzy'])
" nnoremap <leader>u :Unite<Space>
" nnoremap <leader>U :Unite -start-insert<Space>
" let g:unite_winheight = 10
" let g:unite_split_rule = 'botright'
" " let g:unite_enable_start_insert = 1
" " let g:unite_enable_short_source_names = 1
" " let g:unite_source_rec_max_cache_files = 5000

" autocmd FileType unite call s:unite_settings()
" function! s:unite_settings()
"   " Play nice with supertab
"   let b:SuperTabDisabled=1
"   " Enable navigation with control-j and control-k in insert mode
"   imap <buffer> <C-j>   <Plug>(unite_select_next_line)
"   imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
" endfunction

" Splitjoin.vim
" nmap sj :SplitjoinSplit<cr>
" nmap sk :SplitjoinJoin<cr>

" ExpandVisualSelection.vim
vmap v <Plug>(expand_region_expand)

let g:ultisnips_python_style = "google"
let g:snipMateAllowMatchingDot = 0

vmap <Enter> <Plug>(LiveEasyAlign)

" let python_highlight_all = 1
let g:gutentags_exclude = ['env', '.tox']

" CTRL+A moves to start of line in command mode
cnoremap <C-a> <home>
" CTRL+E moves to end of line in command mode
cnoremap <C-e> <end>

nnoremap <Space> za
vnoremap <Space> za

" --user defined ---------------------------------------------------------------
"
 if filereadable(expand("~/.vimrc.local"))
   source ~/.vimrc.local
endif

" remap U to <C-r> for easier redo
nnoremap U <C-r>

" exit from insert mode without cursor movement
inoremap jk <ESC>`^

" Always set titlestring to CWD. Most useful identifier to me.
set titlestring=%{substitute(getcwd(),\ $HOME,\ '~',\ '')}

" Yank current file and line number, to system yank buffer
function! CopyLine()
    let @+=expand("%") . ':' . line(".")
    echo 'Copied "'@*'" to clipboard'
endfunction

" Yank in vim style
function! CopyLineVim()
    let @+='+' . line(".") . ' ' .expand("%")
    echo 'Copied "'@*'" to clipboard'
endfunction

" http://www.vimbits.com/bits/337

" Yank Path
nnoremap <Leader>yp :let @*=expand("%")<cr>:echo 'Copied '@*' to clipboard'<cr>
" Yank Filepath to clipboard
nnoremap <Leader>yf :let @*=expand("%:t")<cr>:echo 'Copied '@*' to clipboard'<cr>
" Yank Vim style filepath
nnoremap <Leader>yv :call CopyLineVim()<cr>
" Yank normal style file with Line number
nnoremap <Leader>yl :call CopyLine()<cr>
" Copy current buffer path without filename to system clipboard
nnoremap <Leader>yd :let @*=expand("%:h")<cr>:echo 'Copied '@*' to clipboard'<cr>

" Clear lines
noremap <Leader>clr :s/^.*$//<CR>:nohls<CR>

" Make rainbow_parens work with {}
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

" Better ctrlp searching
" nmap <leader>f :CtrlP<CR><C-\>w
vmap gj y:CtrlP<CR><C-\>v
" vmap <leader>f y:CtrlP<CR><C-\>c
"

" Remap vim-ags open tab
" https://github.com/gabesoft/vim-ags/issues/23
autocmd vimrc FileType agsv nnoremap <buffer> ot
  \ :exec 'tab split ' . ags#filePath(line('.'))<CR>

let g:startify_custom_indices = ['a', 's', 'd', 'f']

" Press \r to start rotating lines and <C-c> (Control+c) to stop.

function! s:RotateString(string)
    let split_string = split(a:string, '\zs')
    return join(split_string[-1:] + split_string[:-2], '')
endfunction

function! s:RotateLine(line, leading_whitespace, trailing_whitespace)
    return substitute(
        \ a:line,
        \ '^\(' . a:leading_whitespace . '\)\(.\{-}\)\(' . a:trailing_whitespace . '\)$',
        \ '\=submatch(1) . <SID>RotateString(submatch(2)) . submatch(3)',
        \ ''
    \ )
endfunction

function! s:RotateLines()
    let saved_view = winsaveview()
    let first_visible_line = line('w0')
    let last_visible_line = line('w$')
    let lines = getline(first_visible_line, last_visible_line)
    let leading_whitespace = map(
        \ range(len(lines)),
        \ 'matchstr(lines[v:val], ''^\s*'')'
    \ )
    let trailing_whitespace = map(
        \ range(len(lines)),
        \ 'matchstr(lines[v:val], ''\s*$'')'
    \ )
    try
        while 1 " <C-c> to exit
            let lines = map(
                \ range(len(lines)),
                \ '<SID>RotateLine(lines[v:val], leading_whitespace[v:val], trailing_whitespace[v:val])'
            \ )
            call setline(first_visible_line, lines)
            redraw
            sleep 50m
        endwhile
    finally
        if &modified
            silent undo
        endif
        call winrestview(saved_view)
    endtry
endfunction

nnoremap <silent> <Plug>(RotateLines) :<C-u>call <SID>RotateLines()<CR>

nmap \r <Plug>(RotateLines)

" Source: http://stackoverflow.com/a/6404246/151007
let i = 1
" If I have more than 9 windows open I have bigger problems :)
while i <= 9
  execute 'nnoremap <Leader>'.i.' :tabn '.i.'<CR>'
  let i = i + 1
endwhile
