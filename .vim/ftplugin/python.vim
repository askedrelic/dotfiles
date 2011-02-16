" Wrapping and tabs.
setl softtabstop=4 tabstop=4 shiftwidth=4 expandtab smarttab autoindent

" make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
"setl textwidth=79

" More syntax highlighting.
let python_highlight_all = 1

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
