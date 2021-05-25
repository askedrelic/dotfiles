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
"

Plug 'junegunn/gv.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'Lokaltog/vim-easymotion'

" https://github.com/airblade/vim-gitgutter
" A Vim plugin which shows a git diff in the gutter (sign column) and
" stages/undoes hunks.
Plug 'airblade/vim-gitgutter'
nmap gh <Plug>(GitGutterNextHunk)
nmap gH <Plug>(GitGutterPrevHunk)
" let g:gitgutter_realtime = 0
let g:gitgutter_max_signs = 1000
set updatetime=100

Plug 'ap/vim-css-color'


" Alignment
" https://github.com/tommcdo/vim-lion
Plug 'tommcdo/vim-lion'
let g:lion_squeeze_spaces = 1

" tpope vinegar, but with nerdtree
Plug 'askedrelic/vim-vinegar'
" Trying filebeagle? faster and simpler than vinegar/nerdtree
" But less file mgmt features :(
" Plug 'jeetsukumaran/vim-filebeagle'

" Airline status bar and themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" A better JSON for Vim
Plug 'elzr/vim-json'

" Better yaml syntax highlighting
Plug 'martin-svk/vim-yaml'

" Normal Mode
" - gagiw to search the word
" - gagi' to search the words inside single quotes.
" Visual Mode
" - gag to search the selected text
" Plug 'Chun-Yang/vim-action-ag'

Plug 'ervandew/supertab' ", {'commit': 'feb2a5f8'}
" Plug 'rking/ag.vim'

" I like this; it doesn't work with completor.vim
"Plug 'garbas/vim-snipmate' ", {'commit': '2d3e8ddc'}
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'godlygeek/tabular'
Plug 'gregsexton/MatchTag'
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/rainbow_parentheses.vim'
" Plug 'junegunn/vim-easy-align'
Plug 'msanders/cocoa.vim'

Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1

Plug 'rhysd/clever-f.vim'

Plug 'scrooloose/nerdcommenter'
"" NERDCommenter
"" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
"" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
"" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

let g:NERDCreateDefaultMappings = 0
nmap gc <plug>NERDCommenterToggle
vmap gc <plug>NERDCommenterToggle

" Run ctags in the bg on save
Plug 'ludovicchabant/vim-gutentags'

" 2017/02/01 now using ale for linting
" Plug 'scrooloose/syntastic'
" Plug 'w0rp/ale'

Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'

Plug 'AndrewRadev/tagfinder.vim'
"
""""""""""""" File search plugins

" Install FZF from homebrew
" Plug '/usr/local/opt/fzf'
" Plug 'junegunn/fzf.vim'

" Ack search
" 2018 - replace by vim-grepper
" Plug 'wincent/ferret'

" Ags search
" 2018 - replaced by vim-grepper
" Plug 'gabesoft/vim-ags'

" Interface for using all search tools
" Binds gv, breaks my tab, stab indent binding
" https://github.com/mhinz/vim-grepper
Plug 'mhinz/vim-grepper'
let g:grepper = {}
let g:grepper.tools = ['rg', 'ag']
" Disable the 'choose your tool' prompt
let g:grepper.prompt = 0
runtime autoload/grepper.vim
" Jump to first result
let g:grepper.jump = 1
" Limit to 500 results
let g:grepper.stop = 500
noremap <C-g> :Grepper -tool rg -query<Space>""<Left>
nmap gv <plug>(GrepperOperator)
xmap gv <plug>(GrepperOperator)

" File/buffer/MRU search
Plug 'ctrlpvim/ctrlp.vim'
" Faster ctrlp searches
Plug 'FelikZ/ctrlp-py-matcher'

" Search the current file by tags
Plug 'majutsushi/tagbar'
let g:tagbar_type_make = {
    \ 'kinds':[
    \ 'm:macros',
    \ 't:targets'
    \ ]
    \}

