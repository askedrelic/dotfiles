#If not running interactively, don't do anything
[ -z "$PS1" ] && return

export HISTSIZE=20000
# Append to the history, rather than overwriting it
shopt -s histappend
# Whenever displaying the prompt, write the previous line to disk:
PROMPT_COMMAND='history -a'
# Concatenate multi-line commands
shopt -s cmdhist
# check the window size after each command and, if necessary,                                                                        
# update the values of LINES and COLUMNS.                                                                                            
shopt -s checkwinsize  

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth
export HISTIGNORE="&:ls:l:p:[bf]g:exit"

export EDITOR="vim"

#single tab auto-completition
set show-all-if-ambiguous on
set completion-ignore-case on
#fix spelling errors in cd
shopt -s cdspell
#auto-completion shows stats similiar to ls -F
set visible-stats on

source ~/.bash_global

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export PATH=$PATH:.:/usr/local/bin:/opt/local/bin:/opt/local/sbin
