# I know I've used that command before...
export HISTSIZE=20000
# Append to the history, rather than overwriting it
shopt -s histappend
# Concatenate multi-line commands
shopt -s cmdhist
# Ignore duplicates, ls without options and builtin commands
HISTCONTROL=ignoredups
export HISTIGNORE="&:ls:l:p:[bf]g:exit"
export EDITOR="vim"
alias p="pwd"
alias mate="mate -d"
alias vi=vim
alias vim=vim
#single tab auto-completition
set show-all-if-ambiguous on
set completion-ignore-case on
#auto-completion shows stats similiar to ls -F
set visible-stats on

source ~/.bash_global

export PATH=$PATH:/usr/local/bin:/usr/local/mysql/bin/:/opt/local/bin:/opt/local/sbin
