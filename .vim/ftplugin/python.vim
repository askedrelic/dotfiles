" Wrapping and tabs.
setl expandtab
setl autoindent
setl shiftwidth=4
setl tabstop=4
setl softtabstop=4

setl formatoptions=croql

setlocal omnifunc=syntaxcomplete#Complete

" make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
"setl textwidth=79

" More syntax highlighting.
let python_highlight_all = 1

" @note: Fuck smartindent, it forces inserting tabs. Use cindent instead
setl cindent cinwords=if,elif,else,for,while,with,try,except,finally,def,class

"Don't show docs in preview window
setl completeopt-=preview

" Wrap at 72 chars for comments.
" set formatoptions=cq textwidth=72 foldignore= wildignore+=*.py[co]

" @note This blows up omnifunc complete
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

" Use :make to see syntax errors. (:cn and :cp to move around, :dist to see
" all errors)
setl makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
setl efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
