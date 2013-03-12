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

    " Local dirs
    set backupdir=~/.vim/backups
    set directory=~/.vim/swaps
    set undodir=~/.vim/undo

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
    " Don't try to highlight lines longer than 500 characters.
    set synmaxcol=500
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
    " set wildignore+=*/eggs/*,*/develop-eggs/*        " Python buildout
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
    " Enable extended regexes.
    set magic
    " Searches wrap around end of file
    set wrapscan
endfunction
call Searching()

function! Colors()
    syntax on
    set background=dark
    " One unified gui/terminal colorscheme
    colo Tomorrow-Night-Eighties

    if has("gui_running")
        " set guifont=Monaco:h12
        set guifont=Meslo\ LG\ M:h12

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
    hi DiffAdd      ctermfg=0 ctermbg=2 guibg=#cfffac
    hi DiffDelete   ctermfg=0 ctermbg=1 guibg=#ffb6b0
    hi DiffChange   ctermfg=0 ctermbg=3 guibg=#ffffcc
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
    set formatoptions+=o " Make comment when using o or O from comment line
    set formatoptions+=q " Format comments with gq
    set formatoptions+=n " Recognize numbered lists
    set formatoptions+=2 " Use indent from 2nd line of a paragraph
    set formatoptions+=l " Don't break lines that are already long
    set formatoptions+=1 " Break before 1-letter words
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
        " call Tabstyle_2spaces()

        "hitting % on <ul> jumps to <li> instead of </ul>
        au FileType html let b:match_words='<:>,<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'

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

    augroup END

    " Javascript
    augroup ft_javascript
        au!
        " call Tabstyle_2spaces()

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

    " map Ack.vim easier
    cab a Ack
    cab A Ack

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

    " have Y behave analogously to D and C rather than to dd and cc (which is
    " already done by yy):
    nnoremap Y yt$
    vnoremap Y yt$

    " clear the fucking search buffer, not just remove the highlight
    noremap <leader><space> :noh<cr>:call clearmatches()<cr>

    " search literally, without vim magic
    " nnoremap / /\V
    " nnoremap ? ?\V
    " nnoremap <leader>/ /\v
    " nnoremap <leader>? ?\v

    "Easy edit of vimrc
    nnoremap \ev :e! $MYVIMRC<CR>
    nnoremap \sv :source $MYVIMRC<CR>

    " Quit Vim
    nnoremap \Q :qall!<CR>

    " Kill buffer
    nnoremap \q :bd<CR>

    " Revert the current buffer
    nnoremap \r :e!<CR>

    " Show eeeeeeverything! http://www.youtube.com/watch?v=MrTsuvykUZk
    nnoremap \I :verbose set ai? si? cin? cink? cino? cinw? inde? indk? formatoptions? filetype? fileencoding? syntax? <CR>

    " toggle paste on/off
    nnoremap <leader>tp :set invpaste paste?<CR>
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
    nnoremap <leader>s :%s//<left>

    " ehh whatelse to bind
    nnoremap <leader>m :w<CR>:make<CR>

    " Join lines and restore cursor location (J)
    nnoremap J mjJ`j

    " Fix page up and down
    map <PageUp> <C-U>
    map <PageDown> <C-D>
    imap <PageUp> <C-O><C-U>
    imap <PageDown> <C-O><C-D>

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
    " vmap \r "sy:%s/<C-R>=substitute(@s,"\n",'\\n','g')<CR>/

    " Show number of occurrences of currently visually selected word
    "vmap \s "sy:%s/<C-R>=substitute(@s,"\n",'\\n','g')<CR>//n<CR>
    "
    " from https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim#L337
    function! CmdLine(str)
        exe "menu Foo.Bar :" . a:str
        emenu Foo.Bar
        unmenu Foo
    endfunction

    function! VisualSelection(direction) range
        let l:saved_reg = @"
        execute "normal! vgvy"

        let l:pattern = escape(@", '\\/.*$^~[]')
        let l:pattern = substitute(l:pattern, "\n$", "", "")

        if a:direction == 'b'
            execute "normal ?" . l:pattern . "^M"
        elseif a:direction == 'gv'
            call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
        elseif a:direction == 'replace'
            call CmdLine("%s" . '/'. l:pattern . '/')
        elseif a:direction == 'f'
            execute "normal /" . l:pattern . "^M"
        endif

        let @/ = l:pattern
        let @" = l:saved_reg
    endfunction

    " Visual mode pressing * or # searches for the current selection
    " Super useful! From an idea by Michael Naumann
    vnoremap <silent> * :call VisualSelection('f')<CR>
    vnoremap <silent> # :call VisualSelection('b')<CR>
    " When you press gv you vimgrep after the selected text
    vnoremap <silent> gv :call VisualSelection('gv')<CR>
    " When you press <leader>r you can search and replace the selected text
    vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

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

    " Highlight Word {{{
    "
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
    nnoremap <silent> <leader>1 :call HiInterestingWord(1)<cr>
    nnoremap <silent> <leader>2 :call HiInterestingWord(2)<cr>
    nnoremap <silent> <leader>3 :call HiInterestingWord(3)<cr>
    nnoremap <silent> <leader>4 :call HiInterestingWord(4)<cr>
    nnoremap <silent> <leader>5 :call HiInterestingWord(5)<cr>
    nnoremap <silent> <leader>6 :call HiInterestingWord(6)<cr>
    " Default Highlights
    hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
    hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
    hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
    hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
    hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
    hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

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
call pathogen#infect()

"Tabularize align options
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a* :Tabularize /=.*<CR>
vmap <Leader>a* :Tabularize /=.*<CR>
nmap <Leader>a> :Tabularize /=><CR>
vmap <Leader>a> :Tabularize /=><CR>
nmap <Leader>a: :Tabularize /:\zs/l0l1<CR>
vmap <Leader>a: :Tabularize /:\zs/l0l1<CR>
nmap <Leader>a, :Tabularize /,\zs/l0l1<CR>
vmap <Leader>a, :Tabularize /,\zs/l0l1<CR>
nmap <Leader>a  :Tabularize /
vmap <Leader>a  :Tabularize /

" Tagbar
let g:tagbar_left      = 1 " Open tagbar on the left
let g:tagbar_sort      = 0 " Sort tags by file order by default
let g:tagbar_compact   = 1 " Remove empty lines by default
" let g:tagbar_foldlevel = 0 " Close folds default
map <leader>t :TagbarOpenAutoClose<CR>

" NERDTree
map <silent> \n :NERDTreeMirrorToggle<CR>
map <silent> \N :NERDTreeFind<CR>
let NERDTreeWinPos              = 'right'
let NERDTreeChDirMode           = 0
let NERDTreeIgnore              = ['\.vim$', '\~$', '\.pyo$', '\.pyc$', '\.svn[\//]$', '\.swp$']
let NERDTreeSortOrder           = ['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']
let NERDTreeHighlightCursorline = 1
let NERDTreeShowFiles           = 1 " Show hidden files, too
let NERDTreeShowHidden          = 1
let NERDTreeMinimalUI           = 1 " Hide 'up a dir' and help message
" let NERDTreeDirArrows=0

" don't show nerdtree by default
let g:nerdtree_tabs_focus_on_files          = 0
let g:nerdtree_tabs_meaningful_tab_names    = 1
let g:nerdtree_tabs_open_on_console_startup = 0
let g:nerdtree_tabs_open_on_gui_startup     = 0
let g:nerdtree_tabs_open_on_new_tab         = 0
let g:nerdtree_tabs_smart_startup_focus     = 1
let g:nerdtree_tabs_synchronize_view        = 1

" ctrlp.vim
let g:ctrlp_map = '<c-n>'
nmap <c-b> :CtrlPBuffer<CR>
nmap <c-f> :CtrlPMRU<CR>
" let g:ctrlp_extensions = ['tag', 'buffertag']
let g:ctrlp_jump_to_buffer = 0 " disable this
let g:ctrlp_custom_ignore = '\v[\/](\.git|\.hg|\.svn|eggs)$'

let g:ctrlp_split_window = 1 " <CR> = New Tab
let g:ctrlp_open_new_file = 't' " Open newly created files in a new tab
let g:ctrlp_open_multiple_files = 't' " Open multiple files in new tabs


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
nnoremap <C-C> <Plug>CommentaryLine
" nnoremap <C-\> <Plug>CommentaryLine
xmap <leader>c <Plug>Commentary
au FileType htmldjango setlocal commentstring={#\ %s\ #}
au FileType python.django setlocal commentstring=#\ \%s
au FileType python setlocal commentstring=#\ \%s

" LustyJuggler
let g:LustyJugglerSuppressRubyWarning = 1

" Fugutive
map <silent> \gb :Gblame<CR>
map <silent> \gc :Gcommit -v<CR>
map <silent> \ge :Gedit<CR>
map <silent> \gl :Glog<CR>
map <silent> \gr :Gread<CR>
map <silent> \gs :Gstatus<CR>
map <silent> \gd :Gdiff<CR>
map <silent> \gx :!gitx<CR>
map \gg :Ack<Space>
map \ga :Git add --patch -- %<CR>

" SuperTab
let g:SuperTabLongestEnhanced = 1

" PyFlakes
let g:pyflakes_use_quickfix = 0

" rainbow parens
nnoremap <leader>tr :RainbowParenthesesToggleAll<CR>

" syntasticlet g:syntastic_mode_map = {
let g:syntastic_mode_map = { 'mode': 'passive',
                              \ 'active_filetypes': [],
                              \ 'passive_filetypes': [] }




function! GetBufferList()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
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
  let winnr = winnr()
  exec('bot '.a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>` :call ToggleList("Quickfix List", 'c')<CR>
let g:ackprg = 'ag --nogroup --nocolor --column'



" Speed up viewport scrolling
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Faster split resizing (+,-)
if bufwinnr(1)
  map + <C-W>+
  map - <C-W>-
endif

" Indent/unident block (,]) (,[)
nnoremap <leader>] >i{<CR>
nnoremap <leader>[ <i{<CR>