" Indenting
" https://github.com/jeetsukumaran/vim-indentwise
Plug 'jeetsukumaran/vim-indentwise'

" Keep hitting v to expand region
Plug 'terryma/vim-expand-region'

""""""""""""""" Almost all the tpope
" I prefer nerdcommenter
" Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired', {'commit': 'bacf154'}
Plug 'tpope/vim-dispatch'

" https://github.com/yssl/QFEnter
" make Enter work in the QF window
Plug 'yssl/QFEnter'

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

" Library for yelp test files
Plug 'askedrelic/pair_files.vim'
Plug 'moll/vim-bbye'

" Lanugages
Plug 'sheerun/vim-polyglot'

" Python ---------
Plug 'vim-scripts/python_match.vim'

" Javascript --------
Plug 'pangloss/vim-javascript'

Plug 'vim-scripts/matchit.zip'
Plug 'vim-scripts/visualrepeat'

" indent lines
Plug 'nathanaelkane/vim-indent-guides'
" Plug 'Yggdroot/indentLine'
" let g:indentLine_faster = 1
" let g:indentLine_setConceal = 0

" Testing -------------
" use this?? diff navigator
Plug 'https://gitlab.com/mcepl/vim-diff_navigator.git'

" Too much setup...
" Plug 'hecal3/vim-leader-guide'

" https://github.com/vim-ctrlspace/vim-ctrlspace
" ctrlp style search plugin
" Plug 'vim-ctrlspace/vim-ctrlspace'

Plug 'benmills/vimux'

" https://github.com/janko-m/vim-test
" Should fix all my testing issues?
Plug 'janko-m/vim-test', { 'on': ['TestFile', 'TestNearest', 'TestLast'] }
" First letter of runner's name must be uppercase
let test#runners = {'yelp': ['Testify']}

function! EchoStrategy(cmd)
    echo 'It works! Command for running tests: ' . a:cmd
endfunction

let g:test#custom_strategies = {'echo': function('EchoStrategy')}
let g:test#strategy = 'echo'

nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
" nmap <silent> <leader>l :TestLast<CR>
" nmap <silent> <leader>g :TestVisit<CR>
"
" Other ideas
" noremap <silent> <leader>tt :TestNearest<CR>
" noremap <silent> <leader>tf :TestFile<CR>
" noremap <silent> <leader>ts :TestSuite<CR>
" noremap <silent> <leader>tl :TestLast<CR>
" if has("nvim")
"     let test#strategy = "neovim"
" else
"     let test#strategy = "vimterminal"
" endif

" https://github.com/bogado/file-line
" Let vim open file:lineno style
Plug 'bogado/file-line'

" maggggit
" https://github.com/jreybert/vimagit
" Plug 'jreybert/vimagit'

" Plug 'davidhalter/jedi-vim'

Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }

" Plug 'heavenshell/vim-pydocstring'

" provides additional text objects
" https://github.com/wellle/targets.vim
" ( ) b (work on parentheses)
" { } B (work on curly braces)
" [ ] (work on square brackets)
" < > (work on angle brackets)
" t (work on tags)
" cin) next )
" dtl) previous )
Plug 'wellle/targets.vim'


" colorscheme
" Plug 'morhetz/gruvbox'

Plug 'maralla/completor.vim'

Plug 'thiagoalessio/rainbow_levels.vim'
" map <leader>l :RainbowLevelsToggle<cr>
let g:rainbow_levels = [
    \{'ctermbg': 'none'},
    \{'ctermbg': 'none'},
    \{'ctermbg': 'none'},
    \{'ctermbg': 'none'},
    \
    \{'ctermbg': 3,   'guibg': '#ffc66d'},
    \{'ctermbg': 9,   'guibg': '#cc7833'},
    \{'ctermbg': 1,   'guibg': '#da4939'},
    \{'ctermbg': 160, 'guibg': '#870000'}]

" https://github.com/christoomey/vim-tmux-runner
" Send commands to tmux
" VtrSendCommandToRunner
Plug 'christoomey/vim-tmux-runner'

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
    "if exists('$TMUX') && !has("gui_running")
    "    set term=screen-256color
    "endif

    " save last 50 search history items, last 50 edit marks,
    " don't remember last search highlight
    set viminfo=/50,'30,h

    set backup      " enable backup files
    "set writebackup " enable backup files
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

    " skip backup for tmp files
    set backupskip=/tmp/*,/private/tmp/*,*.tmp

    " 2017/11/16 17:25:47
    " Disable to let nvim work?
    "let &viminfo=&viminfo . ",n" . s:vimdir . "/.viminfo" " viminfo location

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
    " highlight matching [{()}]
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
    if !has('nvim')
        set esckeys
    endif
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
    " set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
    set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,nbsp:+
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

    " Disable included files in tab complete, for now
    set complete-=i

    " redraw only when we need to.
    set lazyredraw

    " Time out on key codes but not mappings.
    " Basically this makes terminal Vim work sanely.
    set timeout
    set ttimeoutlen=50

    " set ttimeout
    " set ttimeoutlen=100

    set sessionoptions-=options

    " make matchparen timeout quickly; don't take forever on long lines
    let g:matchparen_insert_timeout=5

    " let mapleader = ','
    " Use space for leader
    let g:mapleader = ' '
    " shrug, local leader still doesn't make much sense to me
    " let g:maplocalleader = '\'

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

    colorscheme badwolf

    " colorscheme gruvbox
    " let g:gruvbox_contrast_dark="soft"

    if has("gui_running")
        " set guifont=Monaco:h12
        set guifont=Hack:h12
        " set guifont=Inconsolata:h14

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
    set formatoptions+=j " Delete comment character when joining commented lines
endfunction
call Line_Wrapping()

function! File_Types()
    " Omni Completion
    " mine set completeopt=menu,menuone,longest
    set completeopt+=menuone
    set completeopt-=menu
    if &completeopt !~# 'noinsert\|noselect'
        set completeopt+=noselect
    endif

    " complete using built in syntax? http://vim.wikia.com/wiki/Completion_using_a_syntax_file
    " autocmd FileType * exec('setlocal dict+='.$VIMRUNTIME.'/syntax/'.expand('<amatch>').'.vim')

    " CSS and LessCSS
    augroup ft_css
        autocmd!

        autocmd bufnewfile,bufread *.less setlocal filetype=less

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

        " autocmd BufNewFile,BufRead *.html setlocal filetype=htmldjango
        " call Tabstyle_2spaces()

        " NOTE: 2019-03-18, this seems broken?
        "hitting % on <ul> jumps to <li> instead of </ul>
        " autocmd FileType html let b:match_words='<:>,<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'

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

    " Cheetah overrides
    augroup ft_cheetah
        autocmd!

        autocmd BufNewFile,BufRead *.tmpl setlocal filetype=cheetah
    augroup END

    " Javascript
    augroup ft_javascript
        autocmd!

        " easy comment insert
        autocmd FileType javascript inoremap <buffer> <c-c> console.log();<left><left>
        " autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
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
        nnoremap <localleader>fr :call Formd("-r")<CR>
        nnoremap <localleader>fi :call Formd("-i")<CR>
        " Format ...
        nnoremap <localleader>f :call Formd("-f")<CR>
    augroup END

    augroup ft_nginx
        autocmd!

        autocmd BufRead,BufNewFile /etc/nginx/conf/*                      set ft=nginx
        autocmd BufRead,BufNewFile /etc/nginx/sites-available/*           set ft=nginx
        autocmd BufRead,BufNewFile /usr/local/etc/nginx/sites-available/* set ft=nginx
        autocmd BufRead,BufNewFile vhost.nginx                            set ft=nginx

    augroup END

    " Puppet
    augroup ft_puppet
        autocmd!
        autocmd BufNewFile,BufRead *.pp setlocal filetype=puppet
    augroup END

    " Python
    augroup ft_python
        autocmd!
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        "autocmd FileType python compiler nose
        " autocmd FileType man nnoremap <buffer> <cr> :q<cr>

        " format comments correctly
        autocmd FileType python setlocal textwidth=80
        " autocmd FileType python setlocal formatoptions=croqn

        " @NOTE disable smartindent, it forces inserting tabs. Use cindent instead
        autocmd FileType python setlocal cindent cinwords=if,elif,else,for,while,with,try,except,finally,def,class
        autocmd FileType python setlocal cinkeys-=0#
        autocmd FileType python setlocal indentkeys-=0#

        " Python mode settings
        let g:pymode = 0
        let g:pymode_syntax_all= 1
        let g:pymode_indent = 1
        let g:pymode_motion = 1

        let g:pymode_rope_goto_definition_bind = ""
        let g:pymode_run_bind = ""
        let g:pymode_doc_bind = ""
        let g:pymode_options_colorcolumn = 0
        let g:pymode_folding = 0

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
    nnoremap  <F1> <nop>
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
    nnoremap <C-H> <C-W>h
    nnoremap <C-J> <C-W>j
    nnoremap <C-K> <C-W>k
    nnoremap <C-L> <C-W>l
    nnoremap <leader>v <C-W>v

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

    " fix ctrl-k to delete to end of line in ex mode; bash style
    cnoremap <C-k> <C-\>estrpart(getcmdline(),0,getcmdpos()-1)<CR>

    " insert new line without going into insert mode
    " Except this breaks ctrl-f...
    " nnoremap <Enter> o<ESC>
    nnoremap <S-Enter> :put!=''<CR>

    " Force gm to go the middle of the ACTUAL line, not the screen line
    nnoremap <silent> gm :exe 'normal '.(virtcol('$')/2).'\|'<CR>

    " have Q reformat the current paragraph (or selected text if there is any):
    nnoremap Q gqip
    vnoremap Q gq

    " visual select last pasted text
    nnoremap gV `[v`]

    " have Y behave analogously to D and C rather than to dd and cc (which is
    " already done by yy):
    nnoremap Y yt$
    vnoremap Y yt$

    "Remember :ol to browse old files
    nnoremap go :ol<CR>

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
    " " Use <leader>l to clear the highlighting of :set hlsearch.
    " nnoremap <silent> <leader>l :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><leader>l
    nnoremap <silent> <leader>l :nohlsearch<CR>:call clearmatches()<CR>
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
    " 2015/02/06 dont think I need this anymore
    " nnoremap <leader>s :%s//<left>

    " [M]ake this file, after saving.
    nnoremap <leader>m :w<CR>:make<CR>

    " vim-autoformat should be easy to use
    nnoremap <leader>= :Autoformat<CR>

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

    " reset font size. combines with Apple+`-`/`=` keys
    nnoremap <D-0> :set guifont=Hack:h12<CR>
endfunction
call Normal_Mappings()

function! Visual_Mappings()
    " duplicate line in visual mode
    vmap D y'>p

    " Make p in Visual mode replace the selected text with the "" register.
    " vmap p <Erc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

    " Replace current visually selected word
    vnoremap <leader>r "sy:%s/<C-R>=substitute(@s,"\n",'\\n','g')<CR>/<C-R>=substitute(@s,"\n",'\\n','g')<CR>/<Left>

    " Show number of occurrences of currently visually selected word
    vmap <leader>s "sy:%s/<C-R>=substitute(@s,"\n",'\\n','g')<CR>//n<CR>

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
    " vnoremap <silent> gv :call VisualSelection('gv', '')<CR>
    " vnoremap <silent> gj :call VisualSelection('gj', '')<CR>
    "
    " See also https://github.com/nelstrom/vim-visual-star-search

    " When you press <leader>r you can search and replace the selected text
    " vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>


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
    vnoremap > >gv
    vnoremap < <gv

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
    nnoremap <silent> <leader>tw :call ToggleWrap()<CR>
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

    " <leader>w removes trailing whitespaces
    nnoremap <silent> <leader>w :call Preserve("%s/\\s\\+$//e")<CR>

    " <leader>$ fixes mixed EOLs (^M)
    nnoremap <silent> <leader>$ :call Preserve("%s/<C-V><CR>//e")<CR>


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

    " OSX only: Open a web-browser with the URL in the current line.
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
    " nnoremap <leader>ti :call IndentGuides()<cr>
    nnoremap <leader>ti :IndentLinesToggle<cr>

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
    nnoremap <silent> <leader>` :call ToggleList("Quickfix List", 'c')<CR>

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
    nnoremap <silent> <leader>yy "+y
    " nnoremap <silent> <leader>Y "+Y
    " nnoremap <silent> <leader>p "+p
    " nnoremap <silent> <leader>P "+P

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
let NERDTreeChDirMode           = 1
let NERDTreeIgnore              = ['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__', '\.DS_Store$']
let NERDTreeSortOrder           = ['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']
let NERDTreeHighlightCursorline = 1
let NERDTreeShowFiles           = 1 " Show hidden files, too
let NERDTreeShowHidden          = 1
let NERDTreeMinimalUI           = 1 " Hide 'up a dir' and help message
let NERDTreeShowLineNumbers     = 1 " Linenumbers are great for gg
let NERDTreeCreatePrefix        = 'silent keepalt keepjumps'
let g:nerdtree_tabs_focus_on_files          = 0
let g:nerdtree_tabs_meaningful_tab_names    = 1
let g:nerdtree_tabs_open_on_console_startup = 0
let g:nerdtree_tabs_open_on_gui_startup     = 0
let g:nerdtree_tabs_open_on_new_tab         = 0
let g:nerdtree_tabs_smart_startup_focus     = 1
let g:nerdtree_tabs_synchronize_view        = 0


" ctrlp.vim
" Remember to use <C-\> to insert current word or visual selection when
" searching...
" Go Jump to file
let g:ctrlp_map = 'gj'
" Go to Buffer
nnoremap gb :CtrlPBuffer<CR>
" Go to Recent
nnoremap gr :CtrlPMRU<CR>
" Go Undo
" nmap gu :CtrlPUndo<CR>
" Go recent Changes
" nnoremap gc :CtrlPChangeAll<CR>
" Order files bottom to top
let g:ctrlp_match_window = 'bottom,order:btt,max:20,max:0'
" Always open results in a new buffer
let g:ctrlp_switch_buffer = 0
" Open multiple files in new tabs
let g:ctrlp_open_multiple_files = 't'
" Don't let ctrlp change cwd ?
let g:ctrlp_working_path = 0
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

" Use PyMatch for much faster matching
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
" Use (fd, rg, ag) if avaliable. Default to find if not.
if executable('fd')
    let g:ctrlp_user_command = 'fd --type f --color=never "" %s'
    let g:ctrlp_use_caching = 0
    let g:ctrlp_match_window_reversed = 0
elseif executable('rg')
    let g:ctrlp_user_command = 'rg %s --smart-case --files --color=never --glob ""'
    let g:ctrlp_use_caching = 0
elseif executable('ag')
    let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
                \ --ignore .git
                \ --ignore .svn
                \ --ignore .hg
                \ --ignore .DS_Store
                \ --ignore "**/*.pyc"
                \ -g ""'
    let g:ctrlp_use_caching = 0
else
    let g:ctrlp_user_command = 'find %s -type f'
    let g:ctrlp_use_caching = 1
endif

" Only show relative CWD MRU files
let g:ctrlp_mruf_relative = 1

let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_max_files = 1000000


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
" nnoremap <Leader>c <Plug>CommentaryLine
" xmap to comment multi line visual selection
" xnoremap <Leader>c  <Plug>Commentary
" xnoremap <C-c>  <Plug>Commentary
" autocmd vimrc FileType htmldjango setlocal commentstring={#\ %s\ #}
" autocmd vimrc FileType python.django setlocal commentstring=#\ \%s
" autocmd vimrc FileType python setlocal commentstring=#\ %s
" autocmd vimrc FileType go setlocal commentstring=//\ %s

" Fugutive
" ignore whitespace by default
map <silent> <leader>gb :Git blame -w<CR>
map <silent> <leader>gc :Git commit -v<CR>
map <silent> <leader>gp :!git push<CR>
map <silent> <leader>ge :Gedit<CR>
map <silent> <leader>gl :Gclog<CR>
map <silent> <leader>gr :Gread<CR>
map <silent> <leader>gs :Git<CR>
map <silent> <leader>gd :Gdiff<CR>
map <silent> <leader>gx :!gitx<CR>
map <silent> <leader>ga :Git add --patch -- %<CR>

" SuperTab
let g:SuperTabLongestEnhanced = 1
" let g:SuperTabDefaultCompletionType = "context"
" let g:SuperTabContextDefaultCompletionType = "<c-n>"

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
" nnoremap <C-g> :Ags -S ""<Left>

" gitgutter

" linediff
" vnoremap <leader>l :Linediff<cr>
" nnoremap <leader>L :LinediffReset<cr>

" vim-autoformat
" https://github.com/Chiel92/vim-autoformat
" For verbose mode:
" let g:autoformat_verbosemode=1
"
" https://github.com/google/yapf
" My settings:
" BLANK_LINE_BEFORE_NESTED_CLASS_OR_DEF - True
" dedent_closing_brackets - True (I like C style)
" split_arguments_when_comma_terminated - True
" coalesce_brackets - True
let g:formatter_yapf_style = 'facebook'
let g:formatdef_yapf = "'yapf -l '.a:firstline.'-'.a:lastline"

let g:formatdef_autopep8 = "'autopep8 --aggressive --max-line-length 80 - --range '.a:firstline.' '.a:lastline"
let g:formatters_python = ['yapf']

if !exists("g:formatprg_scss") | let g:formatprg_scss = "sass-convert" | endif
let g:formatprg_args_scss = "-s --indent 4 -F scss -T scss"
" if !exists("g:formatprg_args_expr_scss")  && !exists("g:formatprg_args_scss")
"     let g:formatprg_args_expr_css = '"--indent 4 "'
" endif

" Easymotion.vim
let g:EasyMotion_leader_key = ','
" let g:EasyMotion_mapping_f = '<C-n>'

" ========== Airline.vim
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#tab_nr_type = 1
" let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#branch#displayed_head_limit = 10

" disable git gutter hunks
" let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#enabled = 0

" let g:bufferline_echo = 0
let g:airline_powerline_fonts = 0
" truncate file info first once window size shrinks
let g:airline#extensions#default#section_truncate_width = {
            \ 'a': 80,
            \ 'b': 80,
            \ 'x': 120,
            \ 'y': 100,
            \ 'z': 80,
            \ }
let g:airline_theme='wombat'
let g:airline_inactive_collapse=1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'PASTE'
let g:airline_symbols.spell = 'SPELL'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'WS'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

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

" ExpandVisualSelection.vim
vmap v <Plug>(expand_region_expand)

let g:ultisnips_python_style = "google"
let g:snipMateAllowMatchingDot = 0

" This breaks ctrl-f
" vmap <Enter> <Plug>(LiveEasyAlign)

let g:gutentags_ctags_exclude = ['env', '.tox', 'virtualenv*', 'venv', 'node_modules', 'vim-polyglot']
let g:gutentags_file_list_command = {
            \ 'markers': {
            \ '.git': 'git ls-files',
            \ '.hg': 'hg locate',
            \ },
            \ }


" CTRL+A moves to start of line in command mode
cnoremap <C-a> <home>
" CTRL+E moves to end of line in command mode
cnoremap <C-e> <end>

" nnoremap <Space> za
" vnoremap <Space> za

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

" Yank current relative file path and line number, to system yank buffer
function! CopyLine()
    let @+=fnamemodify(expand("%"), ":~:.") . ':' . line(".")
    echo 'Copied "'@*'" to clipboard'
endfunction

" Yank in vim style
function! CopyLineVim()
    let @+='+' . line(".") . ' ' .expand("%")
    echo 'Copied "'@*'" to clipboard'
endfunction

" http://www.vimbits.com/bits/337

" Yank relative Path
nnoremap <Leader>yp :let @*=fnamemodify(expand("%"), ":~:.")<cr>:echo 'Copied '@*' to clipboard'<cr>
" Yank Filepath to clipboard
nnoremap <Leader>yf :let @*=expand("%:t")<cr>:echo 'Copied '@*' to clipboard'<cr>
" Yank Vim style filepath
nnoremap <Leader>yv :call CopyLineVim()<cr>
" Yank normal style file with Line number
nnoremap <Leader>yl :call CopyLine()<cr>
" Copy current buffer path without filename to system clipboard
nnoremap <Leader>yd :let @*=expand("%:h")<cr>:echo 'Copied '@*' to clipboard'<cr>

" Clear lines
"noremap <Leader>clr :s/^.*$//<CR>:nohls<CR>

" Make rainbow_parens work with {}
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

" Better ctrlp searching
" nmap <leader>f :CtrlP<CR><C-\>w
" Doesn't work?
" vnoremap gj y:CtrlP<CR><C-\>v
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

" nnoremap <silent> <Plug>(RotateLines) :<C-u>call <SID>RotateLines()<CR>
" nmap \r <Plug>(RotateLines)

" Source: http://stackoverflow.com/a/6404246/151007
let i = 1
" If I have more than 9 windows open I have bigger problems :)
while i <= 9
    execute 'nnoremap <Leader>'.i.' :tabn '.i.'<CR>'
    let i = i + 1
endwhile

" Bind q to quit in fugitive git diff buffers
" https://github.com/tpope/vim-fugitive/blob/master/plugin/fugitive.vim#L2729
autocmd Filetype git nnoremap <buffer> <silent> q :<C-U>quit<CR>

" nnoremap <leader>x <Plug>(FerretAck)

" <leader>c -- Fix (most) syntax highlighting problems in current buffer
" (mnemonic: coloring).
"nnoremap <silent> <leader>c :syntax sync fromstart<CR>

" <leader><leader> -- Open last buffer.
nnoremap <leader><leader> <C-^>

" 2017/06/22 - I really dont like relativenumbers :/
" if exists('+relativenumber')
"   " <leader>r -- Cycle through relativenumber + number, number (only), and no
"   " numbering (mnemonic: relative).
"   nnoremap <leader>r :<c-r>={
"         \ '00': 'set rnu   <bar> set nu',
"         \ '01': 'set nornu <bar> set nu',
"         \ '10': 'set nornu <bar> set nonu',
"         \ '11': 'set nornu <bar> set nu' }[&nu . &rnu]<CR><CR><CR>
" else
"   " <leader>r -- Toggle line numbers on and off (mnemonic: relative).
"   nnoremap <leader>r :set nu!<CR>
" endif

" For each time K has produced timely, useful results, I have pressed it 10,000
" times without meaning to, triggering an annoying delay.
nnoremap K <nop>

" Ditto for q
" nnoremap q <nop>

let g:clever_f_across_no_line = 0
let g:clever_f_timeout_ms = 3000

" NOTE: disabling while testing ctrl-space...
let g:airline_exclude_preview = 1
" if executable("ag")
"     let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
" endif
" let g:CtrlSpaceUseUnicode = 0
" let g:CtrlSpaceSearchTiming = 500
" Settings for MacVim and Inconsolata font
" let g:CtrlSpaceSymbols = { "File": "◯", "CTab": "▣", "Tabs": "▢" }



let g:VimuxHeight = "49"
let g:VimuxOrientation = "h"


" jedi vim
" disable a bunch of built-in things by default
let g:jedi#completions_command = "<C-Space>"
let g:jedi#documentation_command = ""
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_command = ""
let g:jedi#goto_definitions_command = ""
let g:jedi#rename_command = ""
let g:jedi#usages_command = ""

nnoremap gu :GundoToggle<CR>

" Called with a command and a redirection target
"   (see `:help redir` for info on redirection targets)
" Note that since this is executed in function context,
"   in order to target a global variable for redirection you must prefix it with `g:`.
" EG call Redir('ls', '=>g:buffer_list')
funct! Redir(command, to)
    exec 'redir '.a:to
    exec a:command
    redir END
endfunct
" The last non-space substring is passed as the redirection target.
" EG
"   :R ls @">
"   " stores the buffer list in the 'unnamed buffer'
" Redirections to variables or files will work,
"   but there must not be a space between the redirection operator and the variable name.
" Also note that in order to redirect to a global variable you have to preface it with `g:`.
"   EG
"     :R ls =>g:buffer_list
"     :R ls >buffer_list.txt
command! -nargs=+ R call call(function('Redir'), split(<q-args>, '\s\(\S\+\s*$\)\@='))


" redir_messages.vim
"
" Inspired by the TabMessage function/command combo found
" at <http://www.jukie.net/~bart/conf/vimrc>.
"

function! RedirMessages(msgcmd, destcmd)
    "
    " Captures the output generated by executing a:msgcmd, then places this
    " output in the current buffer.
    "
    " If the a:destcmd parameter is not empty, a:destcmd is executed
    " before the output is put into the buffer. This can be used to open a
    " new window, new tab, etc., before :put'ing the output into the
    " destination buffer.
    "
    " Examples:
    "
    "   " Insert the output of :registers into the current buffer.
    "   call RedirMessages('registers', '')
    "
    "   " Output :registers into the buffer of a new window.
    "   call RedirMessages('registers', 'new')
    "
    "   " Output :registers into a new vertically-split window.
    "   call RedirMessages('registers', 'vnew')
    "
    "   " Output :registers to a new tab.
    "   call RedirMessages('registers', 'tabnew')
    "
    " Commands for common cases are defined immediately after the
    " function; see below.
    "
    " Redirect messages to a variable.
    "
    redir => message

    " Execute the specified Ex command, capturing any messages
    " that it generates into the message variable.
    "
    silent execute a:msgcmd

    " Turn off redirection.
    "
    redir END

    " If a destination-generating command was specified, execute it to
    " open the destination. (This is usually something like :tabnew or
    " :new, but can be any Ex command.)
    "
    " If no command is provided, output will be placed in the current
    " buffer.
    "
    if strlen(a:destcmd) " destcmd is not an empty string
        silent execute a:destcmd
    endif

    " Place the messages in the destination buffer.
    "
    silent put=message

endfunction

" Create commands to make RedirMessages() easier to use interactively.
" Here are some examples of their use:
"
"   :BufMessage registers
"   :WinMessage ls
"   :TabMessage echo "Key mappings for Control+A:" | map <C-A>
"
command! -nargs=+ -complete=command BufMessage call RedirMessages(<q-args>, ''       )
command! -nargs=+ -complete=command WinMessage call RedirMessages(<q-args>, 'new'    )
command! -nargs=+ -complete=command TabMessage call RedirMessages(<q-args>, 'tabnew' )

" end redir_messages.vim
