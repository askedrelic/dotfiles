set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath

" let g:python_host_prog = '/usr/bin/python'

" don't forget
" :checkhealth provider
" /opt/homebrew/bin/python3 -m pip install --user --break-system-packages pynvim

if executable('/opt/homebrew/bin/python3')
  let g:python3_host_prog = '/opt/homebrew/bin/python3'
endif

let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0

source ~/.vimrc
