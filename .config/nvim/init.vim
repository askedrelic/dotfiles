set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath

" let g:python_host_prog = '/usr/bin/python'

" don't forget
" :checkhealth provider
" /usr/bin/python3 -m pip install neovim --user
let g:python3_host_prog = '/usr/bin/python3'

source ~/.vimrc
