#If not running interactively, don't do anything
[ -z "$PS1" ] && return

export HISTSIZE=20000
# Append to the history, rather than overwriting it
shopt -s histappend
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
#auto-completion shows stats similiar to ls -F
set visible-stats on

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

source ~/.bash_global

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export PATH=$PATH:.:/usr/local/bin:/opt/local/bin:/opt/local/sbin
