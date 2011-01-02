" Wrapping and tabs.
setl ts=4 sw=4 sta et sts=4 ai

" More syntax highlighting.
let python_highlight_all = 1

let python_slow_sync = 1

" Smart indenting
setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

"Don't show docs in preview window
setl completeopt-=preview

" Get this plugin from http://www.vim.org/scripts/script.php?script_id=1112
" Pressing "K" takes you to the documentation for the word under the cursor.
" autocmd filetype python source ~/.vim/pydoc.vim

" Wrap at 72 chars for comments.
" set formatoptions=cq textwidth=72 foldignore= wildignore+=*.py[co]

" `gf` jumps to the filename under the cursor.  Point at an import statement
" and jump to it!
python << EOF
import os
import sys
import vim
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF

" Use :make to see syntax errors. (:cn and :cp to move around, :dist to see
" all errors)
setl makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
setl efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

" Execute a selection of code (very cool!)
" Use VISUAL to select a range and then hit ctrl-h to execute it.
python << EOL
import vim
def EvaluateCurrentRange():
    eval(compile('\n'.join(vim.current.range),'','exec'),globals())
EOL
map <C-h> :py EvaluateCurrentRange()
